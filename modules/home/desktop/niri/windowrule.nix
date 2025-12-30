_:
# kdl
''
  // Global window styling
  window-rule {
    geometry-corner-radius 9
    clip-to-geometry true
    draw-border-with-background false
  }

  // Zen Browser and Zed settings
  window-rule {
    match app-id=r#"^(zen-beta|dev)$"#
    opacity 0.98
    default-column-width { proportion 0.75; }
  }

  // Commented out: Steam fullscreen rule
  window-rule {
    match app-id="steam"
    exclude title="^Steam$"
    open-fullscreen true
  }
''
