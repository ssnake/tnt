# TnT

`TnT` is a Windows clone of the MS-DOS game **Mine Bombers**.

Reference (Finnish): https://fi.wikipedia.org/wiki/Mine_Bombers

## About

This is a classic Delphi game project (originally around 2000) that recreates the local multiplayer bomb-battle gameplay style of Mine Bombers.

## Gameplay

- Local multiplayer on a single PC
- Up to **3 players** sharing the same keyboard
- Different weapons and destructible map tiles

## Key Controls

Default keyboard bindings:

- Player 1
  - Move: Arrow keys (`← ↑ → ↓`)
  - Stop: `Backspace`
  - Place bomb / fire: `Enter`
  - Select weapon: `Ctrl`
  - Trigger remote detonators: `Space`

- Player 2
  - Move: `S E D F`
  - Stop: `1`
  - Place bomb / fire: `Q`
  - Select weapon: `A`
  - Trigger remote detonators: `Z`

- Player 3
  - Move: Numpad `4 8 6 5`
  - Stop: Numpad `0`
  - Place bomb / fire: Numpad `1`
  - Select weapon: Numpad `.`
  - Trigger remote detonators: Numpad `2`

## Tech Stack

- Language: Delphi (Object Pascal)
- Platform: Windows
- Graphics: bitmap-based sprites and tiles

## Build

A helper script is included:

- `build.bat` — auto-detects installed RAD Studio/Delphi, loads `rsvars.bat`, and builds `TnT.dpr` using `dcc32`.

Run from the repository root:

```bat
build.bat
```

## Notes

- This repository preserves retro code and structure from an old Delphi-era game project.
- `.dcu` and `.exe` artifacts are excluded from version control via `.gitignore`.
