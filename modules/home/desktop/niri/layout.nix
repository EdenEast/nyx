{...}:
# kdl
''
  input {
    keyboard {
      numlock
    }

    touchpad {
      tap
      natural-scroll
    }

    focus-follows-mouse
  }

  layout {
    gaps 4

    center-focused-column "never"
    always-center-single-column

    preset-column-widths {
      proportion 0.5
      proportion 0.66667
      proportion 1.0
    }

    default-column-width { proportion 0.5; }

    border {
      width 2
      active-color "#cba6f7"
      inactive-color "#45475a"
      urgent-color "#f5c2e7"
    }

    focus-ring {
      off
      width 2
      active-color   "#808080"
      inactive-color "#505050"
    }

    shadow {
      softness 30
      spread 5
      offset x=0 y=5
      color "#0007"
    }
  }
''
