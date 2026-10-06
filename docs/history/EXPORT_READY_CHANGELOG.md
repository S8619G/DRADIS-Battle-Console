# Export Ready Test Changelog (2026-10-02)

Builds on the Combat Tuning Test.

## Fixed

- Exported games (Windows .exe, Mac .app) had no DRADIS sweep and no identification alert, because those two sounds were read as raw files that Godot leaves out of exports. They now use Godot's exported copy when the raw file is absent.
- The identification alert is set to import as uncompressed PCM, so the exported copy has exactly the same samples as the approved sound.

## Added

- Windows Desktop export preset: x86_64, single .exe with embedded game data, no console wrapper, BSG DRADIS file details.
