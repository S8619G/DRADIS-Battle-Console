extends RefCounted
## Small vector interpretations of references/dradis_contact_icons_reference.jpg.
## Capital ships are larger; squadrons use three copies of their single-ship mark.

const KINDS := [
	"unknown", "resurrection_ship", "baseship", "heavy_raider", "raider",
	"raider_squadron", "battlestar", "colonial_fleet", "friendly_unknown",
	"raptor", "s_star", "viper", "viper_squadron"
]

static func is_viper(kind: String) -> bool:
	return kind == "viper" or kind == "viper_squadron"

static func draw_icon(canvas: CanvasItem, kind: String, center: Vector2,
		icon_scale: float, color: Color) -> void:
	canvas.draw_set_transform(center, 0.0, Vector2.ONE * icon_scale)
	match kind:
		"resurrection_ship", "battlestar", "baseship":
			_single(canvas, kind, Vector2.ZERO, 1.5, color)
		"raider_squadron", "viper_squadron", "colonial_fleet":
			var unit := "viper" if kind == "viper_squadron" else "raider"
			if kind == "colonial_fleet":
				unit = "fleet"
			for offset in [Vector2(0, -10), Vector2(-10, 7), Vector2(10, 7)]:
				_single(canvas, unit, offset, 0.72, color)
		_:
			_single(canvas, kind, Vector2.ZERO, 1.0, color)
	canvas.draw_set_transform(Vector2.ZERO)

static func _line(canvas: CanvasItem, a: Vector2, b: Vector2,
		o: Vector2, s: float, c: Color, width: float = 1.35) -> void:
	canvas.draw_line(o + a * s, o + b * s, c, width * s, true)

static func _circle(canvas: CanvasItem, p: Vector2, radius: float,
		o: Vector2, s: float, c: Color) -> void:
	canvas.draw_arc(o + p * s, radius * s, 0, TAU, 40, c, 1.35 * s, true)

static func _dot(canvas: CanvasItem, p: Vector2, o: Vector2, s: float, c: Color) -> void:
	canvas.draw_circle(o + p * s, 1.45 * s, c)

static func _feet(canvas: CanvasItem, o: Vector2, s: float, c: Color) -> void:
	_line(canvas, Vector2(-5, 7), Vector2(-10, 12), o, s, c)
	_line(canvas, Vector2(5, 7), Vector2(10, 12), o, s, c)

static func _single(canvas: CanvasItem, kind: String, o: Vector2, s: float, c: Color) -> void:
	if kind == "fleet":
		_line(canvas, Vector2(-8, -3), Vector2(8, -3), o, s, c, 2.0)
		for p in [Vector2(-6, 2), Vector2(0, 2), Vector2(6, 2)]:
			_dot(canvas, p, o, s, c)
		_feet(canvas, o, s, c)
		return
	_circle(canvas, Vector2.ZERO, 7.0, o, s, c)
	match kind:
		"viper", "raptor", "friendly_unknown":
			for p in [Vector2(-2.6, 1.8), Vector2(2.6, 1.8), Vector2(0, -2.8)]:
				_dot(canvas, p, o, s, c)
			if kind == "raptor":
				_line(canvas, Vector2(-2, -10), Vector2(-2, -14), o, s, c)
				_line(canvas, Vector2(2, -10), Vector2(2, -14), o, s, c)
				_feet(canvas, o, s, c)
			elif kind == "viper":
				_line(canvas, Vector2(0, -8), Vector2(0, -13), o, s, c)
				_feet(canvas, o, s, c)
			else:
				for p in [Vector2(-10, -8), Vector2(10, -8), Vector2(0, 11)]:
					_dot(canvas, p, o, s, c)
		"s_star":
			_line(canvas, Vector2(0, -3), Vector2(0, -13), o, s, c)
			_line(canvas, Vector2(-12, 0), Vector2(12, 0), o, s, c)
			_feet(canvas, o, s, c)
		"raider", "heavy_raider":
			_line(canvas, Vector2(-13, 0), Vector2(-7, 0), o, s, c)
			_line(canvas, Vector2(7, 0), Vector2(13, 0), o, s, c)
			for p in [Vector2(-2.8, 1), Vector2(2.8, 1)]:
				_dot(canvas, p, o, s, c)
			_line(canvas, Vector2(-3, -4), Vector2(3, -4), o, s, c)
			if kind == "heavy_raider":
				_line(canvas, Vector2(-10, -6), Vector2(-13, 7), o, s, c)
				_line(canvas, Vector2(10, -6), Vector2(13, 7), o, s, c)
			else:
				_line(canvas, Vector2(0, -9), Vector2(0, -11), o, s, c)
		"battlestar":
			_circle(canvas, Vector2.ZERO, 10.5, o, s, c)
			_line(canvas, Vector2(-6, 5), Vector2(0, -7), o, s, c, 2.8)
			_line(canvas, Vector2(0, -7), Vector2(6, 5), o, s, c, 2.8)
			_line(canvas, Vector2(-8, 1), Vector2(8, 1), o, s, c)
			_dot(canvas, Vector2(0, -14), o, s, c)
		"baseship":
			for points in [
				[Vector2(-13, -12), Vector2(13, -12), Vector2(0, -5), Vector2(-13, -12)],
				[Vector2(-13, 0), Vector2(13, 0), Vector2(0, -7), Vector2(-13, 0)]]:
				for i in range(points.size() - 1):
					_line(canvas, points[i], points[i + 1], o, s, c)
			for y in [7, 12]:
				for x in [-10, -3, 4]:
					_line(canvas, Vector2(x, y), Vector2(x + 4, y), o, s, c)
		_:
			# Reference unknown / Resurrection symbols: ring, cardinal bars,
			# four diagonal dots; unknown adds the four center dots.
			_circle(canvas, Vector2.ZERO, 10.0, o, s, c)
			for p in [Vector2(-9, -10), Vector2(9, -10), Vector2(-9, 10), Vector2(9, 10)]:
				_dot(canvas, p, o, s, c)
			_line(canvas, Vector2(-14, 0), Vector2(-7, 0), o, s, c)
			_line(canvas, Vector2(7, 0), Vector2(14, 0), o, s, c)
			if kind == "resurrection_ship":
				_line(canvas, Vector2(0, -10), Vector2(0, -15), o, s, c)
			else:
				for p in [Vector2(-2.5, -2.5), Vector2(2.5, -2.5),
						Vector2(-2.5, 2.5), Vector2(2.5, 2.5)]:
					_dot(canvas, p, o, s, c)
	# Small lower pointer shared by the reference's circular ship marks.
	_line(canvas, Vector2(-2, 9), Vector2(0, 12), o, s, c)
	_line(canvas, Vector2(0, 12), Vector2(2, 9), o, s, c)
