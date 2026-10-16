# Changelog

Functional changes in each version, newest first. Earlier development-stage notes are in `docs/history/`.

## 1.2.9 (2026-10-14)

Builds on DRADIS Battle Console 1.2.8.

The Protect the fleet changes apply only to the Protect the fleet round. The main game (waves, Basestars, missiles, Raptors, Defense Battery, scoring) plays exactly as in 1.2.8. Every new value has its own Inspector export; the script defaults keep 1.2.8 behaviour and the scene turns the new switches on.

### Protect the fleet: round sounds

- A soft tick on each Viper hit (-22 dB), a louder Raider explosion (-13 dB), a warning the first time a ship is attacked (-14 dB) and when it reaches critical hull (-12 dB).
- A boom sized by the civilian ship lost: small -14 dB, medium -11 dB (new medium boom), large -8 dB. A Viper downed by a Raider plays the fighter-lost boom (-15 dB).
- Contacts > Protect the Fleet > Round Sounds 1.2.9: Protect Round Sounds (on) and one volume for each sound.

### Protect the fleet: damaged ships

- Civilian ships keep Civilian Color as they take damage (no fade to the damaged colour). A thin hull bar sits under each label: dark track, thin outline, filled in Civilian Color.
- A ship flashes white for about 0.15 s each time a Raider hits it. Critical ships still blink.
- Contacts > Protect the Fleet > Damaged Ships 1.2.9: Civilian Hull Bar (on), Civilian Hull Bar Width (38), Civilian Hit Flash Seconds (0.15).

### Protect the fleet: round counter

- During the round the alert box reads PROTECT THE FLEET with SHIPS n OF m (Civilian Color), RAIDERS n LEFT (red) and TIME m:ss.
- Contacts > Protect the Fleet > Round Counter 1.2.9: Protect Round Counter (on).

### Protect the fleet: challenge mix

- Each round picks some challenges at random. How many: the set number (Easy one fewer, Hard one more), from 0 to 3.
  - Waves: the Raiders arrive in 2 or 3 groups. The next group jumps in 6 to 10 seconds after the last, without waiting for the scope to clear.
  - Fewer Vipers: 1 or 2 fewer launches than Raiders, never more than a third fewer.
  - Gang up: Raiders prefer a ship already under attack and the most damaged ship.
- Contacts > Protect the Fleet > Challenge Mix 1.2.9.

### Protect the fleet: dogfights

- About 60% of Raiders that a Viper engages break off to fight it; the rest keep attacking the ship.
- Hits land only from behind (tail range 0.07, tail cone 0.35), for both sides. A Viper with a Raider on its tail weaves.
- Wingman help on both sides: once a second, a free fighter within 0.28 has a 30% chance to go after the attacker of a nearby friend.
- A Raider behind a Viper fires every 0.7 s; each shot downs the Viper with a 7% chance. This replaces the one 1-in-6 return-fire roll per Raider in this round. These losses count in VIPERS LOST and score as Viper losses.
- Vipers stay out all round (they ignore the sortie timer) and fly home when the round ends.
- Labels that would sit on top of each other move down a line or are left out, so bunched dogfights stay readable. Civilian ship labels always show.
- Contacts > Protect the Fleet > Dogfights 1.2.9.

### Protect the fleet: smarter ships

- Large ships now drift slowly away from attackers too (0.02 scope radii a second).
- Self-repair: after 3 seconds with no Raider attacking, a ship regains 4% hull a second, up to 75%.
- Contacts > Protect the Fleet > Smarter Ships 1.2.9.

### Protect the fleet: repair Raptor

- From set 3 (any set on Hard), in rounds with 2 or more challenges, there is a 50% chance of a bonus Raptor. It flies to the most damaged ship and repairs it up to 100% (8% a second), then moves to the next. It leaves when the round ends.
- The RAPTORS readout counts only your own Raptors, so it does not show the repair Raptor.
- Contacts > Protect the Fleet > Repair Raptor 1.2.9.

### Balance

- A bit more danger on Normal, from set 3: 1 extra Raider (Protect Extra Raiders 1, within the 12-Raider limit) and Raiders destroy ships faster (Protect Later Kill Time Factor 0.75; Normal set 3 kill time 12 s instead of 16 s, set 4 10.5 s instead of 14 s). Easy is unchanged. Hard is unchanged unless Protect More Danger On Hard is ticked. Sets 1 and 2 are unchanged.
- Computer runs, Normal, 40 rounds per set, with all 1.2.9 round changes on. Steady player: set 3 saves 88.5% of ships (97.5% without the extra danger), set 4 86.0% (93.4%); 2.1 and 2.5 Vipers lost a round; rounds about 34 and 37 s; no ship lost before 14 s; no whole fleet lost. Fast player: set 3 97.5%, set 4 94.2%.
- Same runs, Easy: 95-99% saved on sets 3 and 4. Hard (default, no extra danger): steady player 86.9% and 82.6%, fast player 91.0% and 92.6%. With More Danger On Hard ticked: steady player about 75%, fast player about 90%.
- Contacts > Protect the Fleet > Challenge Mix 1.2.9: Protect Extra Raiders From Set (3), Protect Extra Raiders (1 in the scene), Protect Later Kill Time Factor (0.75 in the scene), Protect More Danger On Hard (off).

### Three DRADIS rings

