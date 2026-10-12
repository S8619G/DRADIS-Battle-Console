# DRADIS Battle Console 1.2.6 User Guide

This is the full guide that ships with the editable project. In the GitHub repository it lives in `docs/`, the per-version changelogs are combined in `CHANGELOG.md`, and the `references` folder is not included.

**Supported computers:** Windows PCs with Intel or AMD processors (x64), Windows PCs with ARM processors (arm64), and Macs with Apple M-series chips or Intel processors (one Universal Mac app covers both).

DRADIS Battle Console is an unofficial, non-commercial fan project and is not affiliated with or endorsed by the owners of Battlestar Galactica. See `NOTICE.md` at the top of the repository for the full disclaimer and the photosensitivity warning.

This complete, editable project is version 1.2.6 of DRADIS Battle Console, a full build. Versions use three parts (1.2.5, 1.2.6, and so on). 1.2.6 keeps the rolling scanlines inside the scope outline, so they no longer shimmer over the console panels, and draws the alert box outline in the panel colour instead of amber. 1.2.5 makes Protect the fleet fairer (sturdier large ships, smaller ships that evade, a Viper already on patrol and a short Raider jump-in) and gives the console a new layout with ready lights, an alert box and NAV DATA in the corner panels. 1.2.4 brings the scope closer to the show: the orbital rings turn on a front-to-back hinge with a soft trail, the pulse rings lie on the ring plane, and a scope outline with magenta corner panels frames the dome. 1.2.3 makes the Raiders in Protect the fleet tougher and has the ship's missiles fire at hacking Heavy Raiders again. 1.2.2 replaces the bonus sweep with **Protect the fleet**, a round where Vipers defend civilian ships from Raiders, and makes Systems Bonuses rarer but stronger as the battle goes on. 1.2.1 made the battle harder: enemies are tougher but fewer, nukes take more hits, and the ship's own missiles are a last line of defense. 1.2.0 gave the battle defined waves: each wave is one Cylon attack that ends when its Basestars are destroyed, followed by a short rest, a tally and a Systems Bonus. It also keeps the Heavy Raider warning box one fixed size. It runs on Windows PCs with Intel or AMD processors (x64), Windows PCs with ARM processors (arm64), and Macs with Apple M-series chips or Intel processors (one Universal Mac app). It builds on 1.09 (Stealth Viper, ANGLE on Qualcomm GPUs, full difficulty names on the score table), 1.08 (FTL offline during a breach, a Viper on the Resurrection Ship, high-score battle stats, BEST score, Settings links), 1.07 (split FIREWALL | EMP button, enemy missile pulse, missiles that change target, short tags, squadrons that split and rejoin), 1.06 (EMP defense, Rapid Repair sound and glow), 1.05 (battery kill points, the Double Missile bonus, the session log), 1.04 (explosions, speed by difficulty, Auto Rapid Repair, Remember Settings), 1.03 (auto launch, auto FTL, FTL flash, Quit, window fit), 1.02 (multi-hit nukes, Viper squadrons) and 1.01 (Settings, volumes, difficulty, auto battery and firewall), with 1.1.1 (Heavy Raider warning box beside the ship outline). Version 1.2.6 changes (see **Console layout (1.2.5)** below):

- **Scanlines inside the scope**: the rolling CRT scanlines are drawn only across the scope outline, so they no longer shimmer over the corner panels, top tabs and NAV DATA box. **Dome > Scanlines > Scanlines Inside Scope** (on; off gives the 1.2.5 scanlines).
- **Alert box outline**: while a Heavy Raider approaches or hacks, the alert box outline uses the normal panel outline colour instead of amber. The amber warning text, and the red outline while hacking blinks or after a breach, are unchanged.

Version 1.2.5 changes (see **Protect the fleet** and **Console layout (1.2.5)** below):

- **Sturdier large ships** in Protect the fleet: the large civilian ship lasts 2 times as long, medium ships 1.2 times, small ships as before.
- **Evasion**: small and medium civilian ships move away from nearby Raiders, weaving and bending toward Galactica, and always stay inside the scope outline. Large ships hold position.
- **Patrol Viper**: one Viper is already with the fleet when the round starts.
- **Raider jump-in**: each Raider holds for 2 seconds where it jumps in, fading up from dim, before it attacks. Vipers can engage it while it holds.
- **Console layout**: taller corner panels with eye-level ready lights (VIPERS, RAPTOR, FTL, DEFENSES) that mirror the bottom buttons, the Heavy Raider warnings in an alert box in the left panel (ALERT STATUS when quiet), a NAV DATA box in the right panel, the status message in its own box, wider top tabs, a HULL gauge that turns red at 30%, a live TRACKS count and a DEFENSE BATTERY scale. The thin rectangle around the scope is removed, and the bottom buttons are centred between their lines.

Version 1.2.4 changes (see **Scope look (1.2.4)** below):

- **Ring trail**: each orbital ring leaves a soft trail of faint glow copies behind it. The overall ring light is unchanged; the rings stay quiet.
- **Scope outline**: a thin magenta arc over the top with small inward range ticks, and a V down to the button bar, clear of the ship and the dome. The plain line under the dome is gone. Under the status line the arc has a gap.
- **Corner panels**: magenta panels with tabs and bar readouts beside the V, and three tabs in each top corner. They are decoration only. A few bar readouts slowly step and one slowly fades; never fast and never brighter.
- **Play inside the wedge**: contacts are kept inside the scope outline. In 1.2.3 play they already stayed inside, so battles play the same.
- **Ring hinge**: the horizontal ring is hinged at the front and back of the dome and seen from 30 degrees above. It turns all the way over in the reverse direction on the same 4-second clock. The vertical ring is unchanged; the two rings are at right angles at each quarter turn.
- **Pulse rings on the ring plane**: the base-plane pulse rings are centred on the dome and lie on the flat ring's plane. The outer pulse stops at the ring's edge.

Version 1.2.3 changes:

- **Tougher Raiders in Protect the fleet** (that round only): 4 Viper hits after set 1, 1 more per later set up to 6; they fire back (about 1 Viper lost per 6 Raiders); they arrive 3 at a time, 1 second apart; and they destroy civilian ships 10% faster per set, down to 10 seconds. See **Protect the fleet** below.
- **Ship missiles at hacking Heavy Raiders**: right after nukes in their last quarter, ship missiles go for a Heavy Raider that is hacking or draining the ship. Since 1.2.1 these were out of the 0.15 range and never targeted.

Version 1.2.2 changes:

- **Protect the fleet** after each Major engagement, in place of the bonus sweep. The scope is cleared and 2 to 4 civilian ships appear in blue. Only Raiders attack, and they go for the civilians. Defend them with Vipers only. See **Protect the fleet** below.
- **Systems Bonus schedule**: no bonus in the first set (waves 1 to 5). From wave 6 each cleared wave has a 40% chance of a bonus, and the end of every set always gives one. Bonuses grow stronger by set: low in set 2, medium in sets 3 and 4, high from set 5. Hard starts one set later at half the chance. A wave with no bonus shows **NO SYSTEMS BONUS** in the tally.
- **No wasted FREE AUTO BATTERY**: it is never offered while AUTO DEFENSE BATTERY is already on. Another bonus is drawn instead.
- **Tougher Basestars**: 11 hits on Normal (was 10) and 15 on Hard (was 13). Easy stays at 7.
- **Faster nukes**: the base speed is 6% higher (Nuclear Speed 0.058, was 0.055). The 0 to 8% random bonus and the Hard lean are unchanged.
- **Raptors fire a little slower at nukes**: 0.7 seconds between hits (was 0.6). One Raptor needs about 3.5 s per nuke on Normal (was about 3 s), 2.1 s on Easy and 4.9 s on Hard.
- **Thicker wave tally border** (3 pixels, was 1), adjustable in the Inspector.

Version 1.2.1 changes:

- **Tougher, fewer enemies**: Basestars take 10 hits (Easy 7, Hard 13; was 6), Heavy Raiders 5 (Easy 3, Hard 7; was 3), and a Raider needs 2 Viper hits. Waves 3 to 5 bring one Basestar fewer, and Heavy Raiders launch every 28 seconds per Basestar (was 22).
- **Tougher nukes**: 6 hits (Easy 4, Hard 8; was 3). Raptors fire at the same rate, so they need about 3 seconds per nuke.
- **Last-ditch ship missiles**: they go for a nuke only in the last quarter of its flight (was the last half) and for a Heavy Raider only when it is very close (0.15, was 0.30). Reload 8 seconds (was 6). From 1.2.3 a Heavy Raider that is hacking or draining the ship is targeted at any distance, right after nukes.

Version 1.2.0 added:

- **Defined waves**: a wave is one Cylon attack with a set number of Basestars. Destroy them all to clear the wave; a short rest follows (Easy 10 s, Normal 7 s, Hard 5 s). See **Threat waves** below.
- **Sets of five**: Probe, Strike, Assault, Pressure and Major engagement (with the Resurrection Ship). Waves 3 and 4 add a trait; each new set adds one permanent Cylon tactic and +0.25x to the score (up to 3x).
- **Bonus sweep** after each Major engagement: Raiders cross without firing. Destroy them all for a PERFECT bonus.
- **Systems Bonus** for each wave survived, chosen at random.
- **Fixed Heavy Raider box**: the warning box keeps one size and place; HEAVY RAIDER APPROACHING is centred in it until the hack starts.

Version 1.1.0 added:

- **Battle readout (left side)**: enemies destroyed this battle by every source, then our losses, then EMP CHARGES in EMP blue. See **Battle readout** below.
- **Landing pause**: LAUNCH VIPERS waits 3 seconds after a Viper lands, and LAUNCH RAPTOR waits 5 seconds after a Raptor lands.
- **Stealth Viper harder to bring home**: once it has fired, nearby Raiders chase it a short way and shoot at it. About one run in four is lost.
- **Random nuke speed**: each Basestar nuke flies 0% to 8% faster than usual (Hard leans to the faster end).
- **All Raptors on auto against several nukes**: with Auto Launch Raptors on and 2 or more nukes on screen, every available Raptor launches at once.

## Import on Mac

1. Extract `DRADIS_Battle_Console_1.2.6_2026-10-12.zip` into a new location. Keep the existing working project as a backup.
2. In Godot 4.7 Project Manager, choose **Import**.
3. Select `project.godot` inside `DRADIS_Battle_Console_1.2.6`. The project now appears as **DRADIS Battle Console**.
4. Open the project, let importing finish, and press F5 or click Run Project.
5. The tuning panel starts hidden. Press F1 to show/hide it; some Mac keyboards require Fn-F1.

Because the name changed, this version keeps its own high scores and settings. Earlier BSG DRADIS test scores are not carried over.

## Export

Export templates for Godot 4.7 must be installed once (**Editor > Manage Export Templates**). **Build > Development Build** on **DradisConsole** is now off by default, so exports have no development labels and F1 does nothing. Tick it (and save with Cmd-S) only when the F1 tuning panel is needed.

### Windows

1. Open **Project > Export** and select the **Windows Desktop** preset: x86_64, one single .exe with the game inside, no extra console window, and DRADIS Battle Console in the file details.
2. Click **Export Project**, keep the name `DRADIS_Battle_Console_1.2.6_Windows_x64.exe`, untick **Export With Debug**, and click **Save**.
3. For a Windows on ARM laptop, change **Architecture** to arm64 in the same preset, export with a name ending `_Windows_arm64.exe`, and set it back to x86_64 afterwards.
4. Windows may show "Windows protected your PC" the first time because the .exe is not code-signed. Click **More info**, then **Run anyway**.

### Mac (DMG)

1. Open **Project > Export** and select the **macOS** preset: Universal (Apple Silicon and Intel), bundle identifier `com.dradisbattleconsole.game`, version 1.2.6, built-in ad-hoc signing and no notarization.
2. The two yellow warnings from the earlier build are handled: ETC2 ASTC texture import is switched on in Project Settings (required for a Universal Mac build), and code signing is set to ad-hoc. A remaining warning about notarization is expected; notarization requires a paid Apple Developer account and is not needed for personal testing.
3. Click **Export Project**, keep the name `DRADIS_Battle_Console_1.2.6_Mac.dmg`, untick **Export With Debug**, and click **Save**.
4. Open the DMG and drag the app to Applications. The first time, macOS may say it cannot check the app for malicious software. Close that message, open **System Settings > Privacy & Security**, scroll down, and click **Open Anyway** next to DRADIS Battle Console. After that it opens normally.

