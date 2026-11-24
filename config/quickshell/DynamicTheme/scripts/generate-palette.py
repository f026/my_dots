
#!/usr/bin/env python3

import sys
import json
import hashlib
import colorsys
import math

from pathlib import Path
from PIL import Image, ImageOps


CACHE_DIR = Path.home() / ".cache/quickshell/dynamic-theme"
ALGORITHM_VERSION = "10"


# ============================================================
# COLOR HELPERS
# ============================================================

def clamp(value, low=0.0, high=1.0):
    return max(low, min(high, value))


def hex_color(rgb):
    return "#{:02x}{:02x}{:02x}".format(*rgb)


def adjust_hsl(h, s, l):
    r, g, b = colorsys.hls_to_rgb(
        h % 1.0,
        clamp(l),
        clamp(s)
    )

    return tuple(
        round(clamp(v) * 255)
        for v in (r, g, b)
    )


# ============================================================
# WALLPAPER COLOR EXTRACTION
# ============================================================

def extract_colors(path):
    image = Image.open(path)
    image = ImageOps.exif_transpose(image)
    image = image.convert("RGB")
    image.thumbnail((160, 160))

    quantized = image.quantize(
        colors=24,
        method=Image.Quantize.MEDIANCUT
    )

    palette = quantized.getpalette()
    counts = quantized.getcolors(160 * 160)

    # Собираем цветовые образцы. Очень тёмные пиксели оставляем:
    # они могут содержать основной оттенок космических/ночных обоев.
    samples = []

    for count, index in counts:
        rgb = tuple(palette[index * 3:index * 3 + 3])

        r, g, b = [v / 255 for v in rgb]
        h, l, s = colorsys.rgb_to_hls(r, g, b)

        if s < 0.10 or l < 0.06:
            continue

        samples.append({
            "count": count,
            "hue": h,
            "saturation": s,
            "lightness": l,
        })

    if not samples:
        return 0.68, 0.55, 0.55, None, None

    # Объединяем близкие оттенки по круговому расстоянию Hue.
    # Это не привязано к границам фиксированных hue-секторов.
    samples.sort(key=lambda item: item["hue"])
    groups = []

    for sample in samples:
        best_group = None
        best_distance = 1.0

        for group in groups:
            distance = abs(sample["hue"] - group["hue"])
            distance = min(distance, 1.0 - distance)

            if distance < best_distance:
                best_distance = distance
                best_group = group

        if best_group is not None and best_distance <= 0.075:
            weight = best_group["count"]
            new_weight = sample["count"]
            total = weight + new_weight

            # Среднее Hue по окружности, чтобы корректно обработать
            # переход между 0.99 и 0.01.
            new_angle = sample["hue"] * 2 * math.pi

            x = (
                best_group["hue_x"] * weight
                + math.cos(new_angle) * new_weight
            )
            y = (
                best_group["hue_y"] * weight
                + math.sin(new_angle) * new_weight
            )

            best_group["hue_x"] = x / total
            best_group["hue_y"] = y / total
            best_group["hue"] = (
                math.atan2(y, x) / (2 * math.pi)
            ) % 1.0

            best_group["saturation"] = (
                best_group["saturation"] * weight
                + sample["saturation"] * new_weight
            ) / total
            best_group["lightness"] = (
                best_group["lightness"] * weight
                + sample["lightness"] * new_weight
            ) / total
            best_group["count"] = total
        else:
            angle = sample["hue"] * 2 * math.pi
            groups.append({
                **sample,
                "hue_x": math.cos(angle),
                "hue_y": math.sin(angle),
            })

    total_color_count = sum(group["count"] for group in groups)
    candidates = []

    for group in groups:
        hue = group["hue"]
        saturation = group["saturation"]
        lightness = group["lightness"]
        count = group["count"]

        # Базовая оценка: площадь цветовой группы и насыщенность.
        score = count * (saturation ** 0.7)

        # Слегка уменьшаем влияние очень светлых бликов и усиливаем
        # тёмные цветовые массы, чтобы космические обои не становились
        # золотыми из-за небольшого светлого участка.
        if lightness > 0.65:
            score *= 0.55
        elif lightness < 0.40:
            score *= 1.0 + 2.0 * ((0.40 - lightness) / 0.40)

        candidates.append({
            "score": score,
            "hue": hue,
            "saturation": saturation,
            "lightness": lightness,
            "count": count,
        })

    candidates.sort(key=lambda item: item["score"], reverse=True)
    best = candidates[0]

    # Зелёный выбирается только тогда, когда он действительно занимает
    # заметную часть изображения. Это помогает обоям с зелёным полем,
    # но не даёт небольшим зелёным деталям перетягивать красные/коралловые.
    green_candidates = [
        candidate for candidate in candidates
        if 0.20 <= candidate["hue"] <= 0.43
        and candidate["count"] >= total_color_count * 0.20
        and candidate["score"] >= best["score"] * 0.25
    ]

    if green_candidates:
        primary_candidate = max(
            green_candidates,
            key=lambda item: item["score"]
        )
    else:
        primary_candidate = best

    # Ищем отдельную заметную цветовую группу для дополнительного акцента.
    # Она должна отличаться от основного оттенка и занимать достаточно
    # большую часть изображения, чтобы мелкие детали не влияли на тему.
    secondary_candidates = []

    for candidate in candidates:
        hue_distance = abs(candidate["hue"] - primary_candidate["hue"])
        hue_distance = min(hue_distance, 1.0 - hue_distance)

        if (
            hue_distance >= 0.10
            and candidate["count"] >= total_color_count * 0.08
            and candidate["score"] >= best["score"] * 0.18
        ):
            secondary_candidates.append(candidate)

    secondary_candidate = (
        max(secondary_candidates, key=lambda item: item["score"])
        if secondary_candidates
        else None
    )

    return (
        primary_candidate["hue"],
        primary_candidate["saturation"],
        primary_candidate["lightness"],
        secondary_candidate["hue"] if secondary_candidate else None,
        secondary_candidate["saturation"] if secondary_candidate else None,
    )


