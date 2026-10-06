# BSG DRADIS Console Game Test

Release identity: Console Game Test, 2026-10-01. This separate, complete project builds on the delivered Isolated Alert Test; its Godot display name remains BSG DRADIS.

## Functional changes

- Defense now uses a six-second shared reserve, pausable and resumable. Only exhaustion starts the 18-second cooldown.
- The yellow defense contour follows the upper side of the horizontal ship outline, separated from the hull by a configurable 12-pixel gap.
- Raider destruction earns 100 points; nuclear interception earns 500; Basestar destruction earns 1,000. Each contact scores only once.
- Successful FTL jumps deduct 250 points, with a zero floor. Failed requests and contact cleanup do not alter score.
- HAIL is replaced by one-use Rapid Repair: up to 25 percentage points over five seconds, capped at full hull and never reviving a defeated ship.
- Retry resets score and restores the battery and repair charge. FTL retains remaining reserve, cooldown and repair usage.
- A structured magenta console frame groups contact counts and score above, resource and point-value information beside the scope, and five aligned controls below.
- Game Over shows final score. F1 tuning remains available but starts hidden.

## Preserved behavior

The dome script and its scene settings, original ship artwork, contact-icon definitions, contact speeds and scaling, weapons and population caps are preserved. All existing audio assets and sound generators are unchanged; ambient DRADIS remains -20 dB.

Identification retains three approved alert cycles. Nuclear launch retains two accelerated cycles followed by approaching beeps, and proximity defense retains its fast buzz.
