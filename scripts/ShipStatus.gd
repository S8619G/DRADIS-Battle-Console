extends Control
## Approved, unmodified outline. Interior mask follows its connected silhouette.
## FTL sits in the left (stern) section, HULL in the right (bow) section, and the
## INTRUSION DETECTION warning appears in the middle while Heavy Raiders hack.
## 1.06: the outline pulses brighter green while a Rapid Repair runs.
## 1.07: the EMP is offered on the split FIREWALL button, so INTRUSION DETECTION
## always stays visible here (Emp On Ship brings back the 1.06 USE EMP box).
const OUTLINE = preload("res://assets/ship_outline.png")
const FILL = preload("res://assets/ship_fill.png")
## 1.09: the top nacelle only, cut from the approved art, for the STEALTH WEAPON button.
const NACELLE_FILL = preload("res://assets/ship_nacelle_fill.png")
const NACELLE_OUTLINE = preload("res://assets/ship_nacelle_outline.png")
## Top nacelle bounds and label center, in texture pixels.
const NACELLE_BOX := Rect2(479, 174, 695, 109)
const NACELLE_LABEL := Vector2(826, 230)
## Top (port-side) edge of the approved outline, in REGION pixels (traced from
## the retained ship_upper_defense.svg). The Defense Battery arc is built from it.
const TOP_EDGE := [Vector2(0, 150), Vector2(6, 142), Vector2(12, 139), Vector2(49, 130), Vector2(136, 115),
	Vector2(204, 109), Vector2(256, 109), Vector2(294, 112), Vector2(385, 129), Vector2(386, 59),
	Vector2(391, 50), Vector2(398, 46), Vector2(444, 32), Vector2(535, 13), Vector2(618, 4),
	Vector2(894, 4), Vector2(984, 19), Vector2(1046, 35), Vector2(1078, 46), Vector2(1085, 51),
	Vector2(1090, 60), Vector2(1091, 135), Vector2(1224, 140), Vector2(1308, 149), Vector2(1400, 170),
	Vector2(1479, 195), Vector2(1499, 206), Vector2(1506, 214), Vector2(1508, 242), Vector2(1514, 251),
	Vector2(1518, 280), Vector2(1521, 284)]
const REGION := Rect2(88, 169, 1522, 597)
@export var contacts_path: NodePath = ^"../CenterContainer/Dome/Contacts"
@export_range(0.1, 0.8) var fill_opacity: float = 0.34
## Defense Battery arc: a smooth flak arc curving over the port side of the ship.
## Gap is the closest clearance; Projection pushes the arc further out from the ship.
@export_range(6.0, 30.0) var defense_gap_pixels: float = 12.0
@export_range(0.0, 30.0) var defense_arc_projection: float = 3.0
## How far (pixels) the arc reaches past the stern and bow.
@export_range(0.0, 40.0) var defense_arc_overhang: float = 8.0
@export_range(1.0, 8.0) var defense_arc_width: float = 3.0
## How fast the fire colors flicker along the line (changes per second).
@export_range(1.0, 30.0) var flak_flicker_hz: float = 12.0
## Fraction of the line that sparkles bright yellow-white at any moment.
@export_range(0.0, 0.5) var flak_sparkle_amount: float = 0.12
@export var flak_yellow := Color(1.0, 0.86, 0.10)
@export var flak_orange := Color(1.0, 0.52, 0.06)
@export var flak_deep := Color(0.92, 0.30, 0.04)
@export var flak_sparkle := Color(1.0, 0.97, 0.66)
## Horizontal centers (fraction of the outline width) of the FTL and HULL readouts.
@export_range(0.05, 0.45) var ftl_center: float = 0.18
## 1.08: the FTL readout while a Heavy Raider breach holds FTL offline.
@export var ftl_offline_color := Color("#ff6b6b")
@export_range(10, 30) var ftl_offline_font_size: int = 18
@export_range(0.55, 0.95) var hull_center: float = 0.855
@export_group("Intrusion Detection")
@export var intrusion_box_size := Vector2(150, 64)
@export_range(4.0, 24.0) var intrusion_stripe_width: float = 9.0
@export_range(0.5, 8.0) var intrusion_flash_hz: float = 3.0
@export var intrusion_red := Color(0.86, 0.08, 0.12, 0.85)
@export_group("Rapid Repair and EMP")
## Outline color reached at the top of each Rapid Repair pulse.
@export var repair_green := Color("#9dffb8")
@export var emp_blue := Color(0.35, 0.78, 1.0)
## 1.07: off = INTRUSION DETECTION always shows; the EMP is on the FIREWALL button.
@export var emp_on_ship: bool = false
@export_group("Stealth Weapon")
## 1.09: the top nacelle turns into this blue button only while the Stealth Viper
## can launch; otherwise it keeps the normal hull color.
@export var stealth_blue := Color("#2a9dff")
@export var stealth_label: String = "STEALTH WEAPON"
@export_range(10, 24) var stealth_font_size: int = 15
## Gentle brightness pulse (cycles per second), not a flash.
@export_range(0.2, 2.0) var stealth_pulse_hz: float = 0.8
@onready var battle: Control = get_node(contacts_path)
var stealth_button: Button
var stealth_box := Rect2()
signal stealth_launched
## Invisible click area over the USE EMP box (shown only while the EMP can fire).
var emp_button: Button
var emp_box := Rect2()
signal emp_used