- Three rings turn on one 2.0 s cycle: a vertical ring, pinned upright to the top and bottom of the dome outline (no wobble), half a cycle out of step; a horizontal ring hinged front to back; and a second horizontal ring hinged left to right at the same angle, front edge rising.
- Ring colour, thickness and glow are unchanged. Ring brightness: Three Ring Vertical / Front Back / Left Right Strength, 0.75. The scope gives off about 3% more light in total than 1.2.8 (measured 1.034 of 1.2.8); 0.6 gives the same light as 1.2.8.
- Afterglow: the horizontal rings 0.4 s (Three Ring Horizontal Trail Seconds), the vertical ring 0.2 s (Ring Trail Seconds).
- Pulse rings are three times slower: Ripple Period Seconds 6.0 with Ripple Count 3, so a new pulse still starts every 2.0 s on the sweep beat.
- Dome > Three Rings: Three Rings Enabled (on in the scene). Unticking it gives the 1.2.8 rings; setting Ripple Period Seconds back to 2.0 gives the 1.2.8 pulse.

## 1.2.8 (2026-10-13)

Builds on DRADIS Battle Console 1.2.7.

### Splash screen

- The game starts on its own splash screen instead of the Godot logo: a DRADIS BATTLE CONSOLE patch with the scope and ship icons, over a star field.
- Small print at the bottom states that this is an unofficial, free fan project, not affiliated with or endorsed by Universal City Studios LLC, NBCUniversal or SYFY, and that Battlestar Galactica names and marks belong to Universal City Studios LLC. The last line reads "Original code, artwork and sound © 2026 S8619G, MIT License."
- It stays up at least 3 seconds, on a black background, and keeps its shape in any window size.
- Project Settings > Application > Boot Splash: Image `res://assets/splash/dradis_splash.png`, Bg Color black, Minimum Display Time 3000 ms.

### Defense Battery against nukes

- While the Defense Battery fires, each nuke that reaches its kill zone (0.12 scope radii, at the flak arc) gets one 35% chance, about 1 in 3, to be shot down. If the chance fails, the battery cannot stop that nuke again.
- A nuke shot down this way explodes close to the ship and does splash damage: one third of a direct nuke hit (about 15 hull on Easy, 20 on Normal, 25 on Hard). It scores full nuke points (500 times the multiplier) and counts as a nuke destroyed. The status reads DEFENSE BATTERY: NUKE DESTROYED | SPLASH DAMAGE.
- AUTO DEFENSE BATTERY also starts firing when a nuke comes within 0.22 scope radii, as it does for missiles.
- The same values apply on every level. Raptors, ship missiles and FTL work as before.
- Contacts > Ship Defense: Battery Nuke Chance (0.35), Battery Nuke Splash (0.33), Auto Battery For Nukes (on).

### Slower hack drain

- After a Heavy Raider breach, the hull drains 1.5% of maximum hull a second on Normal (was 2%). Easy and Hard keep their slower and faster hack speeds on top. Two hacking Heavy Raiders drain 3% a second.
- Contacts > Heavy Raiders > Hack Drain Percent Per Second: 1.5.
- In computer runs with every auto option on (8 battles each), median survival rose from about 9 to about 14.5 minutes on Normal and from about 4.6 to about 7.3 minutes on Hard.

### Shorter Protect the fleet result line

- The line under FLEET SAVED, n OF m SHIPS SAVED or FLEET LOST no longer repeats the ship count. It reads FLEET HULL n% | RAIDERS DOWN a OF b.

## 1.2.7 (2026-10-12)

Builds on DRADIS Battle Console 1.2.6.

### Inbound threats in the alert box

- Under ALERT STATUS, the alert box in the left panel lists each threat heading for the ship, with its count, most dangerous first: NUKES INBOUND (red), MISSILES INBOUND (amber) and HEAVY RAIDERS INBOUND (amber). The labels are singular for one (for example 1 NUKE INBOUND).
- A line shows only while its count is above 0. Resurrection Ship barrage missiles count as missiles. Raiders, the Resurrection Ship itself and the ship's own stealth nukes are not listed. A Heavy Raider retreating after an EMP is not counted.
- While a Heavy Raider is hacking, or after a breach, its warning takes over the whole box as in 1.2.6, with no summary line. The list returns when the hack ends.
- Each line is measured against the box's slanted edge at its height. A label that would not fit is drawn smaller, then cut, so text never crosses the outline. The box holds 7 lines.

### Right panel score multiplier

- SCORE MULTIPLIER now has its own line under the wave line. In 1.2.6 it was at the end of the wave line, which could run past the panel border with a long wave name.
- The Resurrection Ship block moves down one line (22 px).
- Every right-panel wave line is fitted to the panel's text width (316 px) and drawn smaller if it would not fit.

### Wider status box

- The message box at the top reaches the outer edges of the top tabs and corner panels below it: 1,092 px wide at 1920 x 1080 instead of 720 px. The longest message, the Resurrection Ship warning, now fits.
- As a safety net, a message that would still be wider than the box (or a small window) is drawn at a smaller size, down to 12 px. The nuclear alert line has the same safety net.

### Protect the fleet result

