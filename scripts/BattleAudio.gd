extends RefCounted
## Deterministic original PCM effects. No programme audio or external runtime.

static func make_hull_impact() -> AudioStreamWAV:
	# Short original low-frequency thump with a soft, filtered debris tail.
	var rate := 48000
	var frames := 21600
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 30841
	var phase := 0.0
	var filtered := 0.0
	for i in range(frames):
		var t := float(i) / rate
		phase += TAU * lerpf(105.0, 42.0, minf(1.0, t / 0.30)) / rate
		filtered = lerpf(filtered, rng.randf_range(-1.0, 1.0), 0.12)
		var envelope := minf(1.0, t / 0.003) * exp(-t * 10.0) * minf(1.0, (0.45 - t) / 0.035)
		var sample := envelope * (0.58 * sin(phase) + 0.26 * filtered)
		data.encode_s16(i * 2, int(clampf(sample, -0.85, 0.85) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.mix_rate = rate
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = data
	return stream

static func make_approach_beep() -> AudioStreamWAV:
	var rate := 48000
	var frames := 3072  # 64 ms; remains distinct at the fastest default cadence.
	var data := PackedByteArray()
	data.resize(frames * 2)
	for i in range(frames):
		var t := float(i) / rate
		var envelope := clampf(minf(t / 0.004, (0.064 - t) / 0.010), 0.0, 1.0)
		var sample := envelope * (0.32 * sin(TAU * 1500.0 * t) + 0.08 * sin(TAU * 2250.0 * t))
		data.encode_s16(i * 2, int(sample * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.mix_rate = rate
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = data
	return stream

static func synth(kind: String) -> AudioStreamWAV:
	var duration := 1.6
	if kind == "battery":
		duration = 0.4
	elif kind == "jump":
		duration = 1.8
	elif kind == "nuclear":
		duration = 1.4
	var rate := 48000
	var frames := int(duration * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 73916
	var phase := 0.0
	var filtered := 0.0
	for index in range(frames):
		var t := float(index) / rate
		var noise := rng.randf_range(-1.0, 1.0)
		filtered = lerpf(filtered, noise, 0.16)
		var sample := 0.0
		match kind:
			"battery":
				# Six percussive rounds per seamless 0.4-second burst.
				var local := fmod(t, 1.0 / 15.0)
				var envelope := minf(1.0, local / 0.0015) * exp(-local * 85.0)
				sample = envelope * (noise * 0.45 + sin(TAU * 115.0 * local) * 0.28)
			"jump":
				var envelope := minf(t / 0.18, 1.0) * pow(maxf(0.0, 1.0 - t / duration), 1.5)
				phase += TAU * lerpf(850.0, 42.0, pow(t / duration, 0.35)) / rate
				var crack := exp(-absf(t - 0.28) * 35.0)
				sample = envelope * (0.35 * sin(phase) + 0.35 * filtered) + crack * noise * 0.28
			"nuclear":
				var local := fmod(t, 0.35)
				var envelope := clampf(minf(local / 0.015, (0.30 - local) / 0.04), 0.0, 1.0)
				var frequency := 660.0 if int(t / 0.35) % 2 == 0 else 990.0
				phase += TAU * frequency / rate
				sample = envelope * (0.34 * sin(phase) + 0.15 * sin(phase * 2.0) + 0.13 * sin(TAU * 110.0 * t))
			_:
				# Two hard, harmonically rich rising/falling horn blasts.
				var local := fmod(t, 0.8)
				var envelope := clampf(minf(local / 0.012, (0.73 - local) / 0.06), 0.0, 1.0)
				var frequency := 270.0 + 170.0 * sin(PI * clampf(local / 0.73, 0.0, 1.0))
				phase += TAU * frequency / rate
				sample = envelope * (0.36 * sin(phase) + 0.20 * sin(phase * 2.0) + 0.12 * sin(phase * 3.0) + 0.07 * sin(phase * 5.0))
		data.encode_s16(index * 2, int(clampf(sample, -0.85, 0.85) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.mix_rate = rate
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.data = data
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if kind == "battery" else AudioStreamWAV.LOOP_DISABLED
	if kind == "battery":
		stream.loop_begin = 0
		stream.loop_end = frames
	return stream

static func _wav(data: PackedByteArray, rate: int) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.mix_rate = rate
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = data
	return stream

static func make_missile_boom() -> AudioStreamWAV:
	# Small, short boom for a destroyed missile: a quick falling thump with a
	# soft crack on top and a brief filtered tail (0.32 s). Original PCM.
	var rate := 48000
	var frames := int(0.32 * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 51207
	var phase := 0.0
	var filtered := 0.0
	var low := 0.0
	for i in range(frames):
		var t := float(i) / rate
		phase += TAU * lerpf(170.0, 58.0, minf(1.0, t / 0.16)) / rate
		var noise := rng.randf_range(-1.0, 1.0)
		filtered = lerpf(filtered, noise, 0.25)
		low = lerpf(low, filtered, 0.10)
		var envelope := minf(1.0, t / 0.002) * exp(-t * 15.0) * clampf((0.32 - t) / 0.04, 0.0, 1.0)
		var crack := exp(-t * 95.0) * filtered * 0.30
		var sample := envelope * (0.52 * sin(phase) + 0.9 * low) + crack
		data.encode_s16(i * 2, int(clampf(sample, -0.85, 0.85) * 32767.0))
	return _wav(data, rate)

static func make_nuke_boom() -> AudioStreamWAV:
	# Brief but full explosion for a nuclear missile: sharp crack, deep falling
	# sub-boom and a rolling low rumble that fades within about 1.1 s. Original PCM.
	var rate := 48000
	var frames := int(1.1 * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 88123
	var phase := 0.0
	var filtered := 0.0
	var rumble := 0.0
	for i in range(frames):
		var t := float(i) / rate
		phase += TAU * lerpf(92.0, 30.0, minf(1.0, pow(t / 0.55, 0.6))) / rate
		var noise := rng.randf_range(-1.0, 1.0)
		filtered = lerpf(filtered, noise, 0.30)
		rumble = lerpf(rumble, filtered, 0.035)
		var attack := minf(1.0, t / 0.004)
		var body := attack * exp(-t * 4.2) * (0.55 * sin(phase) + 0.18 * sin(phase * 2.0))
		var roll := attack * exp(-t * 3.0) * (1.0 + 0.35 * sin(TAU * 7.0 * t)) * rumble * 2.4
		var crack := exp(-t * 60.0) * filtered * 0.42
		# Smooth limiter keeps the peak below 0.8 without hard clipping.
		var sample := 0.8 * tanh(1.4 * (body + roll + crack)) * clampf((1.1 - t) / 0.12, 0.0, 1.0)
		data.encode_s16(i * 2, int(clampf(sample, -0.85, 0.85) * 32767.0))
	return _wav(data, rate)

static func make_craft_boom() -> AudioStreamWAV:
	# Short, light boom for a destroyed fighter: soft pop, quick low thud and a
	# brief noisy tail (0.26 s). Quieter and duller than the missile boom. Original PCM.
	var rate := 48000
	var frames := int(0.26 * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 30417
	var phase := 0.0
	var filtered := 0.0
	var low := 0.0
	for i in range(frames):
		var t := float(i) / rate
		phase += TAU * lerpf(140.0, 64.0, minf(1.0, t / 0.12)) / rate
		var noise := rng.randf_range(-1.0, 1.0)
		filtered = lerpf(filtered, noise, 0.18)
		low = lerpf(low, filtered, 0.08)
		var envelope := minf(1.0, t / 0.003) * exp(-t * 19.0) * clampf((0.26 - t) / 0.04, 0.0, 1.0)
		var pop := exp(-t * 120.0) * filtered * 0.22
		var sample := envelope * (0.45 * sin(phase) + 0.8 * low) + pop
		data.encode_s16(i * 2, int(clampf(sample, -0.8, 0.8) * 32767.0))
	return _wav(data, rate)

static func make_heavy_boom() -> AudioStreamWAV:
	# Fuller boom for a destroyed Heavy Raider: a deeper falling thud with a short
	# rumble (0.45 s). Still well below the nuke boom. Original PCM.
	var rate := 48000
	var frames := int(0.45 * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 62093
	var phase := 0.0
	var filtered := 0.0
	var low := 0.0
	for i in range(frames):
		var t := float(i) / rate
		phase += TAU * lerpf(120.0, 44.0, minf(1.0, t / 0.22)) / rate
		var noise := rng.randf_range(-1.0, 1.0)
		filtered = lerpf(filtered, noise, 0.22)
		low = lerpf(low, filtered, 0.06)
		var envelope := minf(1.0, t / 0.003) * exp(-t * 9.0) * clampf((0.45 - t) / 0.06, 0.0, 1.0)
		var crack := exp(-t * 80.0) * filtered * 0.26
		var sample := 0.8 * tanh(1.2 * (envelope * (0.55 * sin(phase) + 1.1 * low) + crack))
		data.encode_s16(i * 2, int(clampf(sample, -0.85, 0.85) * 32767.0))
	return _wav(data, rate)

static func make_capital_boom() -> AudioStreamWAV:
	# Large explosion for a destroyed Basestar or Resurrection Ship: a heavy crack,
	# a very deep falling boom, a second blast a moment later and a long rolling
	# rumble that fades within about 2 s. Original PCM.
	var rate := 48000
	var length := 2.0
	var frames := int(length * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 74401
	var phase := 0.0
	var phase2 := 0.0
	var filtered := 0.0
	var rumble := 0.0
	for i in range(frames):
		var t := float(i) / rate
		phase += TAU * lerpf(78.0, 26.0, minf(1.0, pow(t / 0.9, 0.6))) / rate
		var t2 := maxf(0.0, t - 0.28)
		phase2 += TAU * lerpf(64.0, 30.0, minf(1.0, t2 / 0.6)) / rate
		var noise := rng.randf_range(-1.0, 1.0)
		filtered = lerpf(filtered, noise, 0.30)
		rumble = lerpf(rumble, filtered, 0.025)
		var attack := minf(1.0, t / 0.005)
		var body := attack * exp(-t * 2.6) * (0.55 * sin(phase) + 0.16 * sin(phase * 2.0))
		var second := (0.0 if t < 0.28 else minf(1.0, t2 / 0.01) * exp(-t2 * 4.5) * 0.35 * sin(phase2))
		var roll := attack * exp(-t * 1.8) * (1.0 + 0.4 * sin(TAU * 5.0 * t)) * rumble * 2.8
		var crack := exp(-t * 45.0) * filtered * 0.45
		var sample := 0.8 * tanh(1.4 * (body + second + roll + crack)) * clampf((length - t) / 0.25, 0.0, 1.0)
		data.encode_s16(i * 2, int(clampf(sample, -0.85, 0.85) * 32767.0))
	return _wav(data, rate)

static func make_bonus_chime() -> AudioStreamWAV:
	# 1.05 bonus unlocked: a bright rising two-tone chime (C6 then G6, about 1 s)
	# with a soft bell-like decay and a faint octave shimmer. Original PCM.
	var rate := 48000
	var length := 1.0
	var frames := int(length * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var notes := [[0.0, 1046.5], [0.32, 1568.0]]
	for i in range(frames):
		var t := float(i) / rate
		var sample := 0.0
		for note in notes:
			var start: float = note[0]
			var pitch: float = note[1]
			if t < start:
				continue
			var u := t - start
			var envelope := minf(1.0, u / 0.006) * exp(-u * 4.2)
			sample += envelope * (0.36 * sin(TAU * pitch * u) + 0.10 * sin(TAU * pitch * 2.0 * u) + 0.04 * sin(TAU * pitch * 3.01 * u))
		sample *= clampf((length - t) / 0.08, 0.0, 1.0)
		data.encode_s16(i * 2, int(clampf(sample, -0.8, 0.8) * 32767.0))
	return _wav(data, rate)

static func make_repair_charge(seconds: float = 5.0) -> AudioStreamWAV:
	# 1.06 Rapid Repair: a smooth rising "recharging" tone for the length of the
	# repair. Pitch climbs from about 220 Hz to 880 Hz with a soft fifth above,
	# a gentle 6 Hz shimmer and a fade at both ends. Original PCM.
	var rate := 48000
	var length := clampf(seconds, 0.5, 20.0)
	var frames := int(length * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var phase := 0.0
	var phase2 := 0.0
	for i in range(frames):
		var t := float(i) / rate
		var u := t / length
		var pitch := 220.0 * pow(4.0, u * (0.85 + 0.15 * u))
		phase += TAU * pitch / rate
		phase2 += TAU * pitch * 1.5 / rate
		var shimmer := 0.82 + 0.18 * sin(TAU * 6.0 * t)
		var envelope := minf(1.0, t / 0.12) * clampf((length - t) / 0.25, 0.0, 1.0)
		var sample := envelope * shimmer * (0.30 * sin(phase) + 0.10 * sin(phase2) + 0.05 * sin(phase * 2.0)) * (0.7 + 0.3 * u)
		data.encode_s16(i * 2, int(clampf(sample, -0.8, 0.8) * 32767.0))
	return _wav(data, rate)

static func make_emp_zap() -> AudioStreamWAV:
	# 1.06 EMP: a sharp electric zap (about 0.7 s). A buzzing sawtooth falls in
	# pitch under crackling noise bursts, ending in a short fizz. Original PCM.
	var rate := 48000
	var length := 0.7
	var frames := int(length * rate)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 1060
	var phase := 0.0
	var crackle := 0.0
	var hold := 0
	for i in range(frames):
		var t := float(i) / rate
		var pitch := lerpf(420.0, 70.0, minf(1.0, t / 0.55))
		phase = fmod(phase + pitch / rate, 1.0)
		var saw := 2.0 * phase - 1.0
		if hold <= 0:
			crackle = rng.randf_range(-1.0, 1.0) * (1.0 if rng.randf() < 0.35 else 0.15)
			hold = rng.randi_range(8, 60)
		hold -= 1
		var attack := minf(1.0, t / 0.003)
		var body := attack * exp(-t * 4.5) * 0.42 * saw * (0.6 + 0.4 * sin(TAU * 50.0 * t))
		var noise := attack * exp(-t * 6.0) * 0.38 * crackle
		var snap := exp(-t * 60.0) * 0.5 * rng.randf_range(-1.0, 1.0)
		var sample := 0.85 * tanh(1.6 * (body + noise + snap)) * clampf((length - t) / 0.08, 0.0, 1.0)
		data.encode_s16(i * 2, int(clampf(sample, -0.85, 0.85) * 32767.0))
	return _wav(data, rate)