func _ready() -> void:
	emp_button = Button.new()
	emp_button.name = "UseEmpButton"
	emp_button.flat = true
	emp_button.focus_mode = Control.FOCUS_NONE
	emp_button.mouse_filter = Control.MOUSE_FILTER_STOP
	emp_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"]:
		emp_button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	emp_button.visible = false
	emp_button.pressed.connect(_on_emp_pressed)
	add_child(emp_button)
	stealth_button = Button.new()
	stealth_button.name = "StealthWeaponButton"
	stealth_button.flat = true
	stealth_button.focus_mode = Control.FOCUS_NONE
	stealth_button.mouse_filter = Control.MOUSE_FILTER_STOP
	stealth_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal", "hover", "pressed", "focus", "disabled", "hover_pressed"]:
		stealth_button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	stealth_button.visible = false
	stealth_button.pressed.connect(_on_stealth_pressed)
	add_child(stealth_button)

func _on_stealth_pressed() -> void:
	if is_instance_valid(battle) and battle.launch_stealth():
		stealth_launched.emit()

func _on_emp_pressed() -> void:
	if is_instance_valid(battle) and battle.request_emp():
		emp_used.emit()

func _process(_delta: float) -> void:
	if is_instance_valid(emp_button) and is_instance_valid(battle):
		var can_fire: bool = emp_on_ship and battle.can_use_emp() and emp_box.size.x > 0.0
		emp_button.visible = can_fire
		if can_fire:
			emp_button.position = emp_box.position
			emp_button.size = emp_box.size
	if is_instance_valid(stealth_button) and is_instance_valid(battle):
		var ready: bool = battle.can_launch_stealth() and stealth_box.size.x > 0.0
		stealth_button.visible = ready
		if ready:
			stealth_button.position = stealth_box.position
			stealth_button.size = stealth_box.size
	queue_redraw()

static func damage_color(fraction: float) -> Color:
	var value := clampf(fraction, 0.0, 1.0)
	if value >= 0.65:
		return Color("#bef5a0").lerp(Color("#32d86d"), (value - 0.65) / 0.35)
	if value >= 0.30:
		return Color("#ff9b38").lerp(Color("#bef5a0"), (value - 0.30) / 0.35)
	return Color("#f03939").lerp(Color("#ff9b38"), value / 0.30)

func _draw() -> void:
	if not is_instance_valid(battle):
		return
	var width := minf(size.x, size.y * REGION.size.x / REGION.size.y)
	var dimensions := Vector2(width, width * REGION.size.y / REGION.size.x)
	var rect := Rect2((size - dimensions) * 0.5, dimensions)
	var tint := damage_color(battle.hull / maxf(1.0, battle.max_hull))
	var repair_pulse: float = battle.repair_flash_level()
	if repair_pulse > 0.0:
		tint = tint.lerp(repair_green, repair_pulse)
	if battle.hit_flash_remaining > 0.0:
		tint = Color("#ff243f")
	draw_texture_rect_region(FILL, rect, REGION, Color(tint, fill_opacity))
	draw_texture_rect_region(OUTLINE, rect, REGION, Color(tint, 0.95))
	var k := dimensions.x / REGION.size.x
	stealth_box = Rect2(rect.position + (NACELLE_BOX.position - REGION.position) * k, NACELLE_BOX.size * k)
	if battle.can_launch_stealth():
		_draw_stealth_button(rect, k)
	if battle.prox_active and not battle.is_defeated():
		# Ship's port/left side is the TOP of this horizontal screen silhouette.
		# A separate flak arc stays above the art with a visible air gap.
		_draw_flak_arc(defense_arc(rect))
	var left := rect.position + dimensions * Vector2(ftl_center, 0.5)
	var right := rect.position + dimensions * Vector2(hull_center, 0.5)
	var text_color := Color("#e6f7ee")
	_text("FTL", left + Vector2(0, -6), 16, text_color)
	if battle.ftl_offline:
		# 1.08: a Heavy Raider breach has taken FTL offline.
		_text("OFFLINE", left + Vector2(0, 20), ftl_offline_font_size, ftl_offline_color)
	else:
		_text("%d%%" % battle.ftl_percent(), left + Vector2(0, 22), 26,
			Color("#99f7dd") if battle.can_jump() else Color("#ffe1a6"))
	_text("HULL", right + Vector2(0, -6), 16, text_color)
	_text("%d%%" % battle.hull_percent(), right + Vector2(0, 22), 26, text_color)
	var middle := rect.position + dimensions * Vector2(0.49, 0.5)
	emp_box = Rect2(middle - intrusion_box_size * 0.5, intrusion_box_size)
	if emp_on_ship and battle.can_use_emp():
		_draw_use_emp(middle)
	elif battle.hack_state() in ["hacking", "draining"]:
		_draw_intrusion(middle)