- The result has a title: FLEET SAVED (green) when every ship survives, n OF m SHIPS SAVED when some are lost, FLEET LOST (red) when none survive.
- Under it, one line shows the ships saved, the fleet hull and the Raiders destroyed. Then the bonus is shown large (40 px) in yellow, with FLEET BONUS (and FULL FLEET) under it; with no bonus, a quiet NO FLEET BONUS line. The NEXT line is unchanged.
- The bonus and the panel border flash twice a second for the first 3 seconds, then stay steady.
- Each outcome has its own sound (original synthesized audio): a rising chime for FLEET SAVED (1.9 s), a neutral two-tone for a partial save (1.7 s) and a falling tone for FLEET LOST (2.0 s).
- The result stays up 5 seconds longer after this round: 15 s on Easy, 12 s on Normal and 10 s on Hard. WAVE INBOUND and its horn still take the last 3 seconds. Rests after normal waves are unchanged.
- Contacts > Protect the Fleet: Protect Result Extra Seconds (5), Protect Result Flash Seconds (3), Protect Result Sounds (on), Fleet Saved / Partial / Lost Volume Db (-14).

### FTL held in Protect the fleet

- FTL can never be used during the round, by the button or by Auto FTL. The Protect Allow Ftl option (off in 1.2.6) is removed.

### Auto Launch Vipers in Protect the fleet

- Auto Launch Vipers now carries through to the round, within the round's limit of one Viper per Raider. The other auto options (battery, firewall, Raptors, FTL and Rapid Repair) still pause for the round.
- The usual 10% score cut per auto option applies, as it does to every score.

### Nuke speed

- Easy 1.1x (was 1.0), Normal 1.25x (was 1.1) and Hard 1.45x (was 1.6), as tried in the Inspector. The 0% to 8% random speed bonus at launch is kept.

### Faster Raiders and Heavy Raiders on Hard

- Raiders and Heavy Raiders fly 10% faster on Hard: Raiders on their approach, patrol, chase and return, and Heavy Raiders on their run to the ship and back. Difficulty > Hard Raider Speed and Hard Heavy Raider Speed (1.1).
- Easy and Normal are unchanged, as are the Raiders in Protect the fleet.

### Unchanged

- The rings (colour, thickness, glow, clock, trail, hinge and ripples), the scanlines, the scope, the console layout apart from the changes above, and every other sound.

## 1.2.6 (2026-10-12)

Builds on DRADIS Battle Console 1.2.5.

### Scanlines inside the scope

- The rolling CRT scanlines are drawn only across the scope outline (the arc and the V) at each height. In 1.2.5 they ran across the whole dome square and shimmered over the corner panels, top tabs and NAV DATA box inside it.
- The scope keeps its scanlines; their colour, spacing and speed are unchanged.
- Dome > Scanlines > Scanlines Inside Scope (on in the scene; off gives the 1.2.5 scanlines).

### Alert box outline

- While a Heavy Raider approaches or hacks, the alert box outline in the left panel uses the normal panel outline colour (as the quiet ALERT STATUS box) instead of amber.
- The amber warning text and every other text colour in the box are unchanged.
- The red outline that blinks while hacking and the steady red outline of a breach are unchanged.

### Unchanged

- The rings (colour, thickness, glow, clock, trail, hinge and ripples), the console layout, the gameplay and the sounds.

## 1.2.5 (2026-10-12)

Builds on DRADIS Battle Console 1.2.4. Not released separately; included in 1.2.6.

### Protect the fleet

- **Toughness by size.** The large civilian ship (C) lasts 2.0 times the kill time, the medium ships (A and D) 1.2 times, and the small ships (B and E) 1.0 times. Contacts > Civilian Size Toughness.
- **Evasion.** When a Raider comes within 0.2 scope radii, small ships move away at 0.035 and medium ships at 0.02 scope radii per second, weaving side to side, with the path bent toward Galactica. They stay at least 0.12 inside the scope outline and no lower than 0.5 below centre. Evading buys time only; damage is not reduced. Large ships hold position. Contacts > Civilian Evasion.
- **Patrol Viper.** One Viper is on patrol beside the fleet when the round starts. Contacts > Protect Patrol Vipers.
- **Raider jump-in.** Each Raider holds for 2 seconds where it jumps in, fading up from dim, before it attacks. Contacts > Protect Jump In Hold.
- The round goal, 60-second limit, Raider toughness, return fire, points and sounds are unchanged. With all four switches off the round is the 1.2.4 round.
- Normal, a player who starts launching 3 seconds in, 10 rounds per set (ships saved of 31): set 1: 31 (was 28), set 2: 30 (was 17), set 3: 24 (was 9), set 4: 20 (was 2). Easy: 31, 31, 30, 28. Hard: 27, 23, 17, 12.

### Console layout

- Taller corner panels whose inner edges continue the V. Every tab, light and box keeps one shared gap to the scope; tab outer sides line up, and the two sides mirror.
- Ready lights VIPERS, RAPTOR, FTL and DEFENSES mirror the bottom buttons (lights only).
- The alert box in the left panel: ALERT STATUS when quiet, the Heavy Raider warnings when there is an alert.
- NAV DATA in the right panel: made-up sector, coordinates, star, planets and local condition, new at the start of each battle and after each FTL jump.
- HULL gauge (red at 30% or less), live TRACKS count and DEFENSE BATTERY scale.
- The status message in its own box; lower, wider top tabs reaching to the scope; tabs with the vertical side away from the scope.
- The thin rectangle around the scope is removed; the bottom buttons are centred between their lines.
- ConsoleFrame > Console Layout V2 off gives the 1.2.4 layout.
- The rings are unchanged.

## 1.2.4 (2026-10-11)

Builds on DRADIS Battle Console 1.2.3. Not released separately; included in 1.2.6.

