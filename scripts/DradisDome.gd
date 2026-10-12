extends Control
##
## DRADIS Dome - fully parameter-driven animation for live tuning.
##
## Every visual element is an @export variable so you can adjust it live in
## the editor Inspector OR at runtime with the on-screen sliders (see
## DradisConsole.gd). Change a value, watch it update instantly.
##

## 1.2.6: the scope outline (shared with the console frame and the contacts).
const ScopeShape = preload("res://scripts/ScopeShape.gd")

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

# ---------- RING HINGE (1.2.4) ----------
@export_group("Ring Hinge")
## Off = today's look (horizontal ring hinged at the left and right sides).
## On = horizontal ring lies around the dome's middle and is hinged at the front and back.
@export var ring_horizontal_hinge_front_back: bool = false
## How far above the dome the viewer sits; sets how open the flat ring looks.
@export_range(0.0, 60.0) var ring_view_elevation_deg: float = 30.0
## Turn direction of the front-and-back ring: 1 or -1.
@export_range(-1, 1, 2) var ring_front_back_direction: int = -1

# ---------- RING TRAIL (1.2.4) ----------
@export_group("Ring Trail")
## Off = today's look (one thin line per ring). On = a soft trail of faint glow copies.
@export var ring_trail_enabled: bool = false
## How far back in time the trail reaches.
@export_range(0.05, 1.0) var ring_trail_seconds: float = 0.20
## How many faint copies make up the trail (more = smoother, same total light).
@export_range(1, 32) var ring_trail_copies: int = 24
## Trail light. Keep it low: the rings are quiet background.
@export_range(0.0, 1.0) var ring_trail_strength: float = 0.30
## With the trail on, the ring's own glow is scaled by this so overall light stays the same.
@export_range(0.0, 1.0) var ring_trail_glow_scale: float = 0.50

# ---------- BASE PLANE RIPPLES ----------
@export_group("Ripples")
@export var ripples_visible: bool = true
@export_range(0.5, 6.0) var ripple_period_seconds: float = 2.0
@export_range(1, 6) var ripple_count: int = 3
@export var ripple_color: Color = Color(0.3, 1.0, 1.0, 0.6)
@export var ripple_max_radius: float = 340.0
@export var ripple_thickness: float = 2.0
## On = the pulse rings lie on the same plane as the flat horizontal ring
## (centred on the dome, tilted to Ring View Elevation Deg). Off = today's look
## (0.25 x radius lower, flattened to 0.30). Set Ripple Max Radius to the sphere
## radius (320) so the outer pulse stops at the ring's edge.
@export var ripples_match_ring_plane: bool = false

# ---------- SCANLINES ----------
@export_group("Scanlines")
@export var scanlines_visible: bool = true
@export var scanline_color: Color = Color(0.0, 0.0, 0.0, 0.25)
@export var scanline_spacing: float = 4.0
@export_range(0.0, 200.0) var scanline_scroll_speed: float = 12.0
## 1.2.6: draw the rolling scanlines only inside the scope outline (the arc and the V),
## so they never roll over the console panels and tabs that reach into the dome's
## square. Off = 1.2.5 (scanlines over the whole dome square).
@export var scanlines_inside_scope: bool = false

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
		_draw_ellipse(ripple_center(center), r, r * ripple_flatten(), col, ripple_thickness, 64)

## Where the pulse rings are centred: on the dome (ring plane) or 0.25 x radius lower (1.2.3).
func ripple_center(center: Vector2) -> Vector2:
	return center if ripples_match_ring_plane else center + Vector2(0, sphere_radius * 0.25)

## Height-to-width ratio of the pulse rings: sin(Ring View Elevation Deg) on the ring plane, else 0.30.
func ripple_flatten() -> float:
	return sin(deg_to_rad(ring_view_elevation_deg)) if ripples_match_ring_plane else 0.30

# ---- RINGS ----
func _draw_rings(center: Vector2) -> void:
	if ring_count <= 0:
		return

	if ring_trail_enabled:
		for k in range(ring_trail_copies, 0, -1):
			var back: float = ring_trail_seconds * float(k) / float(ring_trail_copies)
			# Total trail light stays the same whatever the copy count.
			var fade: float = ring_trail_strength * (1.0 - float(k) / float(ring_trail_copies + 1)) * 4.0 / float(ring_trail_copies)
			_draw_ring_pair(center, _time - back, fade)
	_draw_ring_pair(center, _time, -1.0)

