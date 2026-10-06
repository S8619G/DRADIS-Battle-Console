# BSG DRADIS Audio Test Changes

Test package identity: **Audio Test 2026-10-01**. The Godot project display name remains **BSG DRADIS**, and no application version or visual setting is changed.

## Audio correction

`scripts/DradisConsole.gd` now computes the loop endpoint from the decoded PCM byte count, sample width, and channel count. It prints the endpoint with the existing audio diagnostic message; for the included recording, the endpoint is 191,978 frames.

Previously the loop endpoint was zero, producing an empty loop. Godot defines runtime loop points in sample units, not as a zero-means-entire-file sentinel ([Godot AudioStreamWAV documentation](https://docs.godotengine.org/en/4.4/classes/class_audiostreamwav.html)).

## Preserved baseline

All other original files are preserved byte-for-byte, including graphics scripts, scenes, project settings, audio assets, reference files, and the historical README. Two new documentation files explain this test copy.

## Not addressed

Native Mac and Windows playback, standalone exports, perfect audio/animation phase synchronization, PCM parser hardening, audio rights clearance, and additional gameplay remain outside this repair. This is a field-test candidate, not a public release.