### Changed

- **Ring trail.** Each orbital ring leaves a soft trail of 24 faint glow copies over 0.20 s (strength 0.30). The ring's own glow is halved while the trail is on, so the overall ring light stays the same. Dome > Ring Trail.
- **Scope outline.** A thin magenta arc (1.05 x the sphere radius) runs over the top with inward range ticks every 5 degrees (longer every 30), then a V from 4 degrees below horizontal down to the button bar line, 0.75 x the sphere radius either side of centre, with ticks along each edge. The arc has a gap under the status line. The plain line under the dome is removed. ConsoleFrame > Scope Frame.
- **Corner panels.** Magenta panels with angled tabs, bar readouts, a gauge and a segmented scale beside the V, and three tabs in each top corner. Decoration only, drawn under the contacts. ConsoleFrame > Scope Frame.
- **Panel animation.** Three bar readouts and the segmented scale step by one segment every few seconds (3 s, each on its own offset), and one segment slowly fades over 6 s. Never faster or brighter than the still panel. ConsoleFrame > Panel Animation.
- **Keep play inside the wedge.** A contact that has been inside the scope outline and drifts out is moved back just inside (0.06 x the sphere radius) and stops moving outward. Contacts that start outside fly in as before. Contacts > Keep Play In Wedge.
- **Ring hinge.** The horizontal ring is hinged at the front and back of the dome and seen from 30 degrees above. It turns all the way over, in the reverse direction, on the same 4 s clock. The vertical ring is unchanged. The two rings are at right angles at each quarter turn. Dome > Ring Hinge.
- **Pulse rings on the ring plane.** The base-plane pulse rings are centred on the dome and lie on the flat ring's plane. Ripple Max Radius is 320 (the sphere radius), so the outer pulse stops at the ring's edge. Dome > Ripples.
- The Heavy Raider warning box hides the corner panel behind it, so it reads exactly as before.

## 1.2.3 (2026-10-08)

Builds on DRADIS Battle Console 1.2.2. Not released separately; included in 1.2.6.

### Changed

- Protect the fleet Raiders are tougher, in that round only:
  - They take 4 Viper hits after set 1, plus 1 more per later set, up to 6 (was 2). Raiders in normal waves still take 2.
  - They fire back. The first Viper to engage each Raider is lost with a 1 in 6 chance (one roll per Raider). The status line reads VIPER LOST TO RAIDER RETURN FIRE. The usual Viper loss points apply, and lost Vipers are not replaced in the round (one Viper launch per Raider, as before).
  - They arrive in groups of 3, 1 second apart (was 2 every 1.5 seconds).
  - They destroy civilian ships faster in later sets: 10% of the difficulty time less per set after set 1, never below 10 seconds. Normal: 20, 18, 16, 14, 12, then 10 s. Easy starts at 26 s and Hard at 14 s.
  - New Inspector values in Protect the Fleet: Protect Raider Viper Hits / Hits Step / Hits Cap (4 / 1 / 6), Protect Return Fire Chance (0.1667; 0 turns it off), Protect Kill Time Step / Floor (0.1 / 10 s). Group Size / Group Gap now default to 3 / 1.0 s.
- Ship missiles fire at Heavy Raiders that are hacking or draining the ship again. Since 1.2.1 they fired only at Heavy Raiders within 0.15 of the ship, but a hacking Heavy Raider parks about 0.16 to 0.19 away, so it was never targeted. The order is now:
  1. Nukes in the last quarter of their flight.
  2. Heavy Raiders hacking or draining the ship (draining first, then the one closest to finishing its hack), at any distance.
  3. Approaching Heavy Raiders within 0.15.
  4. Basestars.

  Each still gets one missile in flight per remaining hit. New Inspector value: Ship Missiles Target Hacking (on; off gives the 1.2.2 behavior).
- Version 1.2.3 in the project and both export presets.

## 1.2.2 (2026-10-08)

Builds on DRADIS Battle Console 1.2.1. Not released separately; included in 1.2.6.

### Added

- Protect the fleet replaces the bonus sweep after each Major engagement. The scope is reset and 2 to 4 civilian ships appear, picked at random from five new civilian types. They are blue, dim toward grey-blue as they take damage, and blink when critical.
  - Only Raiders attack, and they target the civilian ships: 4 after set 1, then 2 more per set up to 12 (Easy 2 fewer, Hard 2 more).
  - A lone Raider destroys a civilian ship in 26 s on Easy, 20 s on Normal and 14 s on Hard.
  - Vipers only: Viper launches in the round are capped at the Raider count. Raptors, the Defense Battery, ship missiles and the Stealth Viper are off, FTL is held, and the auto options pause for the round.
  - The round ends when every Raider is destroyed or every civilian ship is lost, or after 60 seconds (remaining Raiders jump away).
  - Bonus: 500 x each surviving ship's hull fraction, plus 1,000 if every ship survives. The tally shows ships saved, hull and bonus.
  - New Inspector group Protect the Fleet. Set End Round (Defined Waves) can bring back the 1.2.0 bonus sweep or skip the round. Protect Allow Ftl lets a jump end the round with no bonus.

### Changed

