extends Control
## Quiet structural chrome. The dome and rings remain separate and unchanged.
const EDGE := Color("#77324f")
const MUTED := Color("#b9a8b2")
const TEXT := Color("#ede0e8")
## Shared with the button borders so the chrome reads as one set.
const FRAME_WIDTH := 2.0
## 1.05: active bonus lines under the SCORE box (small, steady, accent color).
const BONUS_COLOR := Color(1.0, 0.6, 0.78, 0.85)
const BONUS_FONT_SIZE := 16
const BONUS_TOP := 156.0
const BONUS_LINE_STEP := 20.0
@onready var battle: Control = $"../CenterContainer/Dome/Contacts"

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var right := size.x - 48.0
	var bottom := size.y - 28.0
	var outline := PackedVector2Array([Vector2(66,32), Vector2(right-18,32),
		Vector2(right,50), Vector2(right,bottom-18), Vector2(right-18,bottom),
		Vector2(66,bottom), Vector2(48,bottom-18), Vector2(48,50), Vector2(66,32)])
	draw_polyline(outline, EDGE, FRAME_WIDTH, true)
	draw_line(Vector2(48,124), Vector2(right,124), EDGE, 1.0, true)
	draw_line(Vector2(48,size.y-112), Vector2(right,size.y-112), EDGE, 1.0, true)
	var center := size.x * 0.5
	draw_rect(Rect2(center-492,156,984,644), Color("#482138"), false, 1.0)
	# Header dividers organize title, four counters and score.
	for x in [420.0, size.x-460.0]:
		draw_line(Vector2(x,48), Vector2(x,108), EDGE, 1.0, true)
	var left := Vector2(82,208)
	_text("DEFENSE BATTERY", left, 19, MUTED)
	var state := "READY"
	var charge: float = battle.battery_percent()
	if battle.prox_active:
		state = "FIRING"
	elif charge <= 0.0:
		state = "EMPTY  RECHARGING"
	elif charge < 100.0:
		state = "RECHARGING" if battle.can_fire_battery() else "RECHARGING  WAIT %d%%" % int(battle.battery_restart_percent)
	_text("%d%% CHARGE" % int(charge), left+Vector2(0,46), 30, TEXT)
	_text(state, left+Vector2(0,80), 19, Color("#ffe28b"))
	draw_rect(Rect2(left+Vector2(0,100),Vector2(280,7)), Color("#352832"))
	var fraction := clampf(battle.prox_burst_remaining / maxf(0.1,battle.prox_burst_seconds),0.0,1.0)
	draw_rect(Rect2(left+Vector2(0,100),Vector2(280*fraction,7)), Color("#b4a267"))
	_text("RAPID REPAIR", left+Vector2(0,198), 19, MUTED)
	var repair_state := "%d CHARGE%s" % [battle.repair_charges, "" if battle.repair_charges == 1 else "S"]
	if battle.rapid_repair_remaining > 0.0:
		repair_state = "REPAIRING  %.1fs" % battle.rapid_repair_remaining
	elif battle.repair_charges <= 0:
		repair_state = "NO CHARGES"
	_text(repair_state, left+Vector2(0,240), 26, TEXT)
	_text("+%d%% HULL PER CHARGE" % int(battle.rapid_repair_percent), left+Vector2(0,274), 18, MUTED)
	var next_bonus: int = battle.points_to_next_bonus()
	_text("NEXT BONUS IN  %d PTS" % next_bonus, left+Vector2(0,306), 18, MUTED)
	var side := Vector2(size.x-372,208)
	var multiplier: float = battle.score_multiplier()
	_text("TARGET VALUES" if is_equal_approx(multiplier, 1.0) else "TARGET VALUES  x%.2f" % multiplier, side, 19, MUTED)
	_text("RAIDER", side+Vector2(0,46), 20, TEXT)
	_text(str(battle.points_for(battle.fighter_points)), side+Vector2(220,46), 20, TEXT)
	_text("HEAVY RAIDER", side+Vector2(0,86), 20, TEXT)
	_text(str(battle.points_for(battle.heavy_raider_points)), side+Vector2(220,86), 20, TEXT)
	_text("NUCLEAR", side+Vector2(0,126), 20, TEXT)
	_text(str(battle.points_for(battle.nuclear_points)), side+Vector2(220,126), 20, TEXT)
	_text("BASESTAR", side+Vector2(0,166), 20, TEXT)
	_text(str(battle.points_for(battle.basestar_points)), side+Vector2(220,166), 20, TEXT)
	_text("RESURRECTION", side+Vector2(0,206), 20, TEXT)
	_text(str(battle.points_for(battle.resurrection_points)), side+Vector2(220,206), 20, TEXT)
	# 1.05: points for each missile the Defense Battery destroys.
	_text("MISSILE", side+Vector2(0,246), 20, TEXT)
	_text(str(battle.points_for(battle.battery_kill_points)), side+Vector2(220,246), 20, TEXT)
	var low := 40.0  # everything below the new MISSILE row moves down one row
	draw_line(side+Vector2(0,234+low),side+Vector2(280,234+low),EDGE,1.0)
	_text("FTL COST",side+Vector2(0,274+low),19,MUTED)
	_text("-%d POINTS" % battle.ftl_score_cost,side+Vector2(0,316+low),26,TEXT)
	draw_line(side+Vector2(0,344+low),side+Vector2(280,344+low),EDGE,1.0)
	_text("THREAT WAVE  |  %s" % ["EASY", "NORMAL", "HARD"][clampi(battle.active_difficulty, 0, 2)],side+Vector2(0,384+low),19,MUTED)
	_text("WAVE %d" % battle.wave,side+Vector2(0,428+low),30,TEXT)
	if battle.waves_enabled:
		var left_seconds := ceili(battle.seconds_to_next_wave())
		_text("NEXT WAVE IN  %d:%02d" % [int(left_seconds / 60.0), left_seconds % 60],side+Vector2(0,462+low),18,MUTED)
	var res: Dictionary = battle.resurrection_ship()
	if not res.is_empty():
		var hostile := Color(1.0, 0.36, 0.42)
		_text("RESURRECTION SHIP",side+Vector2(0,516+low),19,hostile)
		_text("STRENGTH  %d%%" % ceili(100.0 * res.hits_remaining / res.max_hits),side+Vector2(0,550+low),20,TEXT)
		var barrage := "FIRING BARRAGE" if res.barrage_left > 0 else "NEXT BARRAGE  %ds" % ceili(res.barrage_timer)
		_text(barrage,side+Vector2(0,580+low),18,Color("#ffe28b"))
	_draw_bonus_lines()
	if get_parent().development_build:
		_text("DRADIS  %d dB" % int(get_parent().sweep_volume_db), Vector2(82,size.y-132),18,MUTED)
		_text("F1  TUNING PANEL",Vector2(size.x-290,size.y-132),18,MUTED)
	_draw_hack_box()

