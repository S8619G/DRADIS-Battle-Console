# BSG DRADIS Waves & High Scores Test

Release identity: Waves & High Scores Test, 2026-10-02. This separate, complete project builds on the Returning Flights Test; its Godot display name remains BSG DRADIS.

## Functional changes

- Default window is 1600 x 900 (was 1280 x 720); the 1920 x 1080 layout scales to fit. F11 toggles full screen, Esc leaves it (DradisConsole > Display > Fullscreen Key Enabled).
- Contact icons are 30% larger (Icon Size 1.3). Contact names use a 16-pixel font (capital ships 18), drawn slightly brighter than the icon with a thin dark outline (Label Font Size, Label Brighten, Label Outline Size/Color).
- Capital ships are placed in two rows, checked so icons and names never overlap. Missile arrows gain a smoothed edge. 2D MSAA is left off because the Compatibility renderer reports it unsupported.
- Threat waves every 2 minutes: Basestar limit 2, 3 from wave 3, 4 from wave 5; Raider and missile launch intervals shorten 10% per wave to 60%; a third Heavy Raider is allowed from wave 4. Sidebar THREAT WAVE block with next-wave countdown; FTL keeps the wave, Retry returns to wave 1. Max Contacts raised from 14 to 20.
- Bonus rapid repairs at 10,000, 25,000 and 50,000 earned points, then every 50,000 (was every 10,000).
- New Resurrection Ship from wave 2: rare (25% chance every 20 s, one at a time, 90 s quiet period after destruction or FTL), stationary, 16 hit points, fires a 4-missile barrage every 14 s until destroyed, worth 2,500 points. Damaged by ship missiles (alternating with Basestars), Raptors (preferred target) and Vipers (half a hit every 2 s each); the Defense Battery cannot damage it but can shoot down its missiles. Arrival plays the approved alert twice at 0.8x; it never overlaps the klaxon, and nuclear warnings take priority. Sidebar shows strength and next-barrage countdown.
- Top-10 arcade high score board on Game Over with three upper-case initials (mouse arrows or keyboard). Saved to user://dradis_high_scores.json with a verified temporary-file replace; an unreadable file is kept as a backup. Retry before ENTER still saves under the initials shown.

## Preserved behavior

Dome script, Dome node and ring settings, approved artwork, icons, prior audio assets and sound generators, -20 dB DRADIS, alert sequences, Heavy Raider hack timing and drain, missile resolution, F1 tuning panel and the Development Build switch are unchanged.