- Systems Bonus schedule: none in set 1. From wave 6 each cleared wave has a 40% chance, and the end of every set always gives one. Tiers by set: low in set 2, medium in sets 3 and 4, high from set 5, with a 1 in 3 chance of a lower unlocked tier. Hard starts one set later at half the chance. A wave with no bonus shows NO SYSTEMS BONUS in the tally. All values are in the Inspector.
- FREE AUTO BATTERY is no longer offered while AUTO DEFENSE BATTERY is on. Another bonus is drawn from the same tier, or a lower one.
- Basestars take 11 hits on Normal (was 10) and 15 on Hard (was 13). Easy stays at 7.
- Nuclear Speed 0.058 (was 0.055). The 0 to 8% random bonus and the Hard lean are unchanged.
- Raptor Nuke Hit Interval 0.7 s (was 0.6). One Raptor needs about 3.5 s per nuke on Normal (was about 3 s), 2.1 s on Easy and 4.9 s on Hard.
- The wave tally panel border is 3 pixels wide (was 1). New Inspector value Rest Tally Border Width.
- Version 1.2.2 in the project and both export presets.

## 1.2.1 (2026-10-07)

Builds on DRADIS Battle Console 1.2.0. Not released separately; included in 1.2.6.

Balance release: the battle is harder, with tougher but fewer enemies.

### Changed

- Basestars take 10 hits (Easy 7, Hard 13; was 6, 4 and 8).
- Heavy Raiders take 5 hits (Easy 3, Hard 7; was 3, 2 and 4) and launch every 28 seconds per Basestar (was 22).
- Raiders take 2 Viper hits, 0.5 seconds apart (was 1). New Inspector values Raider Viper Hits and Raider Viper Hit Interval; 1 restores the old one-pass kill.
- Nukes take 6 hits (Easy 4, Hard 8; was 3, 2 and 4). Raptor fire rate is unchanged.
- Ship missiles go for a nuke only in the last quarter of its flight (Ship Nuke Target Fraction 0.75, was 0.5) and for a Heavy Raider only within 0.15 of the ship (was 0.30). Ship missile reload is 8 seconds (was 6).
- Defined waves: waves 3 to 5 bring one Basestar fewer. Cylon force per wave is Easy 2,2,2,2,2; Normal 2,3,2,3,3; Hard 2,3,3,3,3.
- Version 1.2.1 in the project and both export presets.

## 1.2.0 (2026-10-07)

Builds on DRADIS Battle Console 1.1.1. Not released separately; included in 1.2.6.

### Added

- Defined waves: each wave is one Cylon attack with a set number of Basestars (its Cylon force). The wave is cleared when that force is destroyed; the remaining Raiders and Heavy Raiders then jump away. A rest follows (Easy 10 s, Normal 7 s, Hard 5 s) with a tally panel in the lower scope and a WAVE n INBOUND announcement for the last 3 seconds. A wave that runs 5 minutes receives no more Basestars.
- Sets of five waves: Probe, Strike, Assault, Pressure, Major engagement. The Major engagement brings the Resurrection Ship 20 seconds in; it no longer arrives at random while defined waves are on.
- Wave traits on waves 3 and 4 (Hard: 2 to 4; Easy: from set 2): RAIDER SWARM, MISSILE BARRAGE, NUCLEAR STRIKE, HEAVY ASSAULT, ESCORT. Announced at the wave start; no repeats within a set.
- Cylon tactics: each new set adds one permanent tactic (QUICKER LAUNCHES, HARDENED BASESTARS, FASTER HACKING, FASTER WARHEADS), repeating in capped half steps from set 6. Easy uses half steps.
- Score multiplier: +0.25x per completed set, up to 3x, applied to every score.
- Wave tally: 500 plus 10 per hull percent kept; +2,500 for a Major engagement.
- Bonus sweep after each Major engagement: 12 Raiders cross without firing; PERFECT bonus 3,000 x the multiplier when all are destroyed.
- Systems Bonus for each wave survived, chosen at random from eight (extra repair, extra EMP, Stealth Viper ready, +2 Vipers, +1 Raptor, fighter speed +15%, free auto battery with no score penalty, rapid fire). Bonuses that cannot help are skipped; never the same twice in a row. Boosts last until the next wave is cleared and are listed under SCORE.
- FTL during the rest: free, +250 points, next wave after a 2-second safe period. FTL during an assault keeps its 3,000-point cost and restarts the wave.
- Two original wave cues: action stations (three low horn pulses, 1.2 s) and all clear (rising fifth, 1.4 s). On/off and volumes in the Inspector.
- Right sidebar: SET n | BASESTARS LEFT n or REST n s, then the wave name, trait and score multiplier.
- High scores: new entries also save waves cleared and sets completed, shown when hovering an entry.
- Inspector: new Defined Waves group in DradisContacts. Untick Defined Waves for the 1.1.1 timer waves.

### Changed

- Heavy Raider warning box: one fixed size (five lines) and position for the approach and the hack. HEAVY RAIDER APPROACHING / PREPARE FIREWALL DEFENSE is centred in the box; the hacking lines replace it, left-aligned from the top.
- Version 1.2.0 in the project and both export presets.

## 1.1.1 (2026-10-07)

Builds on DRADIS Battle Console 1.1.0.

### Changed

- Heavy Raider warning box: moved from the bottom of the left panel to the left of the ship outline, below the battle readout, so it no longer covers STEALTH VIPERS LOST and EMP CHARGES. It is hidden until a Heavy Raider is on its way. During the approach it shows HEAVY RAIDER APPROACHING / PREPARE FIREWALL DEFENSE in a steady amber box (previously the text had no box). When the hack starts, the hacking lines appear in the same box, which flashes as before. Text size 17 (was 19) so the longest five-line warning fits above the buttons. Inspector: DradisConsole scene > HackAlert.
- Approach wording: BATTERY CANNOT STOP IT is now PREPARE FIREWALL DEFENSE.
- Version 1.1.1 in the project and both export presets.

