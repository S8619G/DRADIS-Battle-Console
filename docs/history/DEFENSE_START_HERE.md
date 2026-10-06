# BSG DRADIS Ship Defense Test

The radar now represents a large area of space with your unseen ship near the lower edge of the circular field. Basestars appear far out in the upper area and stay fixed, launching Raiders and missiles; your goal is to protect the ship and use FTL to escape when necessary.

This complete editable project remains named **BSG DRADIS** in Godot. Its separate folder is **BSG_DRADIS_Defense_Test**, and the previous copies should be kept intact.

## Open this copy on Mac

1. Extract `BSG_DRADIS_Defense_Test_2026-10-01.zip` into a separate location.
2. Open Godot 4.7's Project Manager and click **Import**.
3. Choose `project.godot` inside **BSG_DRADIS_Defense_Test**, then open the project.
4. Allow importing to finish and click **Run Project**.
5. Press **F1** to hide the existing tuning panel if needed (Fn-F1 on some Mac keyboards).

Use this guide for this build. Older audio, contacts and interception guides are retained as history and contain superseded behavior.

## How the field works

- **Your ship:** Unseen near the bottom edge of the radar field. Vipers now originate at this point rather than from below the whole window, matching the clarified field layout.
- **Basestars:** Red, large and stationary in the farther upper region. Up to two appear by default, with separation between them.
- **Raiders:** Small red fighters launched from the edge of a real Basestar. They approach and patrol the lower-middle area, drawing Vipers away from missile defense.
- **Unknowns:** Amber contacts appear randomly in the upper half and drift across that region.
- **Missiles:** Small red arrowheads with short tails and M-prefixed IDs. They leave a Basestar edge and fly only toward your unseen ship.
- **Vipers:** Small green fighters launched by the player. They can intercept Raiders and missiles, never Basestars or unknowns.

The four active ship types remain Viper, Raider, unknown and Basestar; missiles are an additional projectile type, not another ship type. Compact fighter sizes, larger capital symbols and mild depth scaling are preserved.

Basestars do not drift, disappear on a timer, or get destroyed by Vipers. Raiders and missiles cannot randomly appear without a parent Basestar.

## Controls and objective

### LAUNCH VIPERS

Launches two Vipers by default with a light whoosh and no detection beep. Vipers physically pursue eligible targets, prioritizing nearby incoming missiles, but they cannot instantly destroy a missile that is already too close to the ship.

The four-second launch cooldown and six-Viper capacity remain. Vipers patrol when no eligible targets exist and return to the unseen ship after their default 45-second sortie, freeing slots.

### PROX DEFENSE

This is now an ON/OFF toggle. While active, it gets **one 75% chance per missile** when that missile reaches the defensive zone near your ship.

A missile that evades this attempt can still hit. Toggling defense repeatedly does not give that same missile extra rolls; turning defense on late still gives an unchecked nearby missile its one opportunity.

The Inspector allows tuning the chance, but runtime protection is capped at 95%, so proximity defense is never guaranteed. It does not attack Raiders or Basestars.

### FTL JUMP

Replaces RED ALERT. It starts ready by default; after use it requires **45 seconds** to recharge.

A jump clears the current encounter, live missiles, queued launches, and Vipers from the field. This prototype treats your Vipers as recovered with the jump, so launch capacity becomes available again after the safe interval.

There are **8 seconds of clear space** before new distant contacts can appear. The FTL countdown runs during that time, and ship damage is retained: jumping escapes danger but does not repair the hull.

### HAIL

Still a placeholder. Identification, friendly interactions and ship-type label content remain future work.

## Hull and loss

The top readout shows hull, Raider count, missile count, active Vipers, and jumps. A missile reaching the unseen ship removes **15 hull** from the starting **100**.

At zero hull, the encounter freezes and launch, defense, HAIL and FTL controls are disabled. Click **START NEW RUN** to reset hull, contacts, weapons, counters, and recharge state without restarting Godot.

Only missile impacts damage the ship in this prototype. Raiders currently pressure the defense by occupying interceptors; they do not yet shoot or ram the ship, and Vipers do not yet have individual health.

## Useful Inspector controls

Select **DradisConsole → CenterContainer → Dome → Contacts** with the game stopped, then save the scene after editing.

| Group | Control | Default |
|---|---|---:|
| Battlefield | Own Ship Position | `(0, -0.82, -0.15)` |
| Battlefield | Max Basestars | 2 |
| Battlefield | Max Raiders / Max Missiles | 8 / 10 |
| Battlefield | Raider Launch Interval | 7 seconds |
| Battlefield | Missile Launch Interval | 11 seconds |
| Battlefield | Missile Speed | 0.20 scope-radius units/second |
| Ship Defense | Max Hull / Missile Damage | 100 / 15 |
| Ship Defense | Prox Defense Radius | 0.28 scope-radius units |
| Ship Defense | Prox Success Chance | 0.75 |
| FTL | FTL Recharge Seconds | 45 |
| FTL | Post Jump Safe Seconds | 8 |
| FTL | FTL Starts Ready | On |
| Ship Sizes | Small Ship / Baseship Icon Scale | 0.75 / 1.35 |
| Depth | Depth Strength | 0.25 |

Basestar launcher intervals have a little random variation, and all non-Viper arrival beeps are staggered through a shared queue. The first fighter appears roughly 5–7 seconds after the first Basestar, and its first missile follows later.

The old capital-movement speed control is removed because Basestars are now fixed. Unknowns, Raiders, Vipers and missiles retain separate speeds.

On the top **DradisConsole** node, **Audio Mix → Sweep Volume Db** remains -14 dB. Contact beep and launch whoosh volumes remain independently editable on Contacts.

## What is preserved

The ambient dome/rings, ring colors and thicknesses, ripples, scanlines, tuning panel, original icon shapes, original audio assets and sweep-loop repair are unchanged. Added readouts and button states provide gameplay feedback without brightening the background rings.

Alphanumeric IDs remain temporary. Ship-type label text and overlapping-label handling are not included here.

## Try a complete encounter

1. Let a Basestar and unknown appear in the upper region.
2. Watch a Raider emerge from the Basestar, then launch Vipers.
3. Watch for red missile arrowheads heading down toward your unseen ship.
4. Toggle proximity defense and observe that some missiles may still get through.
5. Watch the hull readout. Use FTL while it is ready and confirm the field clears but damage remains.
6. Confirm FTL cannot be used again until its displayed countdown ends.
7. If the ship is lost, start a new run using the on-screen button.

This is a first balance pass, not a finished difficulty model. Automated checks run in Godot 4.4.1 on Linux; native Godot 4.7 Mac play and the feel of the encounter still need your confirmation.

The existing reference-derived sweep is unchanged. Public distribution would still require audio rights clearance or replacing it with original release-safe audio.