## 1.05: steady bonus lines just below the SCORE box, right-aligned with it,
## above TARGET VALUES. No flashing, so the contacts keep the attention.
func bonus_line_positions() -> Array[Vector2]:
	var spots: Array[Vector2] = []
	var names: Array[String] = battle.active_bonus_names()
	for index in range(names.size()):
		var width := ThemeDB.fallback_font.get_string_size(names[index], HORIZONTAL_ALIGNMENT_LEFT, -1, BONUS_FONT_SIZE).x
		spots.append(Vector2(size.x - 82.0 - width, BONUS_TOP + index * BONUS_LINE_STEP))
	return spots

func _draw_bonus_lines() -> void:
	var names: Array[String] = battle.active_bonus_names()
	var spots := bonus_line_positions()
	for index in range(names.size()):
		_text(names[index], spots[index], BONUS_FONT_SIZE, BONUS_COLOR)

func _draw_hack_box() -> void:
	# Chamfered alert box around the hacking warning; flashes during a hack.
	var state: String = battle.hack_state()
	if state == "" or state == "approach":
		return
	var alert: Label = get_parent().get_node("HackAlert")
	var text_height := float(alert.get_line_count() * alert.get_line_height())
	var r := Rect2(alert.position - Vector2(10, 8), Vector2(alert.size.x + 20, text_height + 16))
	var blink: bool = int(battle.battle_time * 4.0) % 2 == 0
	var color := Color(1.0, 0.2, 0.26) if blink or state == "draining" else Color(1.0, 0.78, 0.25)
	var c := 10.0
	var box := PackedVector2Array([r.position + Vector2(c,0), Vector2(r.end.x-c, r.position.y),
		Vector2(r.end.x, r.position.y+c), r.end - Vector2(0,c), r.end - Vector2(c,0),
		Vector2(r.position.x+c, r.end.y), Vector2(r.position.x, r.end.y-c), r.position + Vector2(0,c),
		r.position + Vector2(c,0)])
	draw_colored_polygon(box, Color(color, 0.08))
	draw_polyline(box, color, FRAME_WIDTH, true)

func _text(value: String, position: Vector2, font_size: int, color: Color) -> void:
	draw_string(ThemeDB.fallback_font, position, value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