Notes:

- Do not change the sound files' **Import As** setting. The two sounds the game reads directly are set to uncompressed import, so the exported copy has exactly the same samples.
- Icon: **Application > Icon** in each preset (Windows: a .ico with 16 to 256 pixel sizes; Mac: a 1024 x 1024 PNG or .icns).
- The `references` folder and the guide files are left out of the exported game; they are not needed to play.

## Settings (gear icon)

The gear icon at the top right, just left of SCORE, opens **SETTINGS**. Mouse, touch screen and keyboard all work. The battle pauses while the panel is open (BATTLE PAUSED). The DRADIS sweep keeps playing so its level can be heard. Click **CLOSE**, the gear again, or press Esc to return to the battle.

- **EFFECTS VOLUME**: alerts, weapons and all battle sounds. The starting level is 50%, about half as loud as before. Releasing the slider plays a short sample beep.
- **DRADIS VOLUME**: the background radar sweep only. 100% keeps the approved -20 dB level.
- **MUTE** to the right of each slider silences that group and reads **MUTED**; press again to restore it. 0% is also silent.
- **DIFFICULTY**: EASY, NORMAL or HARD. A change made during a battle starts with the next battle; the panel then shows **NEW BATTLE**, which starts a fresh battle straight away. Retry or Game Over also starts the next battle on the new level.
- **AUTO DEFENSE BATTERY**: when ON, the battery fires by itself as standard missiles come close to the flak arc (a moment before they reach it) and stops when they are gone, keeping the rest of its charge. It follows the normal charge and 15% restart rules. Once it starts, it fires for at least half a second, so it never just blinks on and off. The button shows **AUTO** (for example AUTO READY 100%), and pressing it by hand still works.
- **AUTO LAUNCH**: **VIPERS** launches Vipers by itself while enemy fighters are on the scope (at least 2 out, one per fighter, up to 6). **RAPTORS** launches a Raptor for each inbound nuke and keeps one Raptor out while a Basestar is identified. The normal cooldowns and limits still apply, and nothing launches during the safe period after a jump. The launch buttons show AUTO and still work by hand.
- **AUTO FTL JUMP**: when ON, FTL engages by itself as soon as the hull drops below 10% and FTL is charged. It costs the usual 3,000 points and keeps the damage, like a manual jump. If the hull is still below 10% when FTL has recharged, it jumps again. The FTL button shows AUTO.
- **AUTO RAPID REPAIR**: when ON, a repair charge is used by itself as soon as the hull is at 50% or less, if a charge is available and no repair is running. It follows the normal repair rules (+25% over 5 seconds per charge). The RAPID REPAIR button shows AUTO and still works by hand. With AUTO FTL JUMP also on, the repair normally happens long before the hull falls below 10%.
- **REMEMBER SETTINGS**: ON (the default) keeps every choice for the next start, as before. OFF makes the next start return to NORMAL with every auto option off; volumes, mutes and this switch itself are kept either way.
- **DEFAULTS** (beside REMEMBER SETTINGS; called RESET TO DEFAULTS before 1.05) puts every setting back to its default straight away: volumes 50% and 100%, nothing muted, NORMAL, all auto options off. It asks once more (**CONFIRM**); press again within 3 seconds. The REMEMBER SETTINGS choice and the high scores are not affected.
- The small dim text centered at the bottom shows the build, for example **DRADIS BATTLE CONSOLE 1.2.6**. From 1.08 it is a link to the project's GitHub page (https://github.com/S8619G/DRADIS-Battle-Console), which opens in the web browser. The address is **DradisConsole > Diagnostic Log > Github Url** in the Inspector.
- Just right of it, a small round **!** opens the game's app data folder in Finder or Explorer. The session logs are in its **logs** folder (see Diagnostic log); the settings and high-score files are there too. It underlines and brightens while the mouse is over it.
- The number in the build text comes from **Project Settings > Application > Config > Version**, so it updates with each build. **DradisConsole > Build > Test Build** (off from 1.06) adds "TEST" for a trial copy.
- **QUIT** (bottom left) closes the game. It asks once more (**CONFIRM QUIT**); press again within 3 seconds to quit. Settings are saved first.
- **AUTO FIREWALL**: when ON, the Firewall rises by itself as soon as a Heavy Raider starts hacking, and lowers itself when the hack ends, but not before it has been up for half a second. The button shows AUTO.
- **SCORE MULTIPLIER** shows the effect of the choices on points (see below).

Settings are saved automatically on this computer in Godot's user data folder, in `dradis_settings.cfg`. On a Mac this is `~/Library/Application Support/Godot/app_userdata/DRADIS Battle Console/`; on Windows `%APPDATA%\Godot\app_userdata\DRADIS Battle Console`. The new file is written and checked before it replaces the old one. A damaged or edited file falls back to safe values. Delete the file to return to the defaults.

## Bonus features: Double Missile

Bonus features are rewards that unlock during a battle. The first is **DOUBLE MISSILE**: once the points earned in the battle reach the level's threshold, the ship fires two missiles per volley instead of one, for the rest of the battle.

| | Easy | Normal | Hard |
|---|---:|---:|---:|
| Points needed | 15,000 | 17,500 | 20,000 |

- Earned points count, so an FTL jump's cost does not take the bonus away.
- When it unlocks, a short rising two-tone chime plays once (on the Effects volume, quieter than the alerts) and the status line shows **DOUBLE MISSILE BONUS ACTIVE**.
- While it lasts, the words **DOUBLE MISSILE BONUS** sit just below the SCORE box, above TARGET VALUES, in small steady text. Later bonuses will appear on the lines below it.
- Retry or a new battle starts over.
- Inspector (**Contacts > Bonus Features**): Double Missile Bonus (on/off), Easy / Normal / Hard Double Missile Points, Bonus Chime Volume Db.

## Diagnostic log

From 1.05 the game writes a small session log of its own, to help explain a freeze or a crash. There is one file per play session, named `dradis_session_<date>_<time>.log`, in a `logs` folder next to the settings file:

- Mac: `~/Library/Application Support/Godot/app_userdata/DRADIS Battle Console/logs/`
- Windows: `%APPDATA%\Godot\app_userdata\DRADIS Battle Console\logs\`

Clicking the small round **!** beside the version text at the bottom of **Settings** opens the app data folder that contains this **logs** folder (1.05 had an OPEN LOG FOLDER button; 1.06 and 1.07 used the version text). FTL going offline and back online is written to the log as an EVENT. Godot's own `godot.log` files are in the same folder; the game now keeps the last 10 of those as well (was 5).

What it records:

- **START**: the version, Godot version, system, CPU type, screen size, graphics driver and graphics card, difficulty, auto options and volumes.
- **HEARTBEAT** every 10 seconds: battle time, frames per second, the slowest frame, whether the battle is paused or Settings is open, the number of contacts, and the clicks, taps and key presses received since the last heartbeat.
- **EVENT**: Settings opened and closed, difficulty changes, waves, FTL jumps, game over, Retry and Quit.
- **STALL**: a background check notes any moment when no frame has been drawn for 2 seconds or more, and **RECOVERED** when drawing resumes.
- **SCRIPT / WARNING**: script errors and warnings are copied into the log on Godot 4.5 and newer (Godot 4.7 included). On Godot 4.4 they still appear in `godot.log`.

Each line is written to disk at once, so the file survives a crash or a forced close. The last 10 session files are kept and each stops at about 1 MB. The log holds no personal data: no names, folder paths or typed text. It stays on in final builds and costs almost nothing.

Reading it after a freeze:

- **Heartbeats keep coming with normal frames per second and the clicks are counted** while the screen looked frozen: the game was running, but its picture was not reaching the screen. That points to the graphics layer (on Windows on Arm, the OpenGL-on-Direct3D 12 layer), and makes ANGLE the fix to try.
- **Heartbeats stop and a STALL is logged**: the freeze was inside the game loop. The lines just before it show what was happening.
- **No STALL, no gap, but no clicks counted**: touch or pen input was not reaching the game.

From 1.09, Windows PCs with a Qualcomm GPU start with ANGLE automatically (**Project Settings > Rendering > GL Compatibility > Force Angle On Devices** keeps Godot's own list and adds two Qualcomm entries; the Windows export preset always includes the ANGLE files). On a Surface Pro the START line should read **graphics driver opengl3_angle**. The log also notes when the window loses or gets focus.

Inspector (top **DradisConsole** node > **Diagnostic Log**): Session Log Enabled (on), Log Heartbeat Seconds (10), Log Stall Seconds (2), Log Keep Files (10). The 1 MB size limit is set in `scripts/SessionLog.gd`.

## Difficulty

| | Easy | Normal | Hard |
|---|---:|---:|---:|
| Enemy toughness (Heavy Raider / Basestar / Resurrection Ship hits) | 2 / 4 / 7 | 3 / 6 / 10 | 4 / 8 / 13 |
| Attack frequency (Raiders, missiles, nukes, flak, Heavy Raiders, barrages) | 25% less often | as before | 30% more often |
| Missile and nuke damage | 75% | 100% | 125% |
| Heavy Raider hacking speed | 70% | 100% | 130% |
| Wave length | 2:30 | 2:00 | 1:36 |
| Defense Battery recharge, empty to full | 19.2 s | 24 s | 31.2 s |
| Missile and nuke speed | as before | 10% faster | 60% faster |
| Score multiplier | x0.75 | x1.00 | x1.50 |

Raiders still fall to a single hit on every level. Each auto option that is on lowers the score multiplier by 10%. There are six (battery, firewall, Vipers, Raptors, rapid repair, FTL); all six on gives 40%. For example, HARD with two auto options is x1.20. The TARGET VALUES list on the right shows the points actually earned, with the multiplier beside its heading, and THREAT WAVE shows the current difficulty.

## FTL flash

Every FTL jump, manual or automatic, plays a short animation:
- A bright blue-white band wipes left to right across the DRADIS scope, trailing thin horizontal streaks, in about 1.1 seconds.
- A single blue-white flash covers the whole screen at the moment of the jump and fades within half a second. It never strobes.
- **Contacts > FTL Flash** sets its length and strength or switches it off. **Screen Flash Enabled** (Explosions) also turns off the full-screen part.

## Quit

- **Settings:** QUIT at the bottom left, with CONFIRM QUIT as a second step.
- **Game Over:** Quit beside Retry. A new high score is saved under the initials shown first, exactly as Retry does.

## Explosions

- **Raider destroyed**: a small orange burst with a few sparks (about 0.4 seconds) and a short, light boom. No screen flash.
- **Heavy Raider destroyed**: the same burst, a little larger and longer, with a fuller boom.
- **Viper or Raptor lost**: the same small burst in green-white, so own losses are easy to spot.
- **Basestar or Resurrection Ship destroyed**: a large explosion (white core, fireball, two shock rings and debris, about 1.4 seconds), one warm screen flash and a deep, two-part boom of about two seconds.
- **Missile destroyed** (by the Defense Battery or a Viper): a tiny white-hot flash with a small orange ring, gone in 0.3 seconds, and a small, short boom.
- **Nuke destroyed by a Raptor**: a brief explosion (white core, orange fireball, shockwave ring and sparks, gone in 0.8 seconds), one warm flash across the whole screen that fades in about a third of a second, and a deeper boom of about one second.
- **Nuke hits the ship**: the same explosion, slightly larger, at the ship, with a stronger screen flash. The existing hull impact boom and red outline flash remain.
- The flash is a single fade, never a repeated strobe.
- Several destructions at the same moment make one boom, not a loud stack.
- All booms are original sounds generated in code. They play on the Effects bus below the alert levels: fighter -19 dB, Heavy Raider -16 dB, missile -15 dB, nuke -9 dB, capital ship -7 dB.
- Everything can be changed in the Inspector (**Contacts > Explosions**). That includes switching the screen flash off (it covers nukes and capital ships), and **Craft Explosions Enabled** switches the fighter bursts and booms off.

## Nuclear missiles take several Raptor hits

A Raptor has to stay with a nuke to destroy it:
- It takes 6 hits on NORMAL, 4 on EASY and 8 on HARD (1.2.1; was 3, 2 and 4), with 0.7 seconds between hits (1.2.2; was 0.6): about 3.5 seconds of chase on NORMAL, 2.1 on EASY and 4.9 on HARD.
- After the first hit, the label above the warhead shows its remaining strength, for example **NUCLEAR 67%**.
- The status line reports each hit.

In simulated battles, Raptors still stopped every nuke before it reached the ship. Raptor losses rose slightly, from about 2.2 to about 3.0 per 10 minutes, because Raptors spend a little longer near the Basestars. **Contacts > Nuclear Interception > Nuclear Hit Points** set to 1 restores the old one-touch interception.

## Viper squadrons

Vipers flying close together are shown as one **VIPERS x2** contact (or x3 and more) with the squadron icon.
- They split back into single Viper icons when they spread apart.
- They join when closer than 0.075 and split beyond 0.06 from the group center (0.12 before 1.07), so the icon does not flicker but a Viper breaking off to fight shows on its own.
- **Split to engage (1.07)**: with several enemies about, squadron mates spread over different Raiders and missiles instead of all chasing one. Up to 2 Vipers share a tough target (Heavy Raider, Resurrection Ship). With one enemy left they may all go for it. Hacking Heavy Raiders and close missiles keep their priority.
- **Rejoin (1.07)**: a Viper with nothing left to chase flies back to the others. With the area clear, all idle Vipers patrol together in one loose formation and show as one squadron again.
- Inspector (**Contacts > Viper Squadrons**): Squadrons Split To Engage (on; off = all chase the nearest, as before), Max Vipers Per Tough Target (2), Squadron Spread Penalty (3), Formation Spacing (0.02).
- A returning (RTB) Viper always shows on its own.
- Grouping is display only. Each Viper keeps its own health, losses and score, and VIPERS ACTIVE still counts every Viper. From 1.07 the strength percent is shown only with **Show Full Tags**.
- **Contacts > Viper Squadrons** can switch this off.

## Development labels

The lower-left **DRADIS -20 dB** and lower-right **F1 TUNING PANEL** labels and the F1 tuning panel are development aids. From 1.04 they are **off by default**. To use them, open `scenes/DradisConsole.tscn`, click the top **DradisConsole** node, tick **Build > Development Build** in the Inspector and save (Cmd-S). Untick it and save again before exporting a copy for others.

This README is the current guide. Older start guides and changelogs are retained as history and may describe superseded mechanics.

## Scope look (1.2.4)

- Every new look has its own switch, so each can be turned off on its own. Turning **Ring Horizontal Hinge Front Back**, **Ring Trail Enabled** and **Ripples Match Ring Plane** off, and setting **Ripple Max Radius** back to 340, gives the 1.2.3 dome.
- The dome values are on **DradisConsole > CenterContainer > Dome** (groups **Ring Hinge**, **Ring Trail** and **Ripples**). Keep the rings quiet: the trail values share the ring's existing light rather than adding to it.
- The outline and panels are on **DradisConsole > ConsoleFrame** (groups **Scope Frame** and **Panel Animation**). Unticking **Scope Frame Visible** gives the 1.2.3 frame, with its line under the dome. They follow the dome's Sphere Radius and are drawn under the contacts and the rings.
- **Keep Play In Wedge** is on **Contacts** (group **Keep Play In Wedge**). A contact that has been inside the outline and drifts out is moved back just inside (Wedge Margin 0.06 of the sphere radius) and stops moving outward. Contacts that start outside fly in as before. Untick it for the 1.2.3 open scope.
- The Heavy Raider warning box sits over the left corner panel; the panel is hidden behind it so the warning reads exactly as before.

## Console layout (1.2.5)

- **Console Layout V2** (on **DradisConsole > ConsoleFrame**, group **Console Layout 2**) turns the 1.2.5 layout on. Untick it for the 1.2.4 layout.
- The corner panels reach up beside the scope. Their inner edges continue the V and every tab, light and box keeps the same gap to the scope.
- Ready lights at eye level: VIPERS and RAPTOR on the left, FTL and DEFENSES on the right. Each is bright when its bottom button is ready and dim when it is not. They are lights only and cannot be clicked.
- The alert box in the left panel always shows. It reads ALERT STATUS when quiet and fills with the Heavy Raider warnings (amber while one approaches, flashing red while hacking or draining). From 1.2.6 the box outline stays in the panel colour where it was amber; the text stays amber, and the outline still blinks red while hacking and turns red after a breach.
- The NAV DATA box in the right panel shows made-up information about the area of space: sector, coordinates, nearest star, planets, one local condition and the jump count. It changes at the start of each battle and after each FTL jump, and stays still in between. **Nav Data Panel** turns it off.
- The left gauge is the ship's hull (HULL) and turns red at **Hull Low Percent** (30%) or less. With **Live Readouts**, TRACKS shows the number of contacts and the right scale shows the Defense Battery charge.
- From 1.2.6 the rolling scanlines are drawn only inside the scope outline (**Dome > Scanlines > Scanlines Inside Scope**), so the panels, tabs and boxes stay still.
- The status message has its own box, and the six top tabs are lower and wider, reaching to the scope. The thin rectangle around the scope is removed; the line above the bottom buttons stays. The bottom buttons are centred between that line and the frame bottom.

## Header and ship outline

- The upper-left title reads **DRADIS** and is centered over the TACTICAL DEFENSE CONSOLE line beneath it.
- The SHIP STATUS text to the left of the ship outline is removed.
- **FTL** is centered in the left (stern) section of the outline and **HULL** in the right (bow) section. Their positions can be adjusted in **DradisConsole > ShipStatus > Ftl Center / Hull Center** (fractions of the outline width, 0.18 and 0.855). FTL was moved right so it sits in the middle of the visible stern section.

## Battle readout

The left side of the console, below RAPID REPAIR, lists this battle's totals:

- **Enemies destroyed**, by every source (ship missiles, Vipers, Raptors, the Defense Battery and the Stealth Viper): RAIDERS DESTROYED, HEAVY RAIDERS DESTROYED, MISSILES DESTROYED, NUKES DESTROYED, BASESTARS DESTROYED, RESURRECTION SHIPS DESTROYED.
- **Our losses**: VIPERS LOST, RAPTORS LOST, STEALTH VIPERS LOST.
- **EMP CHARGES** as the last line, in the EMP blast color. It uses **Contacts > EMP Defense > Emp Color**, so changing that one color changes both the EMP shimmer and this line.

The totals are the same ones saved with a new high score. Retry starts them from zero; an FTL jump keeps them. Inspector: **DradisConsole > Battle Readout > Readout Font Size** (16).

## Stealth Viper

A special Viper with two nuclear missiles, for battles with many capital ships.

- **When it is offered**: only on Normal and Hard (never on Easy), while 3 or more large ships (Basestars and the Resurrection Ship) are on the scope and the Stealth Viper is home and ready. Then the top nacelle of the ship (the part above the middle) turns blue with **STEALTH WEAPON**, pulsing gently, and a bright chime plays once. At any other time the nacelle looks normal and follows the hull color.
- **Launch**: click or tap the blue nacelle. Manual only; no auto option launches it. Once it is out, the nacelle goes back to normal.
- **On the scope**: a Viper icon tagged **STEALTH**. It flies about twice as fast as a Viper and blinks rapidly while the enemy cannot see it.
- **Attack**: it heads for the nearest large ship and fires its two nukes 4 seconds apart. Each nuke does half of a Basestar's hits, so both destroy a Basestar; on a Resurrection Ship each takes 5 of its 10 hits. Destroyed ships give their normal points. If its target is destroyed first, the next nuke goes to the nearest other large ship. If the number of large ships drops below 3, it still finishes its run.
- **After firing**: the enemy can see it. It stops blinking and flies home. It is more fragile than a Viper: one Raider hit destroys it. From 1.1.0, every Raider within 0.40 of it turns on it, chases it a short way (0.25) and shoots at it from up to 0.30, once every 1.5 seconds, then gives up and goes back to its job. Its speed is still its main protection; about one run in four is lost. Basestar flak does not target it.
- **Rearm and rebuild**: after a safe landing it is ready again 60 seconds later. If it is destroyed, a new one takes 3 minutes on Normal or 4 minutes on Hard. Both happen quietly, with no message or timer; the blue nacelle and the chime show when it is back. An FTL jump brings it home (it then rearms). Retry starts a battle with it ready.
- **Log**: availability, launch, each nuke, loss and return are written to the session log.
- Inspector: **Contacts > Stealth Viper**: Stealth Viper Enabled, Stealth Min Large Ships (3), Stealth Speed Factor (2.2), Stealth Nukes (2), Stealth Nuke Strength (0.5), Stealth Shot Seconds (4), Stealth Fire Range (0.35), Stealth Nuke Speed (0.5), Stealth Rearm Seconds (60), Stealth Rebuild Normal Seconds (180), Stealth Rebuild Hard Seconds (240), Stealth Blink Hz (6), Stealth Ready Sound Enabled, Stealth Ready Volume Db (-12), and from 1.1.0 Stealth Focus Range (0.40), Stealth Pursuit Distance (0.25), Stealth Shot Range (0.30), Stealth Shot Interval (1.5), Stealth Hit Chance (0.045). **ShipStatus > Stealth Weapon**: Stealth Blue, Stealth Label, Stealth Font Size (15), Stealth Pulse Hz (0.8).

## EMP

The EMP is an electronic pulse that overloads hacking Heavy Raiders without destroying them.

- **Charges**: one per 5,000 earned points in a battle, up to 2 held. The sidebar shows **EMP CHARGES**. An FTL jump keeps them; Retry or a new battle starts with none.
- **FIREWALL | EMP (1.07)**: the Firewall is always the first answer. The EMP is offered only while a Heavy Raider is hacking or draining, a charge is ready, and the Firewall has run out (or is too low to raise) for 2 seconds. Then the FIREWALL button splits in two: FIREWALL with its charge on the left, and an electric-blue **EMP** half with the charges held on the right. Click (or tap) the EMP half. When the hack ends or the EMP is used, it is a whole FIREWALL button again. If the Firewall is switched off in the Inspector, the EMP half shows as soon as a hack starts.
- **INTRUSION DETECTION** always stays in the middle of the ship while a Heavy Raider hacks (1.06 replaced it with USE EMP; **ShipStatus > Emp On Ship** brings that back).
- **Effect**: an electric zap plays. Every hacking or draining Heavy Raider shimmers electric blue with small sparks for about a second (label **EMP OVERLOAD**). The hack and hull drain stop at once. Each one then flies back to its Basestar (label **HEAVY RAIDER**, flashing lighter like other returning ships) and docks for repairs. It is not destroyed and gives no points; it can still be shot down on the way for the usual points. The Basestar can launch a repaired Heavy Raider again later. If its Basestar is gone, it flies off the scope.
- **Manual only**: there is no AUTO EMP. The Firewall is unchanged; the EMP is the stronger, rarer option.
- Inspector (**Contacts > EMP Defense**): Emp Enabled, Emp Points Per Charge (5,000), Emp Max Charges (2), Emp Shimmer Seconds (1.0), Emp Color, Emp Zap Volume Db (-10), Emp Delay After Firewall (2.0 seconds). The EMP button color is **ShipStatus > Rapid Repair and EMP > Emp Blue**.

## Rapid Repair sound and glow

While a Rapid Repair runs (5 seconds), manual or AUTO, a smooth rising "recharging" tone plays on the Effects volume, quieter than the alerts, and the ship outline and fill pulse between the hull color and a brighter green, twice a second. Both stop when the repair ends. A missile hit still flashes the ship red.

Inspector (**Contacts > Rapid Repair Feedback**): Repair Sound Enabled, Repair Sound Volume Db (-16), Repair Flash Enabled, Repair Flash Hz (2). The brighter green is **ShipStatus > Rapid Repair and EMP > Repair Green**.

## Enemy missile pulse

From 1.07 enemy missiles pulse: their brightness swings smoothly between full and 35%, twice a second. They are always drawn, so one is never lost mid-blink. Nukes, ship missiles and Raptor missiles keep their steady look. Inspector (**Contacts > Missile Visibility**): Enemy Missile Pulse (on), Enemy Missile Pulse Hz (2), Enemy Missile Pulse Min (0.35).

## Missiles change target

From 1.07 a ship or Raptor missile whose target is destroyed, leaves the scope or docks after an EMP turns toward the nearest enemy it can attack (Basestar, Heavy Raider, Resurrection Ship or nuke) and flies on at its normal speed. A nuke that already has enough ship missiles on the way for the hits it still needs is skipped (the 1.05 rule). Only when no valid target is left does the missile disappear.

## Tags

From 1.07 the scope tags are shorter:
- Raiders, Vipers and Raptors show **RAIDER**, **VIPER** and **RAPTOR** only, without the ID, RTB or strength percent. Squadrons show **VIPERS x2**, **VIPERS x3** and so on.
- Enemy missiles, ship missiles and Raptor missiles have no tag.
- Unchanged: **NUCLEAR** with its hit percent, **BASESTAR** and **RESURRECTION** with their strength, **IDENTIFYING**, and the Heavy Raider tags (HEAVY RAIDER, HACKING 6s, HULL DRAIN, EMP OVERLOAD). From 1.09 there is no HEAVY RAIDER RTB tag, and a hacking Heavy Raider's tag sits above it.
- **Contacts > Show Full Tags** (off) brings back the full tags with IDs, for testing. The IDs are still used in the session log.

## Missiles on top

Enemy missiles, nuclear missiles, ship missiles, Raptor missiles and Basestar flak are drawn last, over every ship, name and explosion, so they are never hidden when the scope is crowded. Their look is unchanged. Only the full-screen FTL flash covers them.

## Hover pop-ups

From 1.06 the help text that popped up when the mouse rested on a button is switched off, because it covered the button text. The help text is still in the game. To show it again, select the top **DradisConsole** node and tick **Build > Show Hover Tooltips**.

## Intrusion detection

While a Heavy Raider is hacking or draining the ship, a red-outlined box appears in the center of the ship outline. It is filled with thick 45-degree red and black stripes, and the words **INTRUSION DETECTION** flash on and off over it (3 times per second). It disappears when no Heavy Raider is hacking. From 1.07 it always shows, including while the EMP is offered on the FIREWALL button (see EMP). Size, stripe width, flash rate and red can be adjusted in **DradisConsole > ShipStatus > Intrusion Detection**.

## Firewall

**FIREWALL** is the new button between DEFENSE BATTERY and LAUNCH VIPERS. It is an electronic countermeasure against Heavy Raider hacking.

- It can be switched on only once a Heavy Raider begins hacking (the button reads **STANDBY** until then, and **READY 100%** once usable).
- While on (**ACTIVE n%**), the hack runs at a quarter of its normal speed, and a breached ship's hull drain is slowed the same way. An electronic defense sound plays (a fast digital warble over a low pulsing hum). The hacking alert shows FIREWALL UP | HACK SLOWED.
- It is used up quickly: 4 seconds of use from full to empty.
- It recharges faster than the Defense Battery: 8 seconds from empty to full (after a half-second pause), shown as **RECHARGING n%**. After running dry it can be used again from 25%.
- Press it again to switch it off early and save the rest of the charge. It also switches itself off when the hack ends; FTL stops it and Retry restores a full charge.
- The Firewall slows a hack but cannot stop it; ship missiles, Vipers and Raptors still have to destroy the Heavy Raider.

## Fighter losses

Vipers and Raptors can be destroyed in battle.

- **Raptors are armored:** 7 hits to destroy, and they still dodge 75% of incoming fire (Basestar flak and Raider attacks).
- **Vipers are lighter but nimble:** 2 hits to destroy, and they dodge 20% of Raider fire by maneuvering.
- For comparison, a Raider is destroyed by 2 Viper hits and a Heavy Raider by 5 (1.2.1).
- Raiders attack nearby Vipers and Raptors on patrol. Each attack has a 50% chance to hit before the target's dodge chance.
- In test battles with the same play pattern, about 5 Vipers and fewer than 2 Raptors were lost per 10 minutes. Before this change it was about 2 Vipers and 10 Raptors, mostly to Basestar flak.
- Returning Vipers are still easy prey: each Raider attack has a 50% chance to destroy one.
- A damaged Viper or Raptor shows its remaining strength after its name, for example **VIPER F-003 75%**.
- Each Viper lost costs **200 points** and each Raptor lost **400 points**. The score never drops below zero, and losses never take back progress toward bonus repairs.
- The left sidebar counts **VIPERS LOST**, **RAPTORS LOST** and **STEALTH VIPERS LOST**, and the status line announces each loss and its penalty.

## Window and full screen

When the game starts, it checks the resolution of the screen it opens on and sizes the window to 85% of the usable area (inside the menu bar, taskbar or Dock), keeping the 16:9 shape, centered. On a 4K screen that is about 3170 x 1785 pixels. On a 1080p screen it is about 1570 x 885, much as before. A small laptop screen gets a window that fits. The whole console scales with the window, so dragging the window larger also enlarges everything.

The fit is controlled by **DradisConsole > Display > Fit Window To Screen** (on) and **Window Screen Fraction** (0.85); turn it off to keep the fixed 1600 x 900 window. When the game runs inside the Godot editor's own Game tab, the editor sets the size instead.

Press **F11** to switch to full screen and F11 again to return to the window. **Esc** also leaves full screen. On many Mac keyboards F11 needs **Fn-F11**; if macOS uses F11 for "Show Desktop", use Fn-F11 or turn that shortcut off in System Settings > Keyboard > Keyboard Shortcuts. The key can be switched off with **DradisConsole > Display > Fullscreen Key Enabled**.

## Readability

- Ship icons are about 30% larger (**Contacts > Icon Size**, now 1.3).
- Ship names use a larger font (16, with capital ships at 18), are slightly brighter than their icons, and have a thin dark outline so they stay readable over the rings (**Contacts > Label Font Size, Label Outline Size**).
- Capital ships are placed so their names never overlap one another.
- Lines, icons and missile arrows are drawn with smoothing (anti-aliasing). Godot's separate 2D MSAA setting is left off because the Compatibility renderer used by this game reports it as unsupported, and turning it on could change how the rings look.

## Threat waves

From 1.2.0 a wave is one Cylon attack, not a stretch of time. The right sidebar shows **THREAT WAVE**, **WAVE n**, then the set and how many Basestars are still to destroy (**SET 1 | BASESTARS LEFT 3**), and on a smaller amber line the wave name, any trait and the set multiplier.

Each wave runs in the same order:

1. **Assault**: the status line names the wave and its Cylon force (for example **WAVE 2 | STRIKE | 3 BASESTARS**). Its Basestars arrive one after another, never more on the scope at once than the table allows.
2. **Cleared**: when the last Basestar (and, in a Major engagement, the Resurrection Ship) is destroyed, the remaining Raiders and Heavy Raiders jump away. Missiles already in flight still come in. A soft two-note cue plays.
3. **Rest**: a tally panel in the lower scope shows the wave bonus, the Systems Bonus (or NO SYSTEMS BONUS) and what comes next. Rest lasts 10 s on Easy, 7 s on Normal and 5 s on Hard. For the last 3 seconds the status line reads **WAVE n INBOUND** and three low horn pulses play.

| Wave in set | Name | Easy | Normal | Hard | Basestars at once | Heavy Raiders at once | Launch intervals |
|---:|---|---:|---:|---:|---:|---:|---:|
| 1 | Probe | 2 | 2 | 2 | 2 | 1 | normal |
| 2 | Strike | 2 | 3 | 3 | 2 | 2 | 95% |
| 3 | Assault | 2 | 2 | 3 | 3 | 2 | 90% |
| 4 | Pressure | 2 | 3 | 3 | 3 | 2 | 85% |
| 5 | Major engagement | 2 | 3 | 3 | 4 | 3 | 80% |

The Easy, Normal and Hard columns are the Basestars to destroy (1.2.1: one fewer in waves 3 to 5 than in 1.2.0, because each Basestar now takes more hits: 11 on Normal from 1.2.2). The Major engagement also brings the Resurrection Ship 20 seconds in; it no longer appears at random. If a wave runs 5 minutes no more Basestars arrive, so it always ends.

**Traits** (waves 3 and 4 on Normal; waves 2 to 4 on Hard; Easy has none in the first set). Each is announced at the start of the wave and never repeats within a set:

| Trait | Effect for that wave |
|---|---|
| RAIDER SWARM | Raiders launch 30% more often, missiles 30% less often |
| MISSILE BARRAGE | Missiles launch 30% more often |
| NUCLEAR STRIKE | Basestars launch their nukes in half the usual time |
| HEAVY ASSAULT | Heavy Raiders launch 40% more often |
| ESCORT | Basestars arrive close together |

**Sets and Cylon tactics.** After the Major engagement a new set starts again at the Probe with one new permanent tactic, announced in the WAVE INBOUND line: set 2 QUICKER LAUNCHES (launches 15% more often), set 3 HARDENED BASESTARS (one more hit), set 4 FASTER HACKING (hack time about 6 s to 5 s), set 5 FASTER WARHEADS (missiles and nukes 8% faster). From set 6 the list repeats in half steps, with caps so very long battles stay playable. Easy uses half steps throughout.

**Score multiplier.** Each completed set adds +0.25x to every score, up to 3x (SCORE x1.25, x1.50 ...). It is shown in TARGET VALUES and on the wave line.

**Wave tally.** Clearing a wave scores 500 plus 10 per hull percent kept; the Major engagement adds 2,500. Both use the score multiplier.

**Protect the fleet (1.2.2; tougher Raiders from 1.2.3; fairer from 1.2.5).** After each Major engagement the status line reads **PROTECT THE FLEET** and the scope is reset: no Basestars, missiles or fighters left over.

- 2 to 4 civilian ships appear, picked at random from five types. They are blue, dim toward grey-blue as they take damage, and blink when their hull is critical (25% or less). Each label shows its hull, for example **CIVILIAN 60%**.
- Only Raiders attack, and they go for the civilian ships, not for your ship or your Vipers. There are 4 Raiders after set 1 and 2 more after each later set, up to 12. Easy has 2 fewer and Hard 2 more (never above 12).
- A lone Raider destroys a civilian ship in 26 seconds on Easy, 20 on Normal and 14 on Hard after set 1. From 1.2.3 each later set takes 10% of that time off, never below 10 seconds (Normal: 20, 18, 16, 14, 12, then 10 s). Two Raiders on one ship take half as long.
- From 1.2.3 the round's Raiders are tougher than in normal waves: a Viper needs 4 hits after set 1, 5 after set 2 and 6 from set 3 (normal-wave Raiders take 2). They arrive 3 at a time, 1 second apart. They fire back: the first Viper to engage each Raider has a 1 in 6 chance of being lost (**VIPER LOST TO RAIDER RETURN FIRE**), one roll per Raider, so about 1 Viper is lost for every 6 Raiders. The usual Viper loss points apply.
- Vipers only. You can launch as many Vipers in the round as there are Raiders. A Viper that is lost or lands is not replaced. Raptors, the Defense Battery, ship missiles and the Stealth Viper are off; their buttons read **VIPERS ONLY**. FTL is held (**HELD | PROTECT THE FLEET**). The auto options pause for the round and resume with the next wave.
- From 1.2.5 toughness depends on size. The large ship (type C) lasts 2 times the kill time, the medium ships (A and D) 1.2 times, and the small ships (B and E) the kill time itself. **Contacts > Civilian Size Toughness** and the three **Civilian ... Toughness** values.
- From 1.2.5 small and medium ships evade. When a Raider comes within 0.2 of the scope radius, the ship moves away from it (small 0.035, medium 0.02 scope radii per second), weaving side to side, with its path bent toward Galactica where the Vipers come from. Ships always stay inside the scope outline and above Galactica's outline. Evading buys time only; it does not reduce damage. Large ships hold position. **Contacts > Civilian Evasion**.
- From 1.2.5 one Viper is already on patrol beside the fleet when the round starts (**Protect Patrol Vipers**, 0 for none). It counts toward the Vipers you can launch.
- From 1.2.5 each Raider holds for 2 seconds where it jumps in, fading up from dim, then attacks (**Protect Jump In Hold**, 0 for none). Vipers can engage it while it holds.
- With all four 1.2.5 switches off the round plays exactly as in 1.2.4.
- The round ends when every Raider is destroyed or every civilian ship is lost, or after 60 seconds. Raiders still present then jump away.
- Bonus: 500 x the hull each surviving ship kept, plus 1,000 if every ship survives. The score multiplier applies. The tally shows the ships saved, their average hull and the bonus.

To play the 1.2.0 bonus sweep instead, set **Defined Waves > Set End Round** to **Bonus sweep** (or **None** to skip the round). In the bonus sweep 12 Raiders cross the scope in groups of three. They do not fire and there are no Basestars or missiles. Each one destroyed scores as usual; destroying all of them adds a PERFECT bonus of 3,000 x the multiplier.

**Systems Bonus.** From 1.2.2 the first set (waves 1 to 5) gives no bonus. From wave 6 each cleared wave has a 40% chance of a bonus, and the end of every set (the Major engagement) always gives one. Bonuses come in three tiers by set:

| Set | Tier offered |
|---|---|
| 1 | none |
| 2 | low: EXTRA EMP CHARGE, FIGHTER SPEED +15% |
| 3 and 4 | medium: EXTRA RAPID REPAIR, EXTRA RAPTOR, RAPID FIRE (1 in 3 from the low tier) |
| 5 on | high: EXTRA VIPER SQUADRON, FREE AUTO BATTERY, STEALTH VIPER READY (1 in 3 from a lower tier) |

Easy and Normal follow this schedule. Hard starts one set later (wave 11, so every tier shifts by one set) with a 20% chance per wave; the end of a set is still guaranteed. A bonus that cannot help (for example a repair when you already hold 3 charges, or FREE AUTO BATTERY when AUTO DEFENSE BATTERY is already on) is skipped and another is drawn from the same tier, or from a lower one. The same bonus never comes twice in a row. A wave with no bonus shows NO SYSTEMS BONUS in the tally:

| Bonus | Effect |
|---|---|
| EXTRA RAPID REPAIR | +1 repair charge (not above 3) |
| EXTRA EMP CHARGE | +1 EMP charge |
| STEALTH VIPER READY | the Stealth Viper finishes rearming (Normal and Hard) |
| EXTRA VIPER SQUADRON | +2 Vipers allowed until the next wave is cleared |
| EXTRA RAPTOR | +1 Raptor allowed until the next wave is cleared |
| FIGHTER SPEED +15% | Vipers and Raptors 15% faster until the next wave is cleared |
| FREE AUTO BATTERY | the Defense Battery fires by itself, with no score penalty, until the next wave is cleared |
| RAPID FIRE | ship missiles and fighters fire 25% more often until the next wave is cleared |

Active boosts are listed under SCORE.

**FTL jump.** During the rest the jump is free, starts the next wave after a 2-second safe period and adds 250 points. During an assault it costs 3,000 points as before; the wave counts as escaped and starts again from its first Basestar. During Protect the fleet FTL is held; with **Protect Allow Ftl** ticked, a jump abandons the civilian ships and gives no bonus. During a bonus sweep the sweep ends without a PERFECT bonus. Retry starts again at wave 1.

**Classic timer waves.** Untick **Defined Waves** (Inspector, Defined Waves group) to play with the 1.1.1 two-minute waves instead.

## Bonus rapid repairs

Bonus RAPID REPAIR charges are now spaced further apart. A charge is earned at 10,000, 25,000 and 50,000 earned points, then every further 50,000 (100,000, 150,000 and so on). The sidebar shows the points still needed for the next bonus, and the RAPID REPAIR tooltip lists the milestones. Earned points still ignore FTL penalties, so a jump never takes back progress.

## Resurrection Ship

From wave 2, a Resurrection Ship may arrive. Only one can be on the scope at a time. It now crosses the radar from one side to the other.

- It appears at the left or right edge of the scope (chosen at random), crosses horizontally just above the center in about a minute, and disappears when it reaches the other side. An escaped ship earns no points.
- It appears already identified, is drawn larger than a Basestar and is labeled **RESURRECTION** with its remaining strength. On arrival a deeper version of the approved alert plays twice. The sidebar shows **RESURRECTION SHIP**, its strength and **NEXT BARRAGE** countdown.
- It fires a barrage while it crosses: **3 missiles, one per second** (timed, not all at once), the first 3 seconds after arrival. A new barrage starts every 8 seconds, shortened by the wave just like Basestar launches, so it always fires faster than a Basestar.
- Barrage missiles fan out left, center and right instead of flying in a line, then close in on the ship. Each does **5 hull damage** (a Basestar missile does 10). The Defense Battery can shoot them down.
- It needs 10 ship-missile hits (a Basestar needs 6). Ship missiles alternate between it and the Basestars, or all go to it when no Basestar is left. Raptors prefer it over Basestars; each Raptor missile does half a hit. From 1.08 **one Viper** breaks off from the squadron to attack it as soon as it is on the scope, while the others keep defending; if that Viper is lost or returns, another takes its place. In testing (Normal, wave 3, auto options on) it was destroyed in about 8 of 10 crossings, usually 40 to 60 seconds into its roughly 66-second crossing (in 1.07 it was never destroyed). **Contacts > Viper Squadrons > Vipers On Resurrection Ship** sets how many (0 = the 1.07 behavior: only once Raiders and missiles are dealt with). A focused attack can destroy it before it escapes; the Defense Battery cannot damage it. Destroying it earns 2,500 points.
- It appears more often as the waves get tougher. Every 20 seconds there is a chance one arrives: 25% in wave 2, rising 5% per wave up to 60%. After one is destroyed, escapes or is left behind by FTL there is a quiet period: 90 seconds in wave 2, 10 seconds shorter each wave, never less than 40 seconds.

## High scores

When the game ends with a score in the top 10, Game Over shows **NEW HIGH SCORE | ENTER YOUR INITIALS** with three letters.

- **Mouse:** click the arrow above or below a letter to change it, then click **ENTER**.
- **Keyboard:** type letters (they become upper case), use Up/Down to change the current letter, Left/Right or Backspace to move, and Enter to save.

**Battle stats (1.08):** each new entry also saves how many of each enemy type the battle destroyed. Hover the mouse over an entry on the board (or tap it on a touch screen) to show a small box with its initials, score, wave and difficulty, the total, and the count of Raiders, Heavy Raiders, missiles, nukes, Basestars and Resurrection Ships. Moving away hides it; a tapped entry stays open until it is tapped again. Entries saved before 1.08 show NO BATTLE STATS. **DradisConsole > High Scores > Show Score Stats** switches it off.

**BEST score (1.08):** during play the best saved score shows in small dim text on the SCORE line, just left of SCORE (there is no room above it inside the header frame). It follows the current score once that is higher. **DradisConsole > High Scores > Show Best Score / Best Score Font Size / Best Score Color**.

The board then shows the top 10 scores with initials, score and the difficulty in full (**EASY**, **NORMAL** or **HARD**; from 1.09 the wave reached is in the hover box); the new entry flashes. Equal scores keep the earlier one higher. The next entry starts with the last initials used. If Retry is clicked before ENTER, the score is still saved under the initials shown, so it is never lost. A score that does not make the top 10 shows the board with SCORE DID NOT REACH THE TOP 10.

Scores are saved on this computer in Godot's user data folder, in `dradis_high_scores.json`. On a Mac this is `~/Library/Application Support/Godot/app_userdata/DRADIS Battle Console/`. Every copy of the project named DRADIS Battle Console shares this folder, so the board carries over between test builds. If the file is ever damaged, it is renamed with `.unreadable-` and the time, and a fresh board starts. Delete the file to clear the board.

## Missile impacts

Standard Basestar missiles now remove 10 hull points per hit (previously 15), so the ship survives ten hits from full hull. Nuclear missiles still remove 60.

Missiles now travel down to the upper edge of the ship-status outline before they hit. Previously they disappeared and caused damage about 69 pixels above the ship. The impact point is **Battlefield > Own Ship Position** (now Y = -1.05) and the hit distance is **Ship Defense > Missile Impact Radius** (now 0.004).

Each standard or nuclear missile hit plays a short 0.45-second boom and flashes the ship outline red for 0.45 seconds. The boom is original, generated in code at -10 dB. Heavy Raider hull drain does not trigger the boom or flash.

## Heavy Raiders

Each identified Basestar periodically launches a Heavy Raider (labeled HEAVY RAIDER). Defaults: one per Basestar, two on screen at most (three from wave 4), a launch every 28 seconds per Basestar (22 before 1.2.1), speed 0.075 scope radii per second (slower than Vipers and Raptors) and three hit points (a Raider needs one).

Heavy Raiders ignore every other ship and fly straight to a parking spot just above the hull, one on each side, then stop to hack.

1. **Approach:** The Heavy Raider flies toward the ship. A warning box appears to the left of the ship outline, below the battle readout: HEAVY RAIDER APPROACHING / PREPARE FIREWALL DEFENSE, with a steady amber border. When the hack starts, the hacking lines (countdown, hull drain, Firewall status) appear in the same box, which then flashes red. The box is hidden while no Heavy Raider is on its way. Position and text size: DradisConsole scene > HackAlert (Layout > Transform, Theme Overrides > Font Sizes, 17). From 1.2.5, with Console Layout V2 on, the same lines appear in the alert box in the left panel instead (ALERT STATUS when no Heavy Raider is on its way).
2. **Hacking:** Once within range of the hull, it hacks for six seconds. No damage occurs yet.
3. **Hull drain:** After a successful hack, it drains 2 percent of maximum hull per second until destroyed. Two hackers drain 4 percent per second. A persistent red COMPUTERS HACKED warning appears.
4. **FTL offline (1.08):** As soon as any Heavy Raider has broken through, FTL goes **OFFLINE**: the ship outline shows OFFLINE in red instead of the FTL percent, the FTL JUMP button reads OFFLINE, and neither a manual jump nor AUTO FTL is possible. FTL comes back online once no Heavy Raider is draining (EMP, destroyed, or out of range); its charge then restarts from 0% and FTL can be used again only at 100% (45 seconds). The Firewall slows the hack, which keeps FTL available longer; the EMP or destroying the Heavy Raider ends the breach.

The Defense Battery cannot damage Heavy Raiders. They can be destroyed by:

- **Ship missiles:** Once a Heavy Raider parks at the ship, the automatic ship missiles target it before Basestars, sending no more missiles than it has hit points left. On their own they usually destroy it after it has drained about 7 to 17 percent hull.
- **Vipers:** They stay on Raiders and missiles first, then break away to attack Heavy Raiders when no Raiders or missiles are left in their zone.
- **Raptors:** Nuclear missiles come first. Raptors chase Heavy Raiders next, unless a Basestar is firing flak at them; then they keep evading and attacking that Basestar.

Destroying a Heavy Raider earns 300 points and stops its drain immediately.

A Heavy Raider already in flight survives the destruction of its Basestar. FTL (when it is not offline) removes all Heavy Raiders and hacking links; Retry clears them as well. Inspector (**Contacts > FTL**): Ftl Offline On Breach (on; off = the 1.07 behavior), Ftl Breach Recharge Seconds (45: how long the rebuild from 0% takes after a breach). The OFFLINE color and size are **ShipStatus > Ftl Offline Color / Font Size**. The six-second hack and 2 percent drain are adjustable starting values, not final balance.

## Score and rapid repair

Destroying a Raider earns 100 points, a Heavy Raider 300, intercepting a nuclear missile 500, destroying a Basestar 1,000 and a Resurrection Ship 2,500. From 1.05, each enemy missile destroyed by the Defense Battery earns 10. Each destroyed contact scores once, and every value is multiplied by the score multiplier (difficulty and auto options), as TARGET VALUES shows.

A successful FTL jump now costs 3,000 points, with a minimum score of zero. Rejected jump clicks cost nothing.

RAPID REPAIR starts with one charge. Each use restores up to 25 percentage points of maximum hull over five seconds, capped at full hull; only one repair runs at a time.

You earn bonus charges at 10,000, 25,000 and 50,000 **earned** combat points, then every further 50,000 (see Bonus rapid repairs). Earned points count everything you destroy and are not reduced by FTL penalties, so a jump never takes back progress or repeats a milestone. Bonus charges stack, even while the starting charge is unused. The sidebar shows the charges and points still needed for the next bonus.

FTL keeps charges and earned progress. Retry resets score and earned points to zero and restores exactly one charge.

## Retained sound and feedback

- **Identification klaxon:** The approved isolated alert plays three times per identification, lasting 4.2 seconds in total. The existing -5 dB default volume is retained.
- **FTL:** The existing original sweep/crack/low-frequency jump effect plays when a jump succeeds. Rejected clicks during recharge do not trigger it.
- **Game Over:** At zero hull, Game Over appears at the radar center, with Retry underneath inside a red-bordered box. Retry restores the entire encounter without restarting Godot.
- **Counters:** The header shows enemy fighters, active Vipers, Raptors and Basestars. From 1.1.0 the left sidebar shows the battle readout (see **Battle readout**).

The DRADIS sweep stays at -20 dB. Contact double beeps, launch whooshes, the FTL effect, fast battery buzz and approved nuclear-warning sequences are unchanged, with no external audio service or runtime dependency.

The identification alert is extracted from the supplied recording, not newly synthesized or asserted to be royalty-free. Pending identifications queue normally; FTL, game over and a higher-priority nuclear warning still interrupt an active alert as before.

## Defense Battery

Click **DEFENSE BATTERY** to fire and click again to stop. A smooth arc of flak curves over the top of the ship-status outline (the ship's left/port side). It sits at least 15 pixels out from the hull and reaches a little past the stern and bow. While firing, the line flickers in shades of yellow and orange with brief bright sparkles, like bursting flak or fire. The colors change along the line, but the line itself never grows or spreads. The rapid 3x gunfire buzz plays while firing.

The battery is a **charge meter**, shown as a percentage on the button and in the sidebar:

- **Firing** drains it quickly: full to empty in 6 seconds.
- **Stopped**, it waits 1 second, then recharges slowly: empty to full in 24 seconds on NORMAL (19.2 on EASY, 31.2 on HARD; 18 before 1.03). It does not have to reach zero before recharging, and stopping partway lets it start refilling from that level.
- **Empty** stops firing. It can fire again once it has recharged to 15%, so it cannot stutter on and off at almost zero.

While firing, the battery shoots at every standard missile that reaches the flak arc. Its kill zone is 0.12 scope radii from the ship, which on screen is a thin band on and just above the arc (missiles cross the arc itself at about 0.06 to 0.10). Each missile in the band is shot at every 0.1 seconds with a 45% chance per shot, so one that reaches the arc while the battery fires is almost always destroyed, shown by a yellow burst at the arc. Before 1.04 the zone was 0.45 scope radii, so missiles burst far up the scope.

Timing tip: missiles take about 15 seconds to reach the ship on Easy (less on Normal and Hard). Start firing just before missiles reach the arc and stop when they are gone, to save charge. AUTO DEFENSE BATTERY starts when a missile is 0.22 scope radii away.

Each missile the battery destroys scores 10 points (times the score multiplier) and counts toward bonus repairs and the Double Missile bonus.

The battery cannot destroy nuclear missiles or Heavy Raiders. FTL stops firing but keeps the current charge; Retry restores a full battery.

## Nuclear threats

Each identified Basestar has exactly one nuclear missile for its lifetime. It launches 18 seconds after identification by default, if the Basestar survives that long.

- **Visibility:** The nuclear missile is larger than an ordinary missile, flashes yellow/red and is labeled NUCLEAR. A prominent flashing warning appears above the radar.
- **Launch warning:** The approved isolated alert plays twice at 1.5x speed, about 1.87 seconds total. Each live launch gets one such warning; simultaneous launches queue rather than overlap.
- **Approach beeps:** After the launch warnings, one beep train follows the nearest incoming nuke. Its interval decreases from 1.2 seconds far away toward 0.15 seconds near impact; there is no repeating launch alarm every six seconds.
- **Movement:** Nuclear missiles move slowly, at 0.055 scope radii per second, compared with 0.12 for conventional enemy missiles. From 1.1.0, each Basestar nuke also gets its own random speed bonus at launch, from 0% to 8% faster (on top of the difficulty speed; Hard is still 1.6x). Easy and Normal spread evenly; on Hard the bonus leans to the top end (the larger of two random picks, about 5.3% on average). The session log records each nuke's bonus. Inspector: **Contacts > Nuclear Threat > Nuke Speed Random Max** (0.08; 0 turns it off) and **Hard Nuke Speed Lean** (on).
- **Damage:** A hit removes 60 hull points by default and may end the game if hull is already damaged.
- **Counters:** A Raptor can intercept it, or FTL can escape it. Vipers and the Defense Battery cannot stop it.

Destroying the launching Basestar does not erase a nuke already in flight. Once a track uses its nuclear weapon, that Basestar cannot launch another; a newly arriving Basestar has its own single allowance.

Intercepting the last nuke, escaping with FTL, impact of the last nuke, or game over clears the nuclear warning/beeps. With several nukes, the cadence follows the closest remaining missile; identification announcements wait until nuclear threats clear.

## Raptors

**LAUNCH RAPTOR** deploys one Raptor from the bottom of the radar. Up to two may be active, with an eight-second launch cooldown. Each Raptor has 7 hit points.

From 1.1.0, LAUNCH RAPTOR also waits 5 seconds after a Raptor lands, and LAUNCH VIPERS waits 3 seconds after a Viper lands. Each landing restarts the pause, so LAUNCH VIPERS unlocks 3 seconds after the last Viper of a group lands. If the launch cooldown is longer, the longer one wins. The button shows its usual READY IN countdown, and Auto Launch waits too. Inspector: **Contacts > Viper Launch > Viper Recovery Seconds** (3) and **Contacts > Raptors > Raptor Recovery Seconds** (5); 0 turns a pause off.

With **AUTO LAUNCH RAPTORS** on and 2 or more nukes on screen, every available Raptor launches at once instead of waiting for the launch cooldown between them. The landing pause still applies, and manual LAUNCH RAPTOR is unchanged. Inspector: **Contacts > Automation > Auto All Raptors Nukes** (2; 0 turns it off).

Raptors move at 0.10 scope radii per second, slower than the Vipers' 0.14. They prioritize nuclear missiles over every offensive task and must physically reach interception distance to destroy one.

When no nuclear threat exists, Raptors approach identified Basestars and fire small green missiles every eight seconds while in range. Each light missile deals half the damage of one main-ship missile; a fresh Basestar therefore takes twelve Raptor-only hits or six main-ship hits, with mixed damage accumulating.

Basestars fire small red flak projectiles back at nearby Raptors. Raptors perform lateral evasive movement and have a 75% evasion chance when a shot reaches them; seven unevaded hits (from flak or Raiders) destroy a Raptor and cost 400 points.

Raptors return after a 70-second sortie. A return frees a launch slot; a loss also frees a slot, but is explicitly announced as a loss.

## Returning flights

Ships return home to refuel and rearm. While returning they flash slowly in a lighter shade of their color and are labeled RTB.

- **Vipers** return to the ship after their 45-second sortie, then leave the radar and free a launch slot. Launch another pair to keep cover up.
- **Raiders** return to their Basestar after 40 seconds and dock, freeing a launch slot. If their Basestar was destroyed, they fly to the nearest surviving one; if none remain, they stay and fight.
- **Raptors** return after their 70-second sortie, as before.

Returning ships fly at 80% speed and are more vulnerable:

- Raiders hunt returning Vipers nearby. Each attack has a 50% chance to destroy a returning Viper, with a 1.5-second gap between attacks. Vipers on active patrol can also be shot down; they take 2 hits and dodge 20% (see Fighter losses). The sidebar counts VIPERS LOST.
- Vipers chase returning Raiders anywhere on the scope and prefer them over active Raiders.
- Returning Raptors evade Basestar flak only 35% of the time instead of 75%.

## Heavy Raider hacking alert

A hacking Heavy Raider flashes rapidly (6 times per second) in its red. A flashing, boxed side alert shows HEAVY RAIDER HACKING SHIP, PENETRATING DEFENSES and **BREACH IN n.n s** as a live countdown. After the breach it switches to COMPUTERS BREACHED with the drain rate; if a second Heavy Raider is still hacking, it also shows NEXT BREACH IN n.n s. Each Heavy Raider's label also shows its hacking seconds.

Ship missiles fire at parked Heavy Raiders before Basestars whenever they reload, as in v2.

## Score

The score starts as a single 0 and quickly counts up to each new total instead of showing leading zeros. FTL penalties count down the same way; Retry snaps back to 0.

## Retained mechanics

- **Own ship:** Automatically fires one missile every six seconds at parked Heavy Raiders first, otherwise at identified Basestars. Six full-strength hits destroy a fresh capital ship.
- **Basestars:** Stationary, farther out, four active Raiders each and eight Raiders globally. Two at once in waves 1-2, up to four from wave 5.
- **Distant contacts:** First unidentified, then hostile Basestars after three seconds.
- **Hull status:** HULL on the right of the approved ship outline; green through lighter green, orange and red.
- **Repair:** Begins after 20 seconds without a hit, restoring 1% every eight seconds; never revives a destroyed ship.
- **FTL status:** Starts at 100%, resets to 1% after jumping, recharges over 45 seconds, with eight seconds of clear space.
- **Vipers:** Launch in pairs, six active maximum, four-second launch cooldown. They engage central Raiders, Heavy Raiders and conventional missiles, never capital ships or nukes.

The ring graphics, dome animation, contact scaling and approved ship-outline artwork are preserved. Console positioning and the status-panel fit have been adjusted to leave room for the new structure.

## Inspector tuning

Stop the game, select **DradisConsole > CenterContainer > Dome > Contacts**, edit the desired setting, save the scene, and run again. New controls are grouped for easy tuning.

| Group | Setting | Default |
|---|---|---:|
| Explosions | Explosion Effects Enabled / Screen Flash Enabled | On / On |
| Explosions | Missile Flash Seconds / Size | 0.3 / 1.0 |
| Explosions | Nuke Explosion Seconds / Size | 0.8 / 1.0 |
| Explosions | Nuke Screen Flash Strength / Nuke Impact Flash Strength | 0.28 / 0.42 |
| Explosions | Screen Flash Seconds | 0.35 |
| Explosions | Missile Boom Volume Db / Nuke Boom Volume Db | -15 / -9 |
| Explosions | Boom Min Gap Seconds | 0.12 |
| Nuclear Interception | Nuclear Hit Points / Raptor Nuke Hit Interval | 6 / 0.7 s |
| Nuclear Interception | Raider Viper Hits / Raider Viper Hit Interval | 2 / 0.5 s (1 = the old one-pass kill) |
| Identification and Ship Weapons | Ship Missiles Target Nukes / Ship Nuke Target Fraction | On / 0.75 |
| Identification and Ship Weapons | Own Missile Interval / Basestar Hits To Destroy | 8 s / 11 |
| Score and Rapid Repair | Battery Kill Points | 10 |
| Bonus Features | Double Missile Bonus | On |
| Bonus Features | Easy / Normal / Hard Double Missile Points | 15,000 / 17,500 / 20,000 |
| Bonus Features | Bonus Chime Volume Db | -14 |
| EMP Defense | Emp Enabled / Points Per Charge / Max Charges | On / 5,000 / 2 |
| EMP Defense | Emp Shimmer Seconds / Emp Zap Volume Db | 1.0 / -10 |
| Rapid Repair Feedback | Repair Sound Enabled / Repair Sound Volume Db | On / -16 |
| Rapid Repair Feedback | Repair Flash Enabled / Repair Flash Hz | On / 2 |
| Viper Squadrons | Viper Squadrons Enabled | On |
| Viper Squadrons | Squadron Join / Split Distance | 0.075 / 0.06 |
| Viper Squadrons | Squadrons Split To Engage / Max Vipers Per Tough Target | On / 2 |
| Viper Squadrons | Vipers On Resurrection Ship | 1 |
| FTL | Ftl Offline On Breach / Ftl Breach Recharge Seconds | On / 45 |
| Viper Squadrons | Squadron Spread Penalty / Formation Spacing | 3 / 0.02 |
| Missile Visibility | Enemy Missile Pulse / Hz / Min | On / 2 / 0.35 |
| EMP Defense | Emp Delay After Firewall | 2.0 |
| (top of Contacts) | Show Full Tags | Off |
| Automation | Auto Min Engage Seconds | 0.5 |
| Difficulty | Difficulty | Normal (the gear panel sets this) |
| Difficulty | Easy / Hard Toughness | 0.67 / 1.34 |
| Difficulty | Easy / Hard Attack Rate | 0.75 / 1.3 |
| Difficulty | Easy / Hard Damage | 0.75 / 1.25 |
| Difficulty | Easy / Hard Hack Speed | 0.7 / 1.3 |
| Difficulty | Easy / Hard Wave Length | 1.25 / 0.8 |
| Difficulty | Easy / Hard Score Multiplier | 0.75 / 1.5 |
| Automation | Auto Defense Battery / Auto Firewall | Off (the gear panel sets these) |
| Automation | Auto Score Penalty | 0.10 per option |
| Score and Rapid Repair | Fighter Points | 100 |
| Score and Rapid Repair | Nuclear Points | 500 |
| Score and Rapid Repair | Basestar Points | 1,000 |
| Score and Rapid Repair | Heavy Raider Points | 300 |
| Score and Rapid Repair | Ftl Score Cost | 3,000 |
| Score and Rapid Repair | Bonus Repair Points | 10,000 earned (first bonus) |
| Score and Rapid Repair | Second Bonus Points | 25,000 earned |
| Score and Rapid Repair | Third Bonus Points | 50,000 earned |
| Score and Rapid Repair | Later Bonus Step | every 50,000 after that |
| Waves | Waves Enabled | on |
| Waves | Wave Seconds | 120 |
| Waves | Wave Max Basestars | 4 |
| Waves | Extra Basestar Every Waves | 2 |
| Waves | Wave Interval Step | 0.1 (10% faster per wave) |
| Waves | Wave Interval Floor | 0.6 |
| Waves | Extra Heavy From Wave | 4 |
| Waves | Wave Max Heavy Raiders | 3 |
| Defined Waves | Defined Waves | on (off = 1.1.1 timer waves) |
| Defined Waves | Wave Set Size / Wave Names | 5 / PROBE, STRIKE, ASSAULT, PRESSURE, MAJOR ENGAGEMENT |
| Defined Waves | Easy / Normal / Hard Wave Force | 2,2,2,2,2 / 2,3,2,3,3 / 2,3,3,3,3 |
| Defined Waves | Wave Onscreen Basestars / Wave Heavy Caps | 2,2,3,3,4 / 1,2,2,2,3 |
| Defined Waves | Wave Launch Factors | 1.0, 0.95, 0.9, 0.85, 0.8 |
| Defined Waves | Major Resurrection / Delay | on / 20 s |
| Defined Waves | Wave Safety Seconds | 300 |
| Defined Waves | Easy / Normal / Hard Rest Seconds | 10 / 7 / 5 |
| Defined Waves | Wave Clear Points / Wave Hull Points / Set Clear Points | 500 / 10 / 2500 |
| Defined Waves | Set Score Step / Cap | 0.25 / 3.0 |
| Defined Waves | Traits Enabled / Set Modifiers Enabled | on / on |
| Defined Waves | Set End Round | Protect the fleet (or Bonus sweep, None) |
| Defined Waves | Bonus Sweep: Raiders / Group / Gap / Speed / Perfect Points | 12 / 3 / 3 s / 0.10 / 3000 |
| Defined Waves | Ftl Rest Jump Points / Rest Jump Safe Seconds | 250 / 2 |
| Defined Waves | Systems Bonuses | all eight (remove a name to turn it off) |
| Defined Waves | Bonus Start Wave / Bonus Wave Chance | 6 / 0.4 |
| Defined Waves | Bonus Low / Medium / High Tier | EMP, SPEED / REPAIR, RAPTOR, RAPID FIRE / VIPERS, AUTO BATTERY, STEALTH (repeat a name to make it likelier) |
| Defined Waves | Bonus Low / Medium / High Tier Set | 2 / 3 / 5 |
| Defined Waves | Bonus Lower Tier Chance | 0.3333 |
| Defined Waves | Hard Bonus Set Delay / Hard Bonus Chance Factor | 1 / 0.5 |
| Defined Waves | Show No Systems Bonus | on |
| Defined Waves | Bonus Repair Cap / Extra Vipers / Extra Raptors / Speed / Fire | 3 / 2 / 1 / 1.15 / 0.75 |
| Defined Waves | Wave Cues Enabled / Action Stations / All Clear Volume Db | on / -14 / -14 |
| Defined Waves | Rest Tally Offset / Rest Tally Border Width | 0.22 / 3 px |
| Protect the Fleet | Protect Civilians Min / Max | 2 / 4 |
| Protect the Fleet | Protect First Raiders / Raiders Step / Raiders Cap | 4 / 2 / 12 |
| Protect the Fleet | Easy / Hard Protect Raider Change | -2 / +2 |
| Protect the Fleet | Easy / Normal / Hard Civilian Kill Seconds | 26 / 20 / 14 |
| Protect the Fleet | Protect Kill Time Step / Kill Time Floor (1.2.3) | 0.1 / 10 s |
| Protect the Fleet | Protect Round Seconds | 60 |
| Protect the Fleet | Protect Ship Points / Full Fleet Points | 500 / 1000 |
| Protect the Fleet | Protect Raider Speed / Attack Range / Group Size / Group Gap | 0.07 / 0.07 / 3 / 1.0 s (1.2.3; was 2 / 1.5 s) |
| Protect the Fleet | Protect Raider Viper Hits / Hits Step / Hits Cap (1.2.3) | 4 / 1 / 6 |
| Protect the Fleet | Protect Return Fire Chance (1.2.3; 0 = off) | 0.1667 |
| Protect the Fleet | Protect Allow Ftl | off |
| Protect the Fleet | Civilian Color / Damaged Color / Critical Percent / Blink Hz | blue (0.32, 0.58, 1.0) / grey-blue (0.28, 0.32, 0.46) / 25 / 3 |
| Ship Sizes | Civilian Icon Scale / Civilian Capital Icon Scale | 1.6 / 2.1 |
| Resurrection Ship | Resurrection Enabled | on |
| Resurrection Ship | Resurrection First Wave | 2 |
| Resurrection Ship | Resurrection Check Seconds / Resurrection Spawn Chance | 20 / 0.25 |
| Resurrection Ship | Resurrection Chance Step / Max Chance | 0.05 per wave / 0.6 |
| Resurrection Ship | Resurrection Cooldown Seconds | 90 |
| Resurrection Ship | Resurrection Cooldown Step / Min Cooldown | 10 s per wave / 40 s |
| Resurrection Ship | Resurrection Hit Points | 10 |
| Resurrection Ship | Resurrection Points | 2,500 |
| Resurrection Ship | Resurrection Barrage Missiles / Spacing / Interval | 3 / 1 s / 8 s |
| Resurrection Ship | Resurrection First Barrage Delay | 3 s |
| Resurrection Ship | Resurrection Missile Spread | 0.6 |
| Resurrection Ship | Resurrection Missile Damage | 5 hull |
| Resurrection Ship | Resurrection Speed | 0.03 (about a minute to cross) |
| Resurrection Ship | Resurrection Lane | 0.05 to 0.22 above center |
| Firewall | Firewall Enabled | on |
| Firewall | Firewall Slow Factor | 0.25 (hack at quarter speed) |
| Firewall | Firewall Seconds | 4 (full to empty) |
| Firewall | Firewall Recharge Seconds | 8 (empty to full) |
| Firewall | Firewall Recharge Delay | 0.5 seconds |
| Firewall | Firewall Restart Percent | 25 |
| Firewall | Firewall Volume Db | -12 |
| Fighter Losses | Fighter Losses Enabled | on |
| Fighter Losses | Viper Hit Points / Raptor Hit Points | 2 / 7 |
| Fighter Losses | Viper Evasion Chance | 0.2 (Raptor Evasion Chance under Raptors stays 0.75) |
| Fighter Losses | Raider Hit Chance | 0.5 |
| Fighter Losses | Viper Loss Points / Raptor Loss Points | 200 / 400 |
| DradisConsole > ShipStatus | Ftl Center / Hull Center | 0.18 / 0.855 |
| DradisConsole > ShipStatus | Defense Gap Pixels / Defense Arc Projection | 12 / 3 (arc clears the hull by 15 px) |
| DradisConsole > ShipStatus | Defense Arc Overhang / Defense Arc Width | 8 px / 3 px |
| DradisConsole > ShipStatus | Flak Flicker Hz / Flak Sparkle Amount | 12 / 0.12 |
| DradisConsole > ShipStatus | Flak Yellow / Orange / Deep / Sparkle | fire colors |
| DradisConsole > ShipStatus > Intrusion Detection | Box Size / Stripe Width / Flash Hz | 150 x 64 / 9 / 3 |
| Resurrection Ship | Viper Resurrection Damage / Hit Interval | 0.5 / 2 seconds |
| Resurrection Ship | Resurrection Alert Volume Db / Speed | -5 / 0.8x |
| Contacts | Label Font Size | 16 (capital ships +2) |
| Contacts | Label Outline Size / Color | 4 / black |
| Contacts | Label Brighten | 0.15 |
| Contacts | Icon Size | 1.3 |
| Contacts | Max Contacts | 20 |
| DradisConsole > Display | Fullscreen Key Enabled | on |
| DradisConsole > High Scores | High Score File / Slots | user://dradis_high_scores.json / 10 |
| Score and Rapid Repair | Rapid Repair Percent | 25 |
| Score and Rapid Repair | Rapid Repair Seconds | 5 |
| Identification and Ship Weapons | Klaxon Volume Db | -5 |
| Ship Defense | Prox Burst Seconds | 6 (full to empty while firing) |
| Ship Defense | Battery Recharge Seconds | 24 (empty to full, Normal) |
| Difficulty | Easy / Hard Battery Recharge | 0.8 / 1.3 (19.2 s / 31.2 s) |
| Automation | Auto Launch Vipers / Auto Launch Raptors / Auto Ftl | Off (the gear panel sets these) |
| Automation | Auto Ftl Hull Percent | 10 |
| FTL Flash | Ftl Flash Enabled / Ftl Flash Seconds / Ftl Screen Flash Strength | On / 1.1 / 0.35 |
| DradisConsole > Display | Fit Window To Screen / Window Screen Fraction | On / 0.85 |
| Ship Defense | Battery Recharge Delay | 1 second |
| Ship Defense | Battery Restart Percent | 15 |
| Returning Flights | Raider Sortie Seconds | 40 |
| Returning Flights | Returning Speed Factor | 0.8 |
| Returning Flights | Returning Lighten | 0.45 |
| Returning Flights | Returning Flash Hz | 0.8 |
| Returning Flights | Raider Attack Range | 0.30 |
| Returning Flights | Returning Viper Loss Chance | 0.5 |
| Returning Flights | Raider Attack Cooldown | 1.5 seconds |
| Returning Flights | Returning Raptor Evasion Chance | 0.35 |
| Returning Flights | Hacking Flash Hz | 6 |
| DradisConsole > Build | Development Build | off (tick for the F1 tuning panel) |
| DradisConsole > Build | Score Count Speed | 6 |
| Ship Defense | Battery Volume Db | -9 |
| Ship Defense | Battery Sound Speed | 3.0x |
| FTL | Jump Volume Db | -8 |
| Nuclear Threat | Nuclear Launch Delay | 18 seconds after ID |
| Nuclear Threat | Nuclear Speed | 0.058 |
| Nuclear Threat | Nuclear Damage | 60 hull |
| Nuclear Threat | Nuclear Alert Volume Db | -7 |
| Nuclear Threat | Nuclear Alert Speed | 1.5x |
| Nuclear Threat | Nuclear Beep Volume Db | -12 |
| Nuclear Threat | Nuclear Beep Far / Near Seconds | 1.2 / 0.15 |
| Raptors | Max Raptors | 2 |
| Raptors | Raptor Speed | 0.10 |
| Raptors | Raptor Launch Cooldown | 8 seconds |
| Raptors | Raptor Sortie Seconds | 70 |
| Raptors | Raptor Fire Interval | 8 seconds |
| Raptors | Raptor Missile Damage | 0.5 capital hit points |
| Raptors | Raptor Evasion Chance | 0.75 |
| Raptors | Basestar Flak Interval | 4 seconds |
| Raptors | Basestar Flak Range | 0.85 scope radii |
| Heavy Raiders | Heavy Raiders Enabled | on |
| Heavy Raiders | Max Heavy Raiders | 2 (waves can raise it to 3) |
| Heavy Raiders | Max Heavy Per Basestar | 1 |
| Heavy Raiders | Heavy Launch Interval | 28 seconds |
| Heavy Raiders | Heavy Raider Speed | 0.075 |
| Heavy Raiders | Hacking Seconds | 6 |
| Heavy Raiders | Hack Drain Percent Per Second | 2.0 |
| Heavy Raiders | Hacking Range | 0.30 |
| Heavy Raiders | Hack Park Offset | (0.16, 0.10) |
| Heavy Raiders | Heavy Raider Hit Points | 5 |
| Heavy Raiders | Ship Missile Heavy Range | 0.15 |
| Heavy Raiders | Ship Missiles Target Hacking (1.2.3) | on |
| Ship Defense | Missile Damage | 10 hull |
| Ship Defense | Prox Defense Radius (kill zone at the arc) | 0.12 |
| Ship Defense | Auto Battery Lead Radius | 0.22 |
| Ship Defense | Prox Success Chance | 0.45 per shot |
| Ship Defense | Battery Shot Interval | 0.1 seconds |
| Difficulty | Easy / Normal / Hard Missile Speed | 1.0 / 1.1 / 1.6 |
| Difficulty | Easy / Normal / Hard Nuke Speed | 1.0 / 1.1 / 1.6 |
| Automation | Auto Rapid Repair / Auto Repair Hull Percent | off / 50 |
| Explosions | Craft Explosions Enabled | on |
| Explosions | Craft Explosion Seconds / Size / Heavy Explosion Scale | 0.4 / 1.0 / 1.4 |
| Explosions | Enemy Craft Color / Own Craft Color | orange / green-white |
| Explosions | Craft Boom Volume Db / Heavy Boom Volume Db | -19 / -16 |
| Explosions | Capital Explosion Seconds / Size | 1.4 / 1.0 |
| Explosions | Capital Screen Flash Strength / Capital Boom Volume Db | 0.32 / -7 |
| Battlefield | Own Ship Position | (0, -1.05, -0.15) |
| Ship Defense | Missile Impact Radius | 0.004 |
| Ship Defense | Impact Volume Db | -10 |
| Ship Defense | Hit Flash Seconds | 0.45 |
| Keep Play In Wedge | Keep Play In Wedge / Wedge Margin (1.2.4) | On / 0.06 |

On **Dome** (1.2.4):

| Group | Setting | Default |
|---|---|---:|
| Ring Hinge | Ring Horizontal Hinge Front Back / Ring View Elevation Deg / Ring Hinge Direction | On / 30 / -1 |
| Ring Trail | Ring Trail Enabled / Seconds / Copies | On / 0.20 / 24 |
| Ring Trail | Ring Trail Strength / Ring Trail Glow Scale | 0.30 / 0.50 |
| Ripples | Ripples Match Ring Plane / Ripple Max Radius | On / 320 (1.2.3: off / 340) |
| Scanlines (1.2.6) | Scanlines Inside Scope | On in the scene (script default off = 1.2.5 scanlines over the whole dome square) |

On **ConsoleFrame** (1.2.4):

| Group | Setting | Default |
|---|---|---:|
| Scope Frame | Scope Frame Visible / Corner Panels Visible | On / On |
| Scope Frame | Scope Border / Tick / Tick Major / Panel / Panel Dim / Panel Fill Color | the mockup colours |
| Panel Animation | Panel Animation Enabled / Panel Step Seconds | On / 3 s |
| Panel Animation | Panel Step Amount / Panel Flicker Amount | 1 / 0.3 |
| Console Layout 2 (1.2.5) | Console Layout V2 | On in the scene (script default off = 1.2.4 layout) |
| Console Layout 2 (1.2.5) | Hull Low Percent / Live Readouts / Nav Data Panel | 30 / On / On |

On **Contacts** (1.2.5, Protect the fleet; the scene turns the four switches on, script defaults are the 1.2.4 round):

| Setting | Default |
|---|---:|
| Civilian Size Toughness / Large / Medium / Small Toughness | On / 2.0 / 1.2 / 1.0 |
| Civilian Evasion / Small / Medium Evade Speed | On / 0.035 / 0.02 |
| Civilian Small / Medium Evade Damage | 1.0 / 1.0 (no cut) |
| Civilian Evade Bias Home / Evade Floor Y | 0.5 / -0.5 |
| Protect Patrol Vipers / Protect Jump In Hold | 1 / 2.0 s |
| Protect Damage Stack Cap | 0 (no limit) |

## Suggested test

1. Extract this build to a new folder, import it in Godot 4.7 and run it once. Open Settings: DRADIS BATTLE CONSOLE 1.2.6 should be at the bottom.
1a. Watch the scope for a minute. The rings should leave a soft trail and stay quiet, no brighter than 1.2.3. The flat ring should turn about the front-to-back axis, and the pulse rings should lie on its plane. The outline, ticks and corner panels should sit clear of the ship and the dome, and only a few panel bars should change, slowly. Try the window at 1600x900 and full screen.
1b. Check the 1.2.5 layout: the VIPERS, RAPTOR, FTL and DEFENSES lights should dim when their bottom buttons cannot be used and brighten when they can. The alert box should read ALERT STATUS until a Heavy Raider launches. NAV DATA should change after an FTL jump and when a new battle starts. Let the hull fall below 30%: the HULL gauge should turn red.
1c. Check 1.2.6: the corner panels, top tabs and NAV DATA box should no longer shimmer, while the scope keeps its slow rolling scanlines. When a Heavy Raider launches, the alert box outline should stay in the panel colour with amber text; while it hacks the outline should blink red, and after a breach it should be red.
2. Start on Normal. Basestars should take noticeably longer to destroy (11 hits), a Viper should need two passes at a Raider, and the ship should fire at nukes only late in their flight. The right sidebar should read WAVE 1 and SET 1 | BASESTARS LEFT 2. Destroy both Basestars: Raiders should jump away, WAVE 1 CLEARED should appear with a tally panel in the lower scope, and a soft two-note cue should play.
3. Watch the rest: about 7 seconds, with WAVE 2 INBOUND and three low horn pulses for the last 3 seconds. Then WAVE 2 | STRIKE | 3 BASESTARS.
4. Try FTL JUMP during a rest: no points should be taken, and the next wave should start after a short pause.
5. Play to wave 5 (Major engagement). The Resurrection Ship should arrive about 20 seconds in. After it and the Basestars are destroyed, SET 1 COMPLETE | SCORE x1.25 should show, with a Systems Bonus from the low tier (waves 1 to 4 should each have shown NO SYSTEMS BONUS), then PROTECT THE FLEET.
6. In Protect the fleet, 2 to 4 blue civilian ships should appear with 4 Raiders, arriving 3 then 1, each dim for 2 seconds before it attacks. One Viper should already be with the fleet. Small and medium ships should move away from Raiders and stay inside the outline; the large ship should hold and last longer. Launch Vipers (up to 4 in the round). Each Raider should take about four Viper passes, and now and then a Viper should be lost with VIPER LOST TO RAIDER RETURN FIRE. In later sets the Raiders should take more hits and the civilian ships should fall faster. Raptors, the battery and FTL should read VIPERS ONLY or HELD. Damaged ships should dim and blink when critical. The tally should show the ships saved, hull and bonus. Wave 6 should announce NEW CYLON TACTIC: QUICKER LAUNCHES.
7. Check that the wave tally border is clearly thicker, and that each Systems Bonus line makes sense (for example EXTRA VIPER SQUADRON should show VIPERS ACTIVE 0 / 8). With AUTO DEFENSE BATTERY on, FREE AUTO BATTERY should never be offered.
8. When a Heavy Raider starts hacking, the ship should fire missiles at it (unless a nuke is in the last quarter of its flight). When a Heavy Raider launches, the amber box left of the ship outline should show HEAVY RAIDER APPROACHING / PREPARE FIREWALL DEFENSE centred in it. When it starts hacking the box should stay exactly the same size and place.
9. Try Easy (10-second rests, no traits in the first set) and Hard (5-second rests, traits from wave 2).
10. Export the Mac DMG and the Windows x64 and arm64 builds as before and check that they run.

## Known limits

The source project is a complete full build of the editable project, not a signed Mac application. Automated engine and rendered-layout tests run on Godot 4.4.1 Linux; Godot 4.7/macOS speaker output, display scaling, touch use of the Settings panel, how Easy and Hard feel, and how loud the new booms are, how strong the screen flash feels, how the slower battery, auto launch and auto FTL play, the startup window size on real Mac and Windows high-resolution screens, how loud the new fighter and capital-ship booms feel, and how the faster missiles and nukes and the battery at the arc play still need field testing. The Windows arm64 freezes reported from 2026-10-04 to 2026-10-06 happened under the OpenGL-on-Direct3D 12 layer. 1.09 switches Qualcomm GPUs to ANGLE; whether that stops the freezes is not yet confirmed on the Surface Pro. How the 1.1.0 landing pauses, the Raider focus fire on the Stealth Viper, the random nuke speed and the all-Raptor auto launch play in real battles also needs field testing. How the Stealth Viper plays (speed, timing, how often it is offered) and how its ready chime sounds also need field testing. How the repair tone, the EMP zap and the bonus chime sound, how often an EMP is available in real play, whether the missile pulse is comfortable, how the split and rejoining Vipers play, whether the halves of the split FIREWALL | EMP button are easy to tap, how often the Double Missile bonus is reached in real play, and Hard nuke speed (still 1.6x, under review after real play) also need field testing. The difficulty and auto values are starting points for play-testing and can be changed in the Inspector.

**All-auto play and FTL offline (1.08):** in 1.07 a battle with every auto option on could run without end on Normal, mostly because AUTO FTL escaped each low-hull moment. In 1.08 the hull usually falls that low during a Heavy Raider breach, when FTL is now offline, so AUTO FTL cannot save the ship. In computer runs with every auto option on (no manual EMP): Easy still lasted the full 60 minutes; Normal ended after about 8 to 10 minutes (wave 6); Hard after about 2 to 3 minutes. A player who uses the EMP or Vipers against Heavy Raiders lasts much longer; how this feels in real play still needs testing. A shorter rebuild time after a breach does not change all-auto results, because the losses happen while FTL is offline. Switching **Contacts > FTL > Ftl Offline On Breach** off restores the 1.07 behavior.

To adjust only the background DRADIS loudness, select the top-level DradisConsole node and change **Audio Mix > Sweep Volume Db**, now -20 dB. Foreground alerts retain their separate volume controls.

Heavy Raider timing, drain and launch rate, wave pacing, Firewall strength and charge times, fighter toughness and loss penalties, and Resurrection Ship speed, frequency and strength are starting values that need play-testing. Return timing and vulnerability values are starting points for play-testing. Capital-ship names are kept apart, but names of small craft flying close together can still overlap.
