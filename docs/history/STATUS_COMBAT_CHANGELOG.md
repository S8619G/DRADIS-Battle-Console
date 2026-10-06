# BSG DRADIS Status and Combat Test

Functional test iteration dated 2026-10-01, based on the complete Ship Defense Test. This separate copy keeps the in-engine name BSG DRADIS.

## Changes

- **Ship panel:** Approved outline, derived interior fill, damage color progression, right-side HULL and left-side FTL percentages.
- **Repair:** Delayed one-percent ticks, full-hull clamp and no resurrection after destruction.
- **Fighter motion:** Lower speeds, bounded acceleration, central defensive targeting and stronger target retention.
- **Capital identification:** Distant arrivals remain unknown for three seconds, then identify as stationary enemy Basestars with a short queued klaxon.
- **Automatic ship weapons:** Friendly missiles target identified Basestars, travel physically, deal one hit each and destroy the default target after six hits.
- **Launch limits:** Four active Raiders per Basestar, eight globally, with queued-launch safeguards.
- **Cleanup:** FTL, restart, game over and capital destruction handle the new weapons and audio queues.

## Preserved

The dome script, ring settings, icon shapes, tuning panel, original assets, beep/whoosh synthesis, sweep loader and repaired loop endpoint are unchanged. The center container alone shifts the radar upward for the new status panel; its size and animation remain intact.
