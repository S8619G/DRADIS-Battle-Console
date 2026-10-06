# BSG DRADIS Audio Test

This is a complete editable copy of BSG DRADIS, including the existing graphics, scenes, audio, tuning controls, and reference files. The only application change is a correction to the sweep audio's loop endpoint, plus a diagnostic print of that endpoint.

The project name inside Godot remains **BSG DRADIS**. The containing folder is named **BSG_DRADIS_Audio_Test** so it can sit beside the original without replacing it.

## Open the test copy on your Mac

1. Stop the running game and close its editor window.
2. Download `BSG_DRADIS_Audio_Test_2026-10-01.zip`.
3. In Finder, double-click the ZIP to extract `BSG_DRADIS_Audio_Test`. Keep this folder somewhere separate from the current project. If Finder asks to replace an existing folder, cancel and choose another location.
4. Open Godot 4.7 and go to its Project Manager.
5. Click **Import**, browse into `BSG_DRADIS_Audio_Test`, and select **project.godot**.
6. Confirm the import and open the project. Allow asset importing to finish.
7. Click the triangular **Run Project** button in the upper-right corner. F5 also runs the project; depending on the Mac keyboard settings, Fn-F5 may be needed.

Both project entries may show the same BSG DRADIS title. Check the folder path and open the one ending in `BSG_DRADIS_Audio_Test`.

## Test the audio

1. Begin at a comfortable speaker volume; this copy preserves the existing audio volume setting.
2. Let the game run for at least **30 seconds**. The sweep should continue past the old four-second stopping point.
3. Do not adjust the rotation slider during this first test. Audio/animation phase locking is separate from this playback repair.
4. Confirm the graphics still look as expected.
5. Stop the game using Godot's Stop button, then run it again and listen for another 10 seconds.

Report whether sound is present, whether it continues for the full test, and whether it works after stop/restart. If it is still silent or stops, copy the lines beginning `[AUDIO]` and any red errors from Godot's Output panel.

The updated diagnostic should include:

```text
[AUDIO] loop_mode set to LOOP_FORWARD; loop_end=191978
```

## What changed and what did not

- **Changed:** The sweep now loops across its actual sample frames instead of an empty zero-to-zero range.
- **Unchanged:** Graphics, ring geometry, colors, thickness, glow, rotation settings, ripples, scanlines, UI, tuning controls, audio recordings, and existing button behavior.
- **Not added:** New gameplay, synchronized-clock redesign, or a standalone macOS application.

The original `README.md` is retained byte-for-byte for source traceability, but it describes an older preview. Use this guide for this audio test; in particular, audio assets are present in this copy.

## Safety and test status

Keep your original project. No files from it need to be deleted or replaced, and you can reopen it at any time.

This is an editor-importable source package, not a signed or notarized macOS app. Automated tests use Godot 4.4.1 on Linux; audible playback in your Godot 4.7 on Mac still needs your confirmation.

The existing reference-derived recording is retained for this private development test. This package does not establish rights clearance for distributing that audio publicly.
