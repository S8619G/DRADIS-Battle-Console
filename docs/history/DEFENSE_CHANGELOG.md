# BSG DRADIS Ship Defense Changes

Test identity: **Ship Defense Test 2026-10-01**. This iteration replaces the earlier free-moving, contact-clearing interception model with a ship-defense encounter.

## Functional changes

- Place the unseen own ship near the lower radar edge and launch/return Vipers there.
- Spawn Basestars and unknowns randomly in the upper half, keeping Basestars farther out.
- Keep Basestars fixed and persistent, with bounded timed fighter and missile launchers.
- Require Raiders and missiles to originate at the edge of a live parent Basestar.
- Render missiles as small red arrowheads targeting only the unseen ship.
- Restrict Viper attacks to Raiders and missiles; preserve physical pursuit and retargeting.
- Add one-roll chance-based proximity defense, leakage, hull damage, defeat and a mouse-only new-run button.
- Replace RED ALERT with FTL JUMP, including recharge, encounter/queue clearing, a safe interval, and retained damage.
- Add hull/threat/FTL feedback and Inspector controls for the new gameplay values.

## Preserved

The quiet radar drawing, subtle contact scaling, reference-based icon shapes, successful sweep-loop endpoint correction, -14 dB sweep, original double-beep, launch whoosh and existing tuning controls remain.

The modified application files are `DradisContacts.gd`, `DradisConsole.gd`, and `DradisConsole.tscn`. No existing sound or reference asset is replaced.

## Deferred

HAIL behavior, type-identifying labels, label collision avoidance, individual fighter damage, Raider gunfire, finite Viper reserves, scoring, exact long-run sweep phase lock, native exports, and public audio rights clearance remain outside this test.