## 1.1.0 (2026-10-06)

Builds on DRADIS Battle Console 1.09. Not released separately; included in 1.1.1. From this release, versions use three parts (1.1.0, then 1.1.1, and so on).

### Changed

- Left-side battle readout: it now lists enemies destroyed this battle by every source (ship missiles, Vipers, Raptors, the Defense Battery and the Stealth Viper): RAIDERS, HEAVY RAIDERS, MISSILES, NUKES, BASESTARS and RESURRECTION SHIPS DESTROYED. Then come our losses (VIPERS LOST, RAPTORS LOST, STEALTH VIPERS LOST), and EMP CHARGES is the last line, in the EMP blast color. Changing Contacts > EMP Defense > Emp Color changes both. INCOMING MISSILES, HEAVY RAIDERS (active) and VIPERS RETURNING were removed. Font size: DradisConsole > Battle Readout > Readout Font Size (16).
- Landing pause: after a Viper lands, LAUNCH VIPERS waits 3 seconds, and after a Raptor lands, LAUNCH RAPTOR waits 5 seconds. Each landing restarts the pause, so the button unlocks 3 seconds after the last Viper of a group lands. If the launch cooldown is longer, the longer one wins. The button shows its usual READY IN countdown. Auto Launch waits too. Inspector: Contacts > Viper Launch > Viper Recovery Seconds (3); Contacts > Raptors > Raptor Recovery Seconds (5); 0 turns a pause off.
- Stealth Viper: once it has fired, every Raider within 0.40 of it turns on it. Each Raider chases it for a short distance (0.25), shooting from up to 0.30 once every 1.5 seconds, then gives up and goes back to its job. One hit still destroys it. The hit chance was tuned in long test battles so that about one run in four is lost. Basestar flak still targets only Raptors. Inspector: Contacts > Stealth Viper > Stealth Focus Range, Stealth Pursuit Distance, Stealth Shot Range, Stealth Shot Interval, Stealth Hit Chance.
- Nuke speed: each Basestar nuke gets its own random speed bonus when it launches, from 0% to 8% faster than the usual speed for the difficulty (Hard is still 1.6x). Easy and Normal spread evenly; on Hard the bonus leans to the top end (about 5.3% on average). Each nuke's bonus goes in the session log. Inspector: Contacts > Nuclear Threat > Nuke Speed Random Max (0.08), Hard Nuke Speed Lean (on).
- Auto Launch Raptors: with 2 or more nukes on screen, every available Raptor launches at once, without waiting for the launch cooldown. The landing pause still applies. Manual LAUNCH RAPTOR is unchanged. Inspector: Contacts > Automation > Auto All Raptors Nukes (2; 0 turns it off).
- Version 1.1.0 in the project and both export presets.

## 1.09 (2026-10-06)

Builds on DRADIS Battle Console 1.08.

### Added

- Stealth Viper. On Normal and Hard, while 3 or more large ships (Basestars and the Resurrection Ship) are on the scope and it is ready, the top nacelle of the ship turns into a blue STEALTH WEAPON button with a gentle pulse and a bright ready chime. At all other times the nacelle keeps the normal hull color. Clicking or tapping it launches a fast Stealth Viper (tag STEALTH, rapid blink while hidden) with two nuclear missiles fired 4 seconds apart; each does 3 of a Basestar's 6 hits or 5 of a Resurrection Ship's 10. Once it has fired, the enemy can see it, and one Raider hit destroys it. It rearms 60 seconds after a safe return; after a loss a new one takes 3 minutes on Normal and 4 on Hard. Rearm and rebuild show no message or timer. It finishes its run if large ships drop below 3, and an FTL jump brings it home. Never offered on Easy. Inspector: Contacts > Stealth Viper; ShipStatus > Stealth Weapon. Its events are logged.
- Windows PCs with a Qualcomm GPU start with the ANGLE graphics driver. Godot's own ANGLE device list is kept, with two Qualcomm entries added; the Windows export preset always includes the ANGLE files. Other PCs are unchanged.
- The session log notes when the game window loses or gets focus.

### Changed

- High-score rows show the difficulty in full (EASY, NORMAL, HARD) instead of the wave and letter; the wave is in the hover box.
- A Heavy Raider returning after an EMP shows HEAVY RAIDER instead of HEAVY RAIDER RTB.
- A hacking Heavy Raider's tag sits above it, clear of the ship console.
- Version 1.09 in the project and both export presets.

## 1.08 (2026-10-06)

Builds on DRADIS Battle Console 1.07.

### Added

