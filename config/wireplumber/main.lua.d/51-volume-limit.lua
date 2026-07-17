volume_controller.rules = {
  {
    matches = { { { "node.name", "matches", "*" } } },
    apply_properties = {
      ["volume.limit"] = 1.0,
    },
  },
}