# ============================================================
# PALETTE GENERATION
# ============================================================

def generate(path, mode="auto"):

    hue, saturation, lightness, accent_hue, accent_saturation = extract_colors(path)

    # Принудительная холодная гамма.
    if mode == "cold":
        hue = 0.58
        saturation = 0.48
        lightness = 0.58

    # Основной акцент.
    primary = adjust_hsl(
        hue,
        max(0.0, saturation * 0.85),
        0.72
    )

    # Вторичный оттенок.
    secondary = adjust_hsl(
        hue + 0.11,
        max(0.38, saturation * 0.65),
        0.76
    )

    # Дополнительный акцент.
    if accent_hue is not None:
        accent = adjust_hsl(
            accent_hue,
            max(0.50, accent_saturation * 0.75),
            0.83
        )
    else:
        accent = adjust_hsl(
            hue + 0.035,
            max(0.50, saturation * 0.75),
            0.83
        )

    # Фон.
    background = adjust_hsl(
        hue,
        min(0.20, saturation * 0.25),
        0.105
    )

    # Поверхности.
    surface = adjust_hsl(
        hue,
        min(0.24, saturation * 0.32),
        0.145
    )

    surface_variant = adjust_hsl(
        hue,
        min(0.28, saturation * 0.38),
        0.205
    )

    # Границы.
    border = adjust_hsl(
        hue,
        min(0.28, saturation * 0.40),
        0.29
    )

    return {
        "background": hex_color(background),
        "surface": hex_color(surface),
        "surfaceVariant": hex_color(surface_variant),
        "primary": hex_color(primary),
        "secondary": hex_color(secondary),
        "accent": hex_color(accent),
        "text": hex_color(adjust_hsl(hue, 0.12, 0.94)),
        "subtext": hex_color(adjust_hsl(hue, 0.10, 0.72)),
        "border": hex_color(border),
        "onPrimary": "#17151d"
    }


# ============================================================
# MAIN
# ============================================================

def main():

    if len(sys.argv) < 2:
        raise SystemExit(
            "Usage: generate-palette.py IMAGE [auto|cold]"
        )

    path = Path(sys.argv[1]).expanduser().resolve()

    mode = (
        sys.argv[2].lower()
        if len(sys.argv) > 2
        else "auto"
    )

    if mode not in ("auto", "cold"):
        raise SystemExit(
            f"Unknown palette mode: {mode}"
        )

    if not path.is_file():
        raise SystemExit(
            f"Wallpaper not found: {path}"
        )

    stat = path.stat()

    cache_key = hashlib.sha256(
        (
            f"{ALGORITHM_VERSION}:"
            f"{mode}:"
            f"{path}:"
            f"{stat.st_mtime_ns}:"
            f"{stat.st_size}"
        ).encode()
    ).hexdigest()

    CACHE_DIR.mkdir(
        parents=True,
        exist_ok=True
    )

    cache_file = CACHE_DIR / f"{cache_key}.json"

    if cache_file.exists():
        print(cache_file.read_text())
        return

    palette = generate(path, mode)

    result = json.dumps(palette)

    cache_file.write_text(result)

    print(result)


# ============================================================
# ENTRY POINT
# ============================================================

if __name__ == "__main__":
    try:
        main()

    except Exception as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)