- FTL goes offline while any Heavy Raider has broken through and is draining the hull. The ship outline shows OFFLINE in red, the FTL JUMP button reads OFFLINE, and neither a manual jump nor AUTO FTL is possible. When the breach ends (EMP, destroyed, out of range) the FTL charge restarts from 0% and must reach 100% again. Inspector: Contacts > FTL > Ftl Offline On Breach (on), Ftl Breach Recharge Seconds (45); ShipStatus > Ftl Offline Color / Font Size. FTL offline and back online are logged as events.
- One Viper breaks off to attack a Resurrection Ship while it is on the scope; another takes over if it is lost or returns. Inspector: Contacts > Viper Squadrons > Vipers On Resurrection Ship (1; 0 = previous behavior).
- High-score entries save how many of each enemy type the battle destroyed. Hovering over (or tapping) an entry on the Game Over board shows them in a small box; entries saved earlier show NO BATTLE STATS. Inspector: DradisConsole > High Scores > Show Score Stats.
- The best saved score shows in small dim text on the SCORE line, just left of SCORE, during play. Inspector: Show Best Score, Best Score Font Size (15), Best Score Color.
- A small round ! beside the Settings version text opens the app data folder (session logs, settings and high scores).

### Changed

- The Settings version text opens the project's GitHub page instead of the log folder. Inspector: DradisConsole > Diagnostic Log > Github Url.
- Version 1.08 in the project and both export presets.

## 1.07 (2026-10-05)

Builds on DRADIS Battle Console 1.06.

### Added

- Enemy missiles pulse between full and 35% brightness, twice a second, and are never hidden. Inspector group Missile Visibility (on/off, rate, lowest brightness).
- Ship and Raptor missiles whose target is destroyed, leaves the scope or docks after an EMP turn toward the nearest enemy they can attack. A nuke that already has enough ship missiles on the way is skipped. A missile disappears only when no valid target is left.
- Viper squadrons split to engage: squadron mates spread over different Raiders and missiles (up to 2 on a Heavy Raider or Resurrection Ship), show as separate icons while fighting, then fly back and patrol together as one squadron when the area is clear. Inspector: Squadrons Split To Engage, Max Vipers Per Tough Target, Squadron Spread Penalty, Formation Spacing.
- Show Full Tags switch (off) to bring back the long tags for testing.

### Changed

- The EMP is offered on the FIREWALL button instead of on the ship. While a Heavy Raider hacks, a charge is ready and the Firewall has run out (or is too low to raise) for 2 seconds, the button splits into FIREWALL and a blue EMP half. INTRUSION DETECTION always stays on the ship. Inspector: Emp Delay After Firewall (2.0 s); ShipStatus Emp On Ship (off) brings back the 1.06 box.
- Tags: RAIDER, VIPER and RAPTOR without ID, RTB or strength; squadrons read VIPERS x2, VIPERS x3; missiles have no tag. NUCLEAR, BASESTAR, RESURRECTION, IDENTIFYING and the Heavy Raider tags are unchanged.
- Squadron split distance is 0.06 (was 0.12), so a Viper that breaks off shows on its own.
- Version 1.07 in the project and both export presets.

## 1.06 (2026-10-05)

Builds on DRADIS Battle Console 1.05. From 1.06, versions are full builds without "Test" in the name.

### Added

- EMP defense against hacking Heavy Raiders. One charge per 5,000 earned points, up to 2 held; FTL keeps them, Retry clears them. While a Heavy Raider hacks or drains and a charge is ready, the middle of the ship shows a clickable USE EMP box instead of INTRUSION DETECTION. Using it plays a new electric zap. Every hacking or draining Heavy Raider shimmers electric blue for about a second, stops hacking and flies back to its Basestar to dock for repairs. It is not destroyed and scores no points. Manual only. The sidebar shows EMP CHARGES.
- Rapid Repair feedback: a new rising recharge tone plays for the length of the repair, and the ship outline pulses brighter green twice a second while it runs. Applies to manual and AUTO RAPID REPAIR.
- Inspector switches: Show Hover Tooltips (Build), EMP Defense and Rapid Repair Feedback groups on Contacts, and Repair Green / Emp Blue on ShipStatus.

### Changed

- Missiles, nukes, ship and Raptor missiles and flak are drawn over all ships, names and explosions.
- Hover pop-up help text is off by default. The text is kept and returns when Show Hover Tooltips is ticked.
- Settings: the version text is centered at the bottom and opens the session log folder when clicked. The DIAGNOSTIC LOG row and OPEN LOG FOLDER button were removed, and the panel is one row shorter.
- Test Build is off by default, so the version reads DRADIS BATTLE CONSOLE 1.06.
- The Heavy Raider hacking alert box sits slightly lower to make room for the EMP CHARGES line.
- Version 1.06 in the project and both export presets.

## 1.05 (2026-10-05)

Builds on DRADIS Battle Console 1.04.

### Added

- Each enemy missile destroyed by the Defense Battery scores 10 points on every level. The score multiplier applies, and the points count toward bonus repairs. TARGET VALUES lists MISSILE.
- Ship missiles target a nuclear missile once it has flown more than halfway to the ship, ahead of close Heavy Raiders. Each ship missile is one nuke hit, and no more missiles are sent than the nuke has hits left. Inspector: Ship Missiles Target Nukes, Ship Nuke Target Fraction.
- Bonus features, first bonus: Double Missile. At 15,000 (Easy), 17,500 (Normal) or 20,000 (Hard) earned points, the ship fires two missiles per volley for the rest of the battle. On unlock, a new rising two-tone chime plays once and the status line shows DOUBLE MISSILE BONUS ACTIVE. While active, a steady DOUBLE MISSILE BONUS line sits under SCORE. Retry or a new battle clears it.
- Diagnostic session log in the game's app data folder (`logs/dradis_session_<timestamp>.log`): start-up details including the graphics driver and GPU, a heartbeat every 10 seconds, events, a freeze watcher that logs STALL and RECOVERED, and script errors and warnings on Godot 4.5 and newer. The last 10 files are kept, about 1 MB each.
- OPEN LOG FOLDER button in Settings.
- Version text in the bottom-right corner of Settings, read from the project version (DRADIS BATTLE CONSOLE 1.05 TEST on test builds). The same text is in the session log.

