# BSG DRADIS Contacts Test

This complete editable project adds moving, depth-scaled contacts and a double-beep arrival sound to the BSG DRADIS copy whose sweep audio was confirmed working on Mac. The Godot display name remains **BSG DRADIS**; use the separate folder **BSG_DRADIS_Contacts_Test** to distinguish it from earlier copies.

## Open on your Mac

1. Keep the working audio-test project intact.
2. Download and extract `BSG_DRADIS_Contacts_Test_2026-10-01.zip` into a separate location. Cancel if Finder asks to replace an existing folder.
3. In Godot 4.7's Project Manager, click **Import** and choose `project.godot` inside `BSG_DRADIS_Contacts_Test`.
4. Open that project, allow importing to finish, then click **Run Project** at the upper right.
5. Press **F1** to hide the existing tuning panel if it obscures your view. Depending on your Mac keyboard settings, use Fn-F1.

Godot may list multiple projects with the same BSG DRADIS title. Choose the entry whose path ends in `BSG_DRADIS_Contacts_Test`.

## What to expect

- **Opening arrivals:** A red Raider, green Raptor, amber unknown, then a green Viper appear one at a time over roughly the first four seconds. The first three get a beep-beep; the Viper does not.
- **More waves:** Random groups of two to four contacts follow at approximately nine-second intervals. Arrivals are staggered so the double-beeps do not overlap.
- **Motion and depth:** Contacts travel through a normalized 3D scope volume. Positive depth is farther from the viewer; near contacts appear larger and far contacts smaller. Symbol size and projected position update together during movement.
- **Ship sizes:** Capital symbols are larger than single craft. Squadron and fleet symbols use three smaller constituent marks.
- **Classification:** Green is friendly, red is hostile, amber is unknown. Small F-, H-, and U-prefixed IDs distinguish individual contacts.
- **Arrival sound:** One original, synthesized beep-beep per new non-Viper contact, including friendly Raptors. Both single Vipers and Viper squadrons remain silent. Movement does not replay the sound.
- **Lifetime:** Contacts leave the display at the end of their passes. The default cap is 14 contacts, preventing unbounded accumulation.

The icons are vector interpretations of the supplied reference sheet, not new generic triangles. The animated rings remain independent ambient graphics: contacts are not attached to or rotated by the ring animation.

## Inspector controls

Stop the game, then select **DradisConsole → CenterContainer → Dome → Contacts** in the Scene tree. Adjust these exported values in the Inspector and save the scene.

| Control | Default | Purpose |
|---|---:|---|
| Auto Spawn | On | Generate arrival waves automatically |
| Max Contacts | 14 | Limit active contacts |
| Wave Interval Seconds | 9.0 | Time between groups |
| Arrival Gap Seconds | 0.85 | Spacing between contacts; minimum 0.5 seconds |
| Movement Speed | 1.0 | Speed multiplier for all contact passes |
| Icon Size | 1.0 | Scale all symbols |
| Show Labels | On | Show alphanumeric IDs |
| Random Seed | 0 | Zero varies runs; a nonzero value makes them repeatable |
| Perspective Distance | 2.8 | Larger values make perspective more subtle |
| Depth Strength | 1.0 | Zero disables depth-based scaling |
| Friendly / Hostile / Unknown Color | Green / Red / Amber | Contact colors only |
| Arrival Sound Enabled | On | Mute or enable contact arrivals independently |
| Arrival Volume Db | -8.0 | Double-beep volume; does not change sweep volume |

Icons also follow the Dome's sphere radius if you change that Inspector value. Labels have a minimum font size for readability even when icons become smaller in the distance.

The F1 tuning panel is preserved unchanged; the new contact controls are in the Inspector, not that panel.

## Quick acceptance test

Run for at least one minute at a comfortable volume. Check that the sweep continues, contacts remain inside the radar, their sizes change smoothly as they move in depth, and every new non-Viper gets two short beeps.

Check that the opening Viper is silent and that the appearance of the rings has not changed. Stop and run again; the opening contact types repeat, though their paths vary by default.

Report any misplaced contacts, unexpected beeps, or size preferences. If Godot shows red errors, copy them from the Output or Debugger panel.

## Boundaries of this build

The four console buttons retain their existing placeholder behavior. LAUNCH VIPERS interception, HAIL, RED ALERT, PROX DEFENSE, combat, and a full gameplay HUD are not implemented by this contacts-only change.

Depth scaling is a perspective interpretation of moving nearer/farther in the scope, not a physical-distance simulation or a change to ring geometry. Icons are depth-sorted; contact labels can overlap when paths cross.

All previously existing files except the main scene remain byte-for-byte unchanged. The scene only gains a child contact overlay and its script reference; its existing node settings are preserved.

Automated runtime and rendering checks use Godot 4.4.1 on Linux. This contacts build still requires your Godot 4.7 Mac field test, even though the earlier audio-only baseline worked there.

Use this guide for this build. `README.md`, `AUDIO_TEST_START_HERE.md`, and `AUDIO_TEST_CHANGELOG.md` are retained historical documents; they do not describe the newly added contacts.

The new beep pair is synthesized from original sine-wave code. Existing reference-derived sweep audio is unchanged and remains a separate rights-clearance issue for any public release.