func _draw_ring_pair(center: Vector2, at_time: float, fade: float) -> void:
	# spin_angle is the shared rotation phase driven by ring_rotation_seconds.
	var spin_angle: float = fposmod(at_time / ring_rotation_seconds, 1.0) * TAU

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

		if i == 0 and rings_hinged_at_top and ring_horizontal_hinge_front_back:
			_draw_front_back_ring(center, spin_angle, fade)
			continue
		# Trail copies draw the soft glow only, at the given fade.
		if fade >= 0.0:
			var g := ring_glow_color
			g.a *= fade
			_draw_rotated_ellipse(center, rx, ry, plane_rot, g, ring_glow_thickness, 96)
			continue
		# Glow first (thick, soft) then the thin core line.
		var main_glow := ring_glow_color
		if ring_trail_enabled:
			main_glow.a *= ring_trail_glow_scale
		_draw_rotated_ellipse(center, rx, ry, plane_rot, main_glow,
							  ring_glow_thickness, 96)
		_draw_rotated_ellipse(center, rx, ry, plane_rot, ring_color,
							  ring_thickness, 96)

# Horizontal ring hinged at the front and back of the dome: it starts flat
# around the middle and turns about the front-to-back axis, seen from Ring View
# Elevation Deg above. Trail copies (fade >= 0) draw the soft glow only.
func _draw_front_back_ring(center: Vector2, angle: float, fade: float) -> void:
	var pts := front_back_ring_points(center, angle)
	if fade >= 0.0:
		var g := ring_glow_color
		g.a *= fade
		draw_polyline(pts, g, ring_glow_thickness, true)
		return
	var main_glow := ring_glow_color
	if ring_trail_enabled:
		main_glow.a *= ring_trail_glow_scale
	draw_polyline(pts, main_glow, ring_glow_thickness, true)
	draw_polyline(pts, ring_color, ring_thickness, true)

## Screen points of the front-and-back hinged ring at a spin angle: ring point
## (cos t * cos th, cos t * sin th, sin t) with th = angle * Ring Front Back Direction,
## seen from Ring View Elevation Deg above.
func front_back_ring_points(center: Vector2, angle: float, segments: int = 96) -> PackedVector2Array:
	var e: float = deg_to_rad(ring_view_elevation_deg)
	var th: float = angle * float(ring_front_back_direction)
	var ca: float = cos(th)
	var sa: float = sin(th)
	var pts := PackedVector2Array()
	for k in range(segments + 1):
		var t: float = float(k) / float(segments) * TAU
		var x: float = cos(t) * ca
		var y: float = cos(t) * sa
		var z: float = sin(t)
		pts.append(center + Vector2(x, -(y * cos(e) - z * sin(e))) * sphere_radius)
	return pts

# ---- SCANLINES ----
func _draw_scanlines() -> void:
	if not scanlines_visible:
		return
	var offset: float = fmod(_time * scanline_scroll_speed, scanline_spacing)
	var y: float = -scanline_spacing + offset
	var center: Vector2 = size * 0.5
	while y < size.y:
		if scanlines_inside_scope:
			var half := scope_half_width_at(y, center)
			if half > 0.0:
				draw_line(Vector2(center.x - half, y), Vector2(center.x + half, y), scanline_color, 1.0)
		else:
			draw_line(Vector2(0, y), Vector2(size.x, y), scanline_color, 1.0)
		y += scanline_spacing

## 1.2.6: half width in pixels of the scope outline at dome-local height y (0 = outside).
func scope_half_width_at(y: float, center: Vector2) -> float:
	var u := (y - center.y) / maxf(1.0, sphere_radius)
	var s := ScopeShape.v_start()
	if u <= s.y:
		if absf(u) >= ScopeShape.ARC:
			return 0.0
		return sqrt(ScopeShape.ARC * ScopeShape.ARC - u * u) * sphere_radius
	if u > ScopeShape.V_DEPTH:
		return 0.0
	return ScopeShape.v_half_width_at(u) * sphere_radius

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