### Changed

- RESET TO DEFAULTS is now DEFAULTS, the same size as the other switch buttons. The first press shows CONFIRM. Behavior is unchanged.
- Godot keeps its last 10 log files instead of 5.
- The Settings panel is taller to fit the DIAGNOSTIC LOG row and the version text.
- TARGET VALUES rows below MISSILE moved down one row.
- Version 1.05 in the project and both export presets.

## 1.04 (2026-10-04)

Builds on DRADIS Battle Console 1.03.

### Added

- Explosions for destroyed Raiders, Heavy Raiders, Vipers and Raptors: a small burst and a short boom, without a screen flash. Heavy Raiders get a larger burst and a fuller boom; lost Vipers and Raptors burst green-white.
- Explosions for destroyed Basestars and Resurrection Ships: a large explosion, a deep boom and a single screen flash.
- AUTO RAPID REPAIR switch in Settings: uses a repair charge by itself when the hull is at 50% or less. It counts as an auto option.
- REMEMBER SETTINGS switch in Settings (on by default). When off, each start returns to Normal with all auto options off, keeping volumes and mutes.
- RESET TO DEFAULTS button in Settings, with a confirmation press. High scores are not affected.
- One line in Godot's log file at each start showing the version, operating system, difficulty and auto options.

### Changed

- Missile and nuke speed now depends on difficulty: Easy is unchanged, Normal is 10% faster and Hard is 60% faster.
- The Defense Battery now destroys missiles on or just above the flak arc. The kill zone shrank from 0.45 to 0.12 scope radii, and shots come every 0.1 seconds instead of 0.3. Auto Defense Battery starts firing slightly before missiles reach the arc.
- Development Build is off by default: the DRADIS dB and F1 labels and the F1 tuning panel stay hidden unless it is ticked.
- The score multiplier counts six auto options (10% each).
- The Settings panel is slightly taller to fit the new rows.
- Version 1.04 in the project and both export presets.

## 1.03 (2026-10-03)

Builds on DRADIS Battle Console 1.02.

### Added

- Auto launch switches in Settings: Vipers (while enemy fighters are present) and Raptors (for each nuke, and one against Basestars). Normal cooldowns and limits apply.
- Auto FTL jump switch in Settings: jumps when the hull drops below 10% and FTL is charged, at the usual cost.
- FTL flash on every jump: a blue-white wipe across the DRADIS scope and a short screen flash. Both can be adjusted or turned off in the Inspector.
- QUIT button in Settings (with a confirmation press) and a Quit button beside Retry on the Game Over panel. A pending high score is saved first.
- The window is sized at startup to 85% of the screen's usable area, keeping 16:9, so high-resolution screens no longer open a small window.

### Changed

- Defense Battery recharge is slower: empty to full in 24 seconds on Normal (was 18), 19.2 seconds on Easy and 31.2 seconds on Hard.
- The score multiplier counts five auto options (10% each).
- The launch and FTL buttons show AUTO when their auto option is on.
- Version 1.03 in the project and both export presets.

## 1.02 (2026-10-02)

Builds on DRADIS Battle Console 1.01.

### Added

- Missile destroyed: tiny flash and a small boom.
- Nuke destroyed: brief explosion with a single warm screen flash and a deeper boom. A nuke that hits the ship explodes at the ship with a stronger flash.
- Viper Squadron display: Vipers flying together show as one squadron contact and split apart when they separate. Each Viper keeps its own health and losses.
- Inspector settings for explosions, the screen flash, boom volumes, nuke hit points and squadron distances.

### Changed

- Nukes take several Raptor hits (3 on Normal, 2 on Easy, 4 on Hard, 0.6 seconds apart). The label shows the remaining strength.
- Auto Defense Battery and Auto Firewall stay on at least 0.5 seconds once they switch on.
- Nuke labels sit above the warhead, so they stay clear of a Raptor chasing it.
- Version 1.02 in the project and both export presets.

## 1.01 (2026-10-02)

Builds on the Export Ready Test.

### Added

- Gear icon at the top right that opens a Settings panel and pauses the battle while it is open.
- Separate Effects and DRADIS volume sliders, each with a mute switch to its right. Settings are remembered between launches.
- Difficulty: Easy, Normal or Hard. This changes enemy toughness, attack frequency, missile and nuke damage, hacking speed and wave length. A change takes effect from the next battle.
- Score multiplier: Easy x0.75, Normal x1.00, Hard x1.50, minus 10% for each auto option that is on.
- Auto Defense Battery: fires by itself when standard missiles enter the defense zone.
- Auto Firewall: rises by itself when a Heavy Raider starts hacking.
- The high score table shows the difficulty of each entry (E, N or H).
- macOS export preset: Universal app in a DMG, with ad-hoc signing.

### Changed

- Game name is now DRADIS Battle Console (project, window, export file details), version 1.01.
- Sound effects start at 50% (about 6 dB quieter). The DRADIS sweep stays at -20 dB.
- ETC2 ASTC texture import is switched on, which a Universal Mac export needs.
- Target values on the right show the points actually earned on the current difficulty.
