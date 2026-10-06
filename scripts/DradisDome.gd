extends Control
##
## DRADIS Dome - fully parameter-driven animation for live tuning.
##
## Every visual element is an @export variable so you can adjust it live in
## the editor Inspector OR at runtime with the on-screen sliders (see
## DradisConsole.gd). Change a value, watch it update instantly.
##

# ---------- SPHERE / BACKGROUND ----------
@export_group("Sphere")
@export var sphere_radius: float = 320.0         # Radius of the dome in pixels
@export var sphere_visible: bool = true          # Show the faint sphere outline
@export var sphere_color: Color = Color(0.2, 0.9, 1.0, 0.15)  # Faint cyan
@export var sphere_line_width: float = 1.0

# ---------- RINGS ----------
@export_group("Rings")
@export_range(0, 6) var ring_count: int = 2      # How many rings on screen
@export var ring_color: Color = Color(0.3, 1.0, 1.0, 1.0)     # Bright cyan
@export var ring_glow_color: Color = Color(0.6, 1.0, 1.0, 0.4) # Soft glow
@export var ring_thickness: float = 4.0
@export var ring_glow_thickness: float = 14.0
@export_range(0.5, 20.0) var ring_rotation_seconds: float = 4.0  # Full rotation period
@export var rings_hinged_at_top: bool = true     # true = share top pivot; false = free axes

# Per-ring base tilt (only used when rings_hinged_at_top = false)
@export var ring_a_axis_tilt_deg: float = 0.0
@export var ring_b_axis_tilt_deg: float = 90.0

# ---------- BASE PLANE RIPPLES ----------
@export_group("Ripples")
@export var ripples_visible: bool = true
@export_range(0.5, 6.0) var ripple_period_seconds: float = 2.0
@export_range(1, 6) var ripple_count: int = 3
@export var ripple_color: Color = Color(0.3, 1.0, 1.0, 0.6)
@export var ripple_max_radius: float = 340.0
@export var ripple_thickness: float = 2.0

# ---------- SCANLINES ----------
@export_group("Scanlines")
@export var scanlines_visible: bool = true
@export var scanline_color: Color = Color(0.0, 0.0, 0.0, 0.25)
@export var scanline_spacing: float = 4.0
@export_range(0.0, 200.0) var scanline_scroll_speed: float = 12.0

# ---------- INTERNAL STATE ----------
var _time: float = 0.0

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()  # Trigger _draw() every frame

# ------------------------------------------------------------------
# DRAW
# ------------------------------------------------------------------
func _draw() -> void:
	var center: Vector2 = size * 0.5
	_draw_ripples(center)
	_draw_sphere_ghost(center)
	_draw_rings(center)
	_draw_scanlines()

# ---- SPHERE GHOST ----
func _draw_sphere_ghost(center: Vector2) -> void:
	if not sphere_visible:
		return
	# Just a faint circle to hint at the sphere volume.
	_draw_ellipse(center, sphere_radius, sphere_radius, sphere_color, sphere_line_width, 64)

# ---- RIPPLES on the base plane ----
func _draw_ripples(center: Vector2) -> void:
	if not ripples_visible:
		return
	# Ripples emit from center outward on the ground plane (drawn as flattened ellipses).
	var period: float = ripple_period_seconds
	for i in range(ripple_count):
		var phase: float = fposmod(_time + i * (period / float(ripple_count)), period) / period
		var r: float = phase * ripple_max_radius
		var alpha: float = (1.0 - phase) * ripple_color.a
		var col: Color = Color(ripple_color.r, ripple_color.g, ripple_color.b, alpha)
		# Flatten to look like a horizontal ripple on a ground plane.
		_draw_ellipse(center + Vector2(0, sphere_radius * 0.25),
					   r, r * 0.30, col, ripple_thickness, 64)

# ---- RINGS ----
func _draw_rings(center: Vector2) -> void:
	if ring_count <= 0:
		return

	# spin_angle is the shared rotation phase driven by ring_rotation_seconds.
	var spin_angle: float = fmod(_time / ring_rotation_seconds, 1.0) * TAU

	for i in range(ring_count):
		var base_tilt_deg: float
		if rings_hinged_at_top:
			# HINGED MODE:
			# Both rings share the TOP pivot and stay locked 90 deg apart from each other.
			# We rotate the whole rigid pair together around the vertical axis.
			base_tilt_deg = float(i) * (180.0 / max(ring_count, 1))
		else:
			# FREE MODE: each ring uses its independent tilt.
			base_tilt_deg = ring_a_axis_tilt_deg if i == 0 else ring_b_axis_tilt_deg

		# Live spin adds to the base tilt. In hinged mode, both rings share spin_angle
		# so they rotate together as a rigid frame.
		var tilt_rad: float = deg_to_rad(base_tilt_deg) + spin_angle

		# We draw the ring as an ellipse whose horizontal radius = sphere_radius
		# and whose vertical radius = sphere_radius * cos(tilt) — this gives the
		# illusion of a 3D circle rotating in and out of the screen plane.
		var rx: float = sphere_radius
		var ry: float = sphere_radius * abs(cos(tilt_rad))

		# Rotate the ellipse itself in the 2D plane. In hinged mode, both rings
		# also share this in-plane rotation so their intersection stays anchored.
		var plane_rot: float
		if rings_hinged_at_top:
			# Rings meet at the top of the sphere (a fixed on-screen point above center).
			# We rotate each ring's in-plane axis 90 deg apart from the next.
			plane_rot = deg_to_rad(base_tilt_deg)
		else:
			plane_rot = deg_to_rad(base_tilt_deg)

		# Draw glow first (thick, soft) then core (thin, bright) for a neon feel.
		_draw_rotated_ellipse(center, rx, ry, plane_rot, ring_glow_color,
							  ring_glow_thickness, 96)
		_draw_rotated_ellipse(center, rx, ry, plane_rot, ring_color,
							  ring_thickness, 96)

# ---- SCANLINES ----
func _draw_scanlines() -> void:
	if not scanlines_visible:
		return
	var offset: float = fmod(_time * scanline_scroll_speed, scanline_spacing)
	var y: float = -scanline_spacing + offset
	while y < size.y:
		draw_line(Vector2(0, y), Vector2(size.x, y), scanline_color, 1.0)
		y += scanline_spacing

# ------------------------------------------------------------------
# GEOMETRY HELPERS
# ------------------------------------------------------------------
func _draw_ellipse(center: Vector2, rx: float, ry: float, color: Color,
				   thickness: float, segments: int) -> void:
	_draw_rotated_ellipse(center, rx, ry, 0.0, color, thickness, segments)

func _draw_rotated_ellipse(center: Vector2, rx: float, ry: float, rotation_rad: float,
						   color: Color, thickness: float, segments: int) -> void:
	var pts: PackedVector2Array = PackedVector2Array()
	var cos_r: float = cos(rotation_rad)
	var sin_r: float = sin(rotation_rad)
	for i in range(segments + 1):
		var t: float = float(i) / float(segments) * TAU
		var x: float = rx * cos(t)
		var y: float = ry * sin(t)
		# Rotate the (x, y) point by rotation_rad.
		var xr: float = x * cos_r - y * sin_r
		var yr: float = x * sin_r + y * cos_r
		pts.append(center + Vector2(xr, yr))
	draw_polyline(pts, color, thickness, true)
