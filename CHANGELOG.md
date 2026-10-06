# Changelog

Functional changes in each version, newest first. Earlier development-stage notes are in `docs/history/`.

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