var _arc_cache_key := Rect2()
var _arc_cache := PackedVector2Array()

func defense_arc(rect: Rect2) -> PackedVector2Array:
	# A smooth, gentle elliptical arc over the port side of the ship. Its shape
	# (center and width) was fitted to the outline; its height is set so the
	# arc clears every point of the top edge by Gap + Projection pixels.
	var key := Rect2(rect.position, rect.size + Vector2(defense_gap_pixels, defense_arc_projection))
	if key == _arc_cache_key and not _arc_cache.is_empty():
		return _arc_cache
	var k := rect.size.x / REGION.size.x
	var cx := 700.0
	var cy := 680.0
	var rx := 1160.0
	var clearance := (defense_gap_pixels + defense_arc_projection) / k
	var ry := 0.0
	for i in range(TOP_EDGE.size() - 1):
		var a: Vector2 = TOP_EDGE[i]
		var b: Vector2 = TOP_EDGE[i + 1]
		for step in range(8):
			var p := a.lerp(b, step / 8.0)
			var u := (p.x - cx) / rx
			ry = maxf(ry, (cy - (p.y - clearance)) / sqrt(1.0 - u * u))
	var overhang := defense_arc_overhang / k
	var out := PackedVector2Array()
	var count := 96
	for i in range(count + 1):
		var x := lerpf(-overhang, REGION.size.x + overhang, float(i) / count)
		var u := (x - cx) / rx
		var y := cy - ry * sqrt(maxf(0.0, 1.0 - u * u))
		out.append(rect.position + Vector2(x, y) * k)
	_arc_cache_key = key
	_arc_cache = out
	return out

func flak_color(index: int, time: float) -> Color:
	# Fire-like flicker: each short piece of the line blends between yellow,
	# orange and deep orange, with brief bright sparkles. The line never widens.
	var step := floorf(time * flak_flicker_hz)
	var blend := time * flak_flicker_hz - step
	var a := _hash01(index, int(step))
	var b := _hash01(index, int(step) + 1)
	var heat := lerpf(a, b, blend) * 0.7 + 0.3 * (0.5 + 0.5 * sin(index * 0.45 - time * 7.0))
	var color: Color
	if heat < 0.5:
		color = flak_deep.lerp(flak_orange, heat * 2.0)
	else:
		color = flak_orange.lerp(flak_yellow, (heat - 0.5) * 2.0)
	if _hash01(index * 7 + 3, int(step)) < flak_sparkle_amount:
		color = color.lerp(flak_sparkle, 1.0 - blend)
	return color

static func _hash01(a: int, b: int) -> float:
	var h := (a * 73856093) ^ (b * 19349663)
	h = (h ^ (h >> 13)) * 1274126177
	return float((h >> 8) & 0xFFFF) / 65535.0

func _draw_flak_arc(points: PackedVector2Array) -> void:
	var time: float = battle.battle_time
	var piece := 0
	var carry := 0.0
	var segment_length := 5.0
	for i in range(points.size() - 1):
		var a := points[i]
		var b := points[i + 1]
		var length := a.distance_to(b)
		var done := 0.0
		while done < length:
			var take := minf(segment_length - carry, length - done)
			var from := a.lerp(b, done / length)
			var to := a.lerp(b, (done + take) / length)
			draw_line(from, to, flak_color(piece, time), defense_arc_width, true)
			done += take
			carry += take
			if carry >= segment_length:
				carry = 0.0
				piece += 1

