# BSG DRADIS Returning Flights Test

Release identity: Returning Flights Test, 2026-10-01. This separate, complete project builds on Heavy Raider Test v2; its Godot display name remains BSG DRADIS.

## Functional changes

- Returning Vipers, Raiders and Raptors flash slowly (0.8 Hz) in a lighter shade of their color.
- Raiders return to their Basestar after a 40-second sortie and dock, freeing a launch slot. Orphaned Raiders fly to the nearest surviving Basestar without changing launch ownership; with none left, they keep fighting.
- Returning ships fly at 80% speed. Raiders hunt returning Vipers (50% loss chance per attack, 1.5-second attack gap); active Vipers remain protected. Vipers chase returning Raiders anywhere and prefer them. Returning Raptors evade flak 35% of the time instead of 75%. The sidebar adds VIPERS LOST.
- Hacking and draining Heavy Raiders flash rapidly (6 Hz) in their red. A flashing, chamfered side alert box shows HEAVY RAIDER HACKING SHIP, PENETRATING DEFENSES and a BREACH IN countdown, then COMPUTERS BREACHED with drain rate and any NEXT BREACH countdown.
- Defense Battery is now a charge meter: drains full-to-empty in 6 seconds of fire, recharges empty-to-full in 18 seconds after a 1-second pause, at any level. Empty stops firing; refiring needs 15%. The old 18-second lockout at zero is removed. The button and sidebar show percent.
- Score shows a single 0 and counts up (or down after FTL) instead of six zero-padded digits.
- All button states use the console frame's notched corners; borders are 2 pixels (3 on hover/pressed), and the frame outline is 2 pixels.
- New DradisConsole > Build > Development Build switch (on in test builds). Turning it off hides the DRADIS -20 dB and F1 TUNING PANEL labels and disables the F1 panel for the final build.

## Preserved behavior

Dome script and ring settings, approved artwork, icons, prior audio assets and sound generators, -20 dB DRADIS, alert sequences, Heavy Raider hack timing and drain, ship-missile targeting and score values are unchanged.
