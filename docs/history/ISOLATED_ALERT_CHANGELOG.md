# BSG DRADIS Isolated Alert Test

Functional alert and defense-feedback iteration dated 2026-10-01, based on the complete Raptor and Defense Test. The game name remains BSG DRADIS and the previous working copy is retained.

## Changes

The identification klaxon now uses the approved isolated alert WAV, played as three exact 1.4-second cycles in a single finite 4.2-second stream. This avoids an infinite loop and preserves the established queued-identification behavior.

The current -5 dB identification volume is retained. Nuclear launches use two cycles of the same alert at 1.5x speed, followed by distance-dependent beeps that accelerate toward the ship; multiple threats use a single nearest-threat beep train.

The defense wheel and radial tracers are replaced by a yellow line following the left part of the approved ship-status outline. Battery sound plays at 3x speed for a rapid buzz, with the existing six-second burst and 18-second cooldown preserved.

The background DRADIS sweep is reduced to -20 dB. FTL, interception, impact, game over and Retry clear the appropriate warning/audio state.

## Preserved

All scene files, ambient ring graphics, approved ship art, other combat mechanics, FTL sound, contact beep and launch whoosh remain unchanged. The approved single-cycle WAV is included byte-for-byte; this is extracted user-supplied audio, not a newly generated original effect.