func _draw_intrusion(center: Vector2) -> void:
	# Red-outlined box filled with thick 45-degree red and black stripes.
	var box := Rect2(center - intrusion_box_size * 0.5, intrusion_box_size)
	draw_rect(box, Color.BLACK)
	var corners := PackedVector2Array([box.position, Vector2(box.end.x, box.position.y), box.end, Vector2(box.position.x, box.end.y)])
	var w := maxf(2.0, intrusion_stripe_width)
	var step := w * 2.0
	var start := -box.size.y
	while start < box.size.x:
		var x0 := box.position.x + start
		var band := PackedVector2Array([Vector2(x0, box.end.y), Vector2(x0 + w, box.end.y),
			Vector2(x0 + w + box.size.y, box.position.y), Vector2(x0 + box.size.y, box.position.y)])
		for piece in Geometry2D.intersect_polygons(band, corners):
			draw_colored_polygon(piece, intrusion_red)
		start += step
	draw_rect(box, Color(1.0, 0.16, 0.2), false, 2.0)
	# Flashing text on a dark plate so it stays readable over the stripes.
	if int(battle.battle_time * intrusion_flash_hz * 2.0) % 2 == 0:
		var plate := Rect2(box.position + Vector2(8, 10), box.size - Vector2(16, 20))
		draw_rect(plate, Color(0, 0, 0, 0.78))
		var font := ThemeDB.fallback_font
		var mid := box.get_center()
		for line in [["INTRUSION", -3.0], ["DETECTION", 17.0]]:
			var size_px := 17
			var width := font.get_string_size(line[0], HORIZONTAL_ALIGNMENT_LEFT, -1, size_px).x
			var at := mid + Vector2(-width * 0.5, line[1])
			draw_string_outline(font, at, line[0], HORIZONTAL_ALIGNMENT_LEFT, -1, size_px, 3, Color.BLACK)
			draw_string(font, at, line[0], HORIZONTAL_ALIGNMENT_LEFT, -1, size_px, Color(1.0, 0.92, 0.9))

func _draw_use_emp(center: Vector2) -> void:
	# Electric-blue box with USE EMP and the charges held; pulses so it is noticed.
	var box := Rect2(center - intrusion_box_size * 0.5, intrusion_box_size)
	var pulse := 0.5 + 0.5 * sin(TAU * 2.5 * battle.battle_time)
	draw_rect(box, Color(0.0, 0.03, 0.08, 0.92))
	draw_rect(box.grow(-4.0), Color(emp_blue, 0.10 + 0.12 * pulse))
	draw_rect(box, emp_blue.lerp(Color.WHITE, 0.4 * pulse), false, 2.5)
	var font := ThemeDB.fallback_font
	var mid := box.get_center()
	var title := "USE EMP"
	var w := font.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, 22).x
	draw_string_outline(font, mid + Vector2(-w * 0.5, 2.0), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, 3, Color.BLACK)
	draw_string(font, mid + Vector2(-w * 0.5, 2.0), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.88, 0.97, 1.0))
	var charges: int = battle.emp_charges
	var note := "%d CHARGE%s" % [charges, "" if charges == 1 else "S"]
	var nw := font.get_string_size(note, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
	draw_string(font, mid + Vector2(-nw * 0.5, 21.0), note, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(emp_blue, 0.95))

func stealth_pulse() -> float:
	return 0.5 + 0.5 * cos(TAU * stealth_pulse_hz * battle.battle_time)

func _draw_stealth_button(rect: Rect2, k: float) -> void:
	# Nacelle-only masks: no blue reaches the rest of the hull.
	var pulse := stealth_pulse()
	draw_texture_rect_region(NACELLE_FILL, rect, REGION, Color(0, 0, 0, 1))
	draw_texture_rect_region(NACELLE_FILL, rect, REGION, Color(stealth_blue, 0.55 + 0.35 * pulse))
	draw_texture_rect_region(NACELLE_OUTLINE, rect, REGION, stealth_blue.lerp(Color.WHITE, 0.45 * pulse))
	var font := ThemeDB.fallback_font
	var center := rect.position + (NACELLE_LABEL - REGION.position) * k
	var w := font.get_string_size(stealth_label, HORIZONTAL_ALIGNMENT_LEFT, -1, stealth_font_size).x
	var at := center + Vector2(-w * 0.5, stealth_font_size * 0.36)
	draw_string_outline(font, at, stealth_label, HORIZONTAL_ALIGNMENT_LEFT, -1, stealth_font_size, 3, Color(0, 0.05, 0.15, 0.9))
	draw_string(font, at, stealth_label, HORIZONTAL_ALIGNMENT_LEFT, -1, stealth_font_size, Color(1, 1, 1, 0.6 + 0.4 * pulse))

func _text(value: String, center: Vector2, font_size: int, color: Color) -> void:
	var font := ThemeDB.fallback_font
	var width := font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	draw_string(font, center - Vector2(width * 0.5, 0), value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
