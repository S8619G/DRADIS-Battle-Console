# BSG DRADIS Heavy Raider Test v2

Release identity: Heavy Raider Test v2, 2026-10-01. Corrective update to the unpublished Heavy Raider Test after field feedback.

## Functional changes in v2

- Defense Battery fires continuously: every standard missile in its zone is shot at every 0.3 seconds (45% per shot) instead of one 75% roll. The zone grew from 0.28 to 0.45 scope radii. Kills show a yellow burst.
- Standard Basestar missile damage reduced from 15 to 10 hull. Nuclear damage unchanged at 60.
- Heavy Raiders park much closer to the ship, just above the hull, and need three hits instead of two.
- Ship missiles now attack Heavy Raiders parked at the ship before Basestars, one missile per remaining hit point.
- Vipers engage Raiders and missiles first and break away for Heavy Raiders only when clear.
- Raptors skip Heavy Raiders while a Basestar is firing flak at them; nukes remain their top priority.
- Hacking warning names ship missiles, Vipers and Raptors.

# BSG DRADIS Heavy Raider Test (v1)

Release identity: Heavy Raider Test, 2026-10-01. This separate, complete project builds on the Console Game Test; its Godot display name remains BSG DRADIS.

## Functional changes

- Missiles now hit at the upper edge of the ship outline instead of about 69 pixels above it. Own-ship position moved from Y -0.82 to -1.05; missile impact radius tightened from 0.025 to an adjustable 0.004.
- Standard and nuclear missile hits play a new original 0.45-second boom at -10 dB and flash the ship outline red for 0.45 seconds.
- Identified Basestars launch Heavy Raiders: one per Basestar, two maximum, every 22 seconds, at 0.075 scope radii per second with two hit points.
- Heavy Raiders approach the ship, hack for six seconds, then drain 2 percent of maximum hull per second each until destroyed. A persistent hacking warning is shown.
- Vipers and Raptors can destroy Heavy Raiders; the Defense Battery cannot. Raptors prioritize nukes, then Heavy Raiders, then Basestars.
- Heavy Raiders are worth 300 points. FTL and Retry clear them and stop all hacking.
- A bonus Rapid Repair charge is awarded for every 10,000 gross earned points. FTL penalties do not reduce earned progress. Charges stack; Retry restores one starting charge.
- FTL penalty raised from 250 to 3,000 points, still floored at zero.
- PROX DEFENSE renamed DEFENSE BATTERY. Header enemy count and sidebar include Heavy Raiders; target values list Heavy Raider.
- Repair charge text uses the singular for one charge; the sidebar shows points remaining until the next bonus.

## Preserved behavior

The dome script and ring settings, approved ship artwork, contact icons, prior audio assets and sound generators are unchanged; ambient DRADIS remains -20 dB. Identification alert, nuclear warning and beeps, battery buzz, defense reserve and cooldown are unchanged.
