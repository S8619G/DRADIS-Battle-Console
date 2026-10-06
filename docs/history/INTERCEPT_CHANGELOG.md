# BSG DRADIS Interception Changes

Test identity: **Interception Test 2026-10-01**. Continues from the contacts package confirmed working on Mac.

## Functional changes

- Wire LAUNCH VIPERS to launch up to two craft per click from below the actual screen edge.
- Replace randomly appearing Vipers with player launches; all Viper spawn paths use the same bottom-entry behavior.
- Pursue only hostile/red contacts, handle target loss safely, and clear a hostile once per successful interception.
- Patrol without enemies, then return below the screen when the sortie ends.
- Add reserved Viper capacity, launch cooldown and launch-button status.
- Add class-based movement: large ships slow, small hostile craft fast, Vipers faster.
- Add an original short synthesized launch whoosh, retaining the no-detection-beep rule for Vipers.
- Lower default sweep volume to -14 dB and expose it in the console Inspector.
- Limit all active contact paths to Vipers, hostile Raiders, amber unknowns, and hostile Baseships.
- Reduce Viper/Raider class size to 0.75× and increase Baseship class size to 1.35×.
- Reduce default Depth Strength from 1.0 to 0.25, keeping size changes subtle.

## Preserved

All scenes, the dome script, underlying contact icon drawing script, project settings, audio files, reference assets, and tuning controls are unchanged. The two changed application files are `DradisConsole.gd` and `DradisContacts.gd`.

The WAV loop repair and non-Viper double-beep waveform are unchanged. Contact ID labels remain temporary; type labels are deferred.

## Prototype limits

Interception currently removes any red target on contact without armor, weapons, or a damage model. Other console-button gameplay, label collision avoidance, exact sweep phase locking, native exports, and public audio rights clearance remain separate work.
