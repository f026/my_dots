import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
    id: root

    property int selectedIndex: 0

    IpcHandler {
        target: "switcher"

        function next(): void {
            const count = Hyprland.toplevels.count

            console.log("COUNT:", count)
            console.log("BEFORE:", root.selectedIndex)

            if (count === 0)
                return

            root.selectedIndex =
                (root.selectedIndex + 1) % count

            console.log("AFTER:", root.selectedIndex)

            for (let i = 0; i < count; ++i) {
                const window = Hyprland.toplevels.get(i)

                if (window)
                    console.log(
                        i,
                        window.address,
                        window.title,
                        window.activated
                    )
            }
        }
    }
}
