# BSG DRADIS Interception Test

This complete project continues from the contacts build confirmed working on Mac. It adds button-launched Viper interceptions, ship-class speeds, a light launch whoosh, and a quieter background sweep without changing the ambient radar graphics.

Only **Vipers, enemy Raiders, amber unknowns, and enemy Baseships** are active. The other reference symbols are retained in the source but cannot spawn in this build.

## Open this copy

1. Keep the working contacts project intact.
2. Extract `BSG_DRADIS_Intercept_Test_2026-10-01.zip` into a separate folder.
3. In Godot's Project Manager, choose **Import** and select `project.godot` inside **BSG_DRADIS_Intercept_Test**.
4. Open the project, wait for importing, and click **Run Project**.
5. Hide the existing tuning panel with **F1** if needed (Fn-F1 on some Mac keyboard configurations).

The project title remains **BSG DRADIS**. Use the folder path to distinguish this copy from the earlier ones; do not replace or delete them.

## Try the new behavior

Wait for the first red contact, then click **LAUNCH VIPERS**. A light whoosh accompanies a pair of green Vipers entering from below the bottom edge of the screen.

They first climb into the lower part of the radar, then pursue red contacts. They do not attack green friendlies or amber unknowns. Vipers no longer appear in random incoming waves.

If a target leaves or another Viper intercepts it, the Viper finds another red contact. If none remain, it patrols inside the scope. At the end of its default 45-second sortie, it returns downward off-screen and frees its slot.

This is the first interception mechanic: reaching a red contact clears it with a short visual flash. It is not yet a dogfight or damage/armor simulation; capital ships currently use the same one-interception outcome.

## Launch controls

- **Pair per click:** Two Vipers by default; if only one slot remains, one launches.
- **Cooldown:** Four seconds, displayed on the launch button.
- **Capacity:** Up to six active Vipers, separately from the 14 ambient contacts. A full radar does not block the first Viper launch.
- **Full capacity:** The button shows `VIPERS DEPLOYED` until a slot becomes available.
- **Whoosh:** One short whoosh per successful launch action. A rejected launch makes no sound.
- **Arrival beep rule:** Vipers never play the contact-detection beep-beep. The new whoosh is a separate launch effect; squadron contacts are disabled in this build.

## Ship movement

Baseships now drift slowly; Raiders and Vipers move faster. Vipers retain subtle perspective scaling while entering, pursuing, patrolling, and returning.

| Class | Default speed in scope-radius units/second |
|---|---:|
| Baseship | 0.012 |
| Unknown | 0.035 |
| Raider | 0.09 |
| Viper | 0.24 |

These are prototype gameplay speeds, not physical ship dimensions or canonical performance values. The existing Movement Speed value multiplies all classes.

## Smaller fighters, larger Baseships

Viper and Raider icons use a fixed **0.75×** class-size multiplier; Baseships use **1.35×** on top of their already larger capital symbol. Unknown symbols retain their previous class size.

Depth Strength is reduced from 1.0 to **0.25**. At the default perspective distance, near-to-far size variation across ordinary contact paths is approximately 12% rather than approximately 57%; a distant Baseship remains larger than a nearby fighter.

Adjust **Ship Sizes → Small Ship Icon Scale / Baseship Icon Scale** on the Contacts node to tune the class difference. **Depth → Depth Strength** controls only the mild perspective change, and **Icon Size** remains the overall size control.

## Audio mix

The sweep is now **−14 dB**, down from the earlier forced 0 dB. The original sound file, loop endpoint repair, pulse timing, and ring animation are unchanged.

To tune it, stop the game, select the top **DradisConsole** node, and open **Audio Mix → Sweep Volume Db** in the Inspector. More-negative values are quieter; for example, try -18 if the background still feels too loud.

Select **DradisConsole → CenterContainer → Dome → Contacts** for the new controls:

- **Ship Speeds:** Capital Speed, Normal Ship Speed, Small Hostile Speed, Viper Speed.
- **Ship Sizes:** Small Ship Icon Scale and Baseship Icon Scale, independent of perspective.
- **Viper Launch:** Max Vipers, Vipers Per Launch, Launch Cooldown Seconds, Sortie Seconds, Launch Sound Enabled, Launch Volume Db.
- **Existing controls:** Contact size, perspective depth, wave timing, colors, and arrival beep volume remain available.

The light whoosh defaults to -12 dB. The non-Viper double-beep remains at -8 dB.

## What is deliberately unchanged

The quiet background rings, sphere, ripples, scanlines, underlying icon shapes, and tuning panel are preserved. The scene layout and existing node settings are unchanged; only contact sizing and the launch button's runtime status text and enabled state change on screen.

The F-/H-/U-number labels remain for now. Labels that show ship type are recorded as a future improvement, not included in this iteration.

HAIL, RED ALERT, and PROX DEFENSE still have placeholder behavior. There are no weapon projectiles, health, friendly losses, scoring, replenishment costs, or full combat balancing yet.

## Acceptance check

Run for one minute and launch while red contacts are visible. Confirm Vipers visibly enter from below, chase red contacts, play a light whoosh instead of detection beeps, and keep their depth scaling.

Listen for the sweep as a background sound rather than a foreground effect. Check that large ships drift while small combat craft move faster, then stop and run again.

Confirm that no other ship types appear, fighters remain compact, Baseships remain distinctively larger, and movement no longer causes dramatic size changes.

Automated checks use Godot 4.4.1 Linux. This new build still requires your Godot 4.7 Mac confirmation; no standalone Mac or Windows binary is supplied.

Use this guide for this iteration. Earlier README and audio/contacts guides are retained as history and include superseded instructions.

The whoosh and contact beep are original synthesized effects. The unchanged reference-derived sweep remains a separate rights-clearance issue before any public release.
