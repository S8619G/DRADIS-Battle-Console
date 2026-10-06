extends Control
##
## DRADIS Console - top-level scene.
##
## Hosts the animated dome, sample contacts, gameplay buttons, and the
## live tuning panel (press F1 to toggle).
##

const HighScores = preload("res://scripts/HighScores.gd")
const GameSettings = preload("res://scripts/GameSettings.gd")
const SettingsPanel = preload("res://scripts/SettingsPanel.gd")
const SessionLog = preload("res://scripts/SessionLog.gd")

@export_group("Audio Mix")
@export_range(-40.0, 0.0) var sweep_volume_db: float = -20.0

@export_group("Build")
## Tick to show the DRADIS level and F1 hint and allow the F1 tuning panel (tuning only).
## Off by default from 1.04, so normal play and exported builds hide both labels and F1.
@export var development_build: bool = false
## Test builds add "TEST" to the version shown in Settings and in the session log.
## Off from 1.06 (full builds). The number itself comes from Project Settings >
## Application > Config > Version.
@export var test_build: bool = false
## Pop-up help text when the mouse rests on a button. Off from 1.06, because the
## pop-ups covered the button text. The help text is kept; tick to show it again.
@export var show_hover_tooltips: bool = false
## How quickly the score display counts up toward the real score.
@export_range(1.0, 20.0) var score_count_speed: float = 6.0

@export_group("Display")
## F11 switches between a window and full screen (Esc also leaves full screen).
## On a Mac keyboard you may need Fn-F11.
@export var fullscreen_key_enabled: bool = true
## At startup, size the window to the screen it opens on, so high-resolution
## (4K, Retina) screens do not get a small window. Keeps the 16:9 shape.
@export var fit_window_to_screen: bool = true
## Share of the usable screen (inside the menu bar, taskbar and Dock) the window fills.
@export_range(0.5, 1.0) var window_screen_fraction: float = 0.85

@export_group("Settings")
## Player choices from the gear icon (volumes, mutes, difficulty, auto options).
@export var settings_file: String = "user://dradis_settings.cfg"
## Starting Effects volume for a new player. 50% is about 6 dB quieter than before.
@export_range(0, 100, 5) var default_effects_volume: int = 50
## Starting DRADIS volume. 100% keeps the approved -20 dB sweep level.
@export_range(0, 100, 5) var default_dradis_volume: int = 100
## Gear icon position and size in the header (1920 x 1080 layout).
@export var gear_rect := Rect2(1480, 50, 60, 60)

@export_group("Diagnostic Log")
## 1.05 session log in the app data "logs" folder (click the version text in Settings).
## Stays on in final builds; holds no personal data.
@export var session_log_enabled: bool = true
## Seconds between HEARTBEAT lines.
@export_range(2.0, 120.0) var log_heartbeat_seconds: float = 10.0
## A gap this long without a drawn frame is logged as a STALL.
@export_range(0.5, 30.0) var log_stall_seconds: float = 2.0
## How many session files to keep (oldest are deleted).
@export_range(1, 50) var log_keep_files: int = 10

@export_group("High Scores")
## Saved in Godot's user data folder, so scores persist between runs.
@export var high_score_file: String = "user://dradis_high_scores.json"
@export_range(3, 20) var high_score_slots: int = 10

var shown_score: float = 0.0
var was_defeated: bool = false
var entry_active: bool = false
var entry_letters: Array[int] = [0, 0, 0]
var entry_slot: int = 0
var board: Dictionary = {"scores": [], "last_initials": "AAA", "note": ""}
var highlight_row: int = -1
var score_rows: Array[Array] = []
var settings: Dictionary = GameSettings.DEFAULTS.duplicate()
var settings_open: bool = false
var settings_saved: bool = true
var gear_button: Button
var screen_flash: ColorRect
var settings_panel: Control
var _contacts_were_processing: bool = true
var game_over_quit_button: Button
## Tests set this so QUIT is recorded without closing the program.
var quit_dry_run: bool = false
var quit_requests: int = 0
var fitted_window_size := Vector2i.ZERO
## 1.05 diagnostic session log (see scripts/SessionLog.gd).
var session_log: Node
## Tests set this so opening the log folder is recorded without opening a window.
var shell_dry_run: bool = false
var log_folder_opens: int = 0

@onready var dome: Control = $CenterContainer/Dome
@onready var tuning_panel: Panel = $TuningPanel
@onready var sweep_loop: AudioStreamPlayer = $SweepLoop
@onready var contacts: Control = $CenterContainer/Dome/Contacts
@onready var launch_button: Button = $BottomButtons/LaunchVipers
@onready var ftl_button: Button = $BottomButtons/FTLJump
@onready var prox_button: Button = $BottomButtons/ProxDefense
@onready var firewall_button: Button = $BottomButtons/Firewall
@onready var battle_readout: Label = $BattleReadout
@onready var battle_status: Label = $BattleStatus
@onready var restart_button: Button = $CenterContainer/Dome/GameOverPanel/Retry
@onready var game_over_panel: Panel = $CenterContainer/Dome/GameOverPanel
@onready var raptor_button: Button = $BottomButtons/LaunchRaptor
@onready var nuclear_alert: Label = $NuclearAlert
@onready var repair_button: Button = $BottomButtons/RapidRepair
@onready var score_label: Label = $ScoreValue
## 1.07: right half of the split FIREWALL button, shown only while the EMP is offered.
var emp_split_button: Button
var firewall_split := false

func _ready() -> void:
	tuning_panel.visible = false  # F1 opens tuning without obscuring the game HUD.
	_wire_tuning_controls()
	_ensure_audio_loops()
	_build_high_score_board()
	_center_title()
	_build_settings()
	_build_game_over_quit()
	_apply_tooltip_setting(self)
	$ShipStatus.emp_used.connect(func() -> void: log_event("EMP used | %d charge%s left" % [contacts.emp_charges, "" if contacts.emp_charges == 1 else "s"]))
	_build_emp_split_button()
	# Only when this console is the running game (not inside a test script).
	call_deferred("_fit_window_on_start")

# ------------------------------------------------------------------
# Settings (gear icon, top right): volumes, mutes, difficulty, auto options.
# ------------------------------------------------------------------
func _build_settings() -> void:
	var defaults := GameSettings.DEFAULTS.duplicate()
	defaults.effects_volume = default_effects_volume
	defaults.dradis_volume = default_dradis_volume
	# With Remember Settings OFF, difficulty and the auto options start from their defaults.
	settings = GameSettings.startup(GameSettings.load_settings(settings_file, defaults), defaults)
	# Sounds play through two buses so each slider keeps the existing balance.
	sweep_loop.bus = GameSettings.DRADIS_BUS
	for player in find_children("*", "AudioStreamPlayer", true, false):
		if player != sweep_loop:
			player.bus = GameSettings.EFFECTS_BUS
	if not get_tree().node_added.is_connected(_on_node_added):
		get_tree().node_added.connect(_on_node_added)
	_apply_settings()
	contacts.active_difficulty = contacts.difficulty  # first battle uses the saved choice
	# Brief warm flash over the console when a nuke explodes (strength set on Contacts).
	screen_flash = ColorRect.new()
	screen_flash.name = "ScreenFlash"
	screen_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	screen_flash.color = Color(1.0, 0.9, 0.74, 0.0)
	var glow := CanvasItemMaterial.new()
	glow.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	screen_flash.material = glow
	add_child(screen_flash)
	move_child(screen_flash, tuning_panel.get_index())
	gear_button = Button.new()
	gear_button.name = "SettingsGear"
	gear_button.icon = _gear_icon()
	gear_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gear_button.expand_icon = false
	_tip(gear_button, "Settings: volume, difficulty, auto options and Quit")
	gear_button.position = gear_rect.position
	gear_button.size = gear_rect.size
	gear_button.pressed.connect(toggle_settings)
	add_child(gear_button)
	move_child(gear_button, tuning_panel.get_index())
	settings_panel = SettingsPanel.new()
	settings_panel.name = "SettingsPanel"
	settings_panel.contacts = contacts
	settings_panel.defaults = defaults
	settings_panel.show_tooltips = show_hover_tooltips
	add_child(settings_panel)
	move_child(settings_panel, tuning_panel.get_index())
	settings_panel.changed.connect(_on_settings_changed)
	settings_panel.close_requested.connect(close_settings)
	settings_panel.new_battle_requested.connect(_on_new_battle_from_settings)
	settings_panel.effects_preview.connect(_preview_effects)
	settings_panel.quit_requested.connect(quit_game)
	settings_panel.open_logs_requested.connect(open_log_folder)
	settings_panel.version_text = version_text()
	# One line in Godot's log file per start, to help match a log to a build.
	print("[DRADIS] DRADIS Battle Console %s | %s | difficulty %s | auto options %d | remember settings %s" % [
		ProjectSettings.get_setting("application/config/version", "?"), OS.get_name(),
		GameSettings.DIFFICULTY_NAMES[settings.difficulty], contacts.auto_options_on(),
		"on" if settings.remember_settings else "off"])
	_start_session_log()

# ------------------------------------------------------------------
# Version text and diagnostic session log (1.05)
# ------------------------------------------------------------------
## Sets a button's hover help text; it is shown only with Show Hover Tooltips (1.06).
func _tip(control: Control, text: String) -> void:
	control.set_meta("hover_tip", text)
	control.tooltip_text = text if show_hover_tooltips else ""

## Scene buttons with help text typed in the editor follow the same switch.
func _apply_tooltip_setting(root: Node) -> void:
	for node in root.find_children("*", "Control", true, false):
		var control := node as Control
		if not control.tooltip_text.is_empty():
			control.set_meta("hover_tip", control.tooltip_text)
			if not show_hover_tooltips:
				control.tooltip_text = ""

## For example "DRADIS BATTLE CONSOLE 1.06" (number from the project's version setting).
func version_text() -> String:
	return "DRADIS BATTLE CONSOLE %s%s" % [ProjectSettings.get_setting("application/config/version", "?"), " TEST" if test_build else ""]

func _start_session_log() -> void:
	session_log = SessionLog.new()
	session_log.name = "SessionLog"
	session_log.enabled = session_log_enabled
	session_log.heartbeat_seconds = log_heartbeat_seconds
	session_log.stall_seconds = log_stall_seconds
	session_log.keep_files = log_keep_files
	add_child(session_log)
	session_log.start(self)
	session_log.write_start(version_text(), settings, GameSettings.DIFFICULTY_NAMES[settings.difficulty], contacts.auto_options_on())
	contacts.wave_changed.connect(func(number: int) -> void: log_event("wave %d" % number))
	contacts.ftl_jumped.connect(func() -> void: log_event("FTL jump | hull %d%% | auto %s" % [roundi(contacts.hull), "yes" if contacts.auto_ftl else "no"]))

## Writes one EVENT line to the session log (no-op when logging is off).
func log_event(text: String) -> void:
	if is_instance_valid(session_log):
		session_log.event("%s | battle %.1fs" % [text, contacts.battle_time])

## Settings version link: shows the session logs in Finder or Explorer.
func open_log_folder() -> int:
	log_folder_opens += 1
	var path: String = session_log.folder_path() if is_instance_valid(session_log) else ProjectSettings.globalize_path("user://logs")
	DirAccess.make_dir_recursive_absolute(path)
	log_event("open log folder")
	if shell_dry_run:
		return OK
	return OS.shell_open(path)

func _on_node_added(node: Node) -> void:
	if node is AudioStreamPlayer and node != sweep_loop and is_ancestor_of(node):
		node.bus = GameSettings.EFFECTS_BUS

func _apply_settings() -> void:
	GameSettings.apply_audio(settings)
	contacts.difficulty = settings.difficulty
	contacts.auto_defense_battery = settings.auto_battery
	contacts.auto_firewall = settings.auto_firewall
	contacts.auto_launch_vipers = settings.auto_vipers
	contacts.auto_launch_raptors = settings.auto_raptors
	contacts.auto_ftl = settings.auto_ftl
	contacts.auto_rapid_repair = settings.auto_repair

func _on_settings_changed(new_settings: Dictionary) -> void:
	var old_difficulty: int = settings.difficulty
	settings = GameSettings.clean(new_settings)
	if settings.difficulty != old_difficulty:
		log_event("difficulty %s (next battle)" % GameSettings.DIFFICULTY_NAMES[settings.difficulty])
	_apply_settings()
	settings_saved = GameSettings.save_settings(settings_file, settings)

func toggle_settings() -> void:
	if settings_open:
		close_settings()
	else:
		open_settings()

func open_settings() -> void:
	if settings_open:
		return
	settings_open = true
	_contacts_were_processing = contacts.is_processing()
	contacts.set_process(false)
	_pause_effects(true)
	settings_panel.open(settings, contacts.active_difficulty)
	log_event("settings opened")

func close_settings() -> void:
	if not settings_open:
		return
	settings_open = false
	settings_panel.visible = false
	contacts.set_process(_contacts_were_processing)
	_pause_effects(false)
	gear_button.grab_focus()
	log_event("settings closed")

func _pause_effects(paused: bool) -> void:
	for player in find_children("*", "AudioStreamPlayer", true, false):
		if player != sweep_loop:
			player.stream_paused = paused

func _preview_effects() -> void:
	# Short sample beep so the Effects level can be heard while paused.
	var player: AudioStreamPlayer = contacts.arrival_player
	if is_instance_valid(player) and player.stream:
		player.stream_paused = false
		player.play()

# ------------------------------------------------------------------
# Quit (Settings panel and Game Over panel)
# ------------------------------------------------------------------
func _build_game_over_quit() -> void:
	# A copy of Retry (same look), placed beside it. Retry shifts left to make room.
	game_over_quit_button = restart_button.duplicate(Node.DUPLICATE_GROUPS | Node.DUPLICATE_SCRIPTS) as Button
	game_over_quit_button.name = "Quit"
	game_over_quit_button.text = "Quit"
	game_over_panel.add_child(game_over_quit_button)
	restart_button.position.x = 90.0
	game_over_quit_button.position = Vector2(310.0, restart_button.position.y)
	game_over_quit_button.size = restart_button.size
	game_over_quit_button.pressed.connect(quit_game)

## Saves a pending high score (as Retry does) and the settings, then closes the program.
func quit_game() -> void:
	if entry_active:
		submit_initials()
	settings_saved = GameSettings.save_settings(settings_file, settings)
	quit_requests += 1
	log_event("quit | score %d" % contacts.score)
	if is_instance_valid(session_log) and not quit_dry_run:
		session_log.stop("quit")
	if quit_dry_run:
		return
	get_tree().quit()

# ------------------------------------------------------------------
# Window size from the screen resolution (high-resolution screens)
# ------------------------------------------------------------------
## Largest 16:9 size that fits inside the given share of the usable screen area.
static func window_size_for(usable: Vector2i, fraction: float) -> Vector2i:
	var room := Vector2(usable) * clampf(fraction, 0.5, 1.0)
	var width := minf(room.x, room.y * 16.0 / 9.0)
	return Vector2i(maxi(640, roundi(width)), maxi(360, roundi(width * 9.0 / 16.0)))

func _fit_window_on_start() -> void:
	if not is_inside_tree() or get_tree().current_scene != self:
		return
	fit_window()

func fit_window() -> Vector2i:
	if not fit_window_to_screen or DisplayServer.get_name() == "headless" or is_fullscreen():
		return Vector2i.ZERO
	if Engine.has_method("is_embedded_in_editor") and Engine.call("is_embedded_in_editor"):
		return Vector2i.ZERO  # running inside the editor's Game tab; the editor sizes it
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		return Vector2i.ZERO
	var screen := DisplayServer.window_get_current_screen()
	var usable := DisplayServer.screen_get_usable_rect(screen)
	if usable.size.x <= 0 or usable.size.y <= 0:
		return Vector2i.ZERO
	var target := window_size_for(usable.size, window_screen_fraction)
	DisplayServer.window_set_size(target)
	DisplayServer.window_set_position(usable.position + (usable.size - target) / 2)
	fitted_window_size = target
	return target

func _on_new_battle_from_settings() -> void:
	close_settings()
	_on_restart_pressed()

func _gear_icon() -> Texture2D:
	# Eight-tooth gear in the console's pink, drawn as a small SVG.
	var points := PackedStringArray()
	for i in range(16):
		var angle := TAU * (i + 0.5) / 16.0
		var tooth := i % 2 == 0
		for edge in [-0.13, 0.13]:
			var a: float = angle + edge
			var r := 15.0 if tooth else 11.5
			points.append("%.2f,%.2f" % [18.0 + cos(a) * r, 18.0 + sin(a) * r])
	var svg := '<svg xmlns="http://www.w3.org/2000/svg" width="36" height="36"><polygon points="%s" fill="#ff99c7"/><circle cx="18" cy="18" r="5" fill="#0b0609"/></svg>' % " ".join(points)
	var image := Image.new()
	if image.load_svg_from_string(svg, 1.0) != OK:
		return null
	return ImageTexture.create_from_image(image)

func _center_title() -> void:
	# Center DRADIS over the TACTICAL DEFENSE CONSOLE line beneath it.
	var sub: Label = $Subtitle
	var title: Label = $TopChrome
	var width := sub.get_theme_font("font").get_string_size(sub.text, HORIZONTAL_ALIGNMENT_LEFT, -1, sub.get_theme_font_size("font_size")).x
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.anchor_left = sub.anchor_left
	title.anchor_right = sub.anchor_left
	title.offset_left = sub.offset_left
	title.offset_right = sub.offset_left + width

func _process(delta: float) -> void:
	sweep_loop.volume_db = sweep_volume_db
	_update_score_display(delta)
	var cooling: bool = contacts.launch_cooldown_remaining > 0.0
	var full: bool = contacts.count_vipers() >= contacts.max_vipers
	launch_button.disabled = cooling or full or contacts.is_defeated() or contacts.safe_remaining > 0.0
	var viper_tag := "AUTO " if contacts.auto_launch_vipers else ""
	if cooling:
		launch_button.text = "LAUNCH VIPERS\n%sREADY IN %ds" % [viper_tag, ceili(contacts.launch_cooldown_remaining)]
	elif full:
		launch_button.text = "LAUNCH VIPERS\n%sALL DEPLOYED" % viper_tag
	else:
		launch_button.text = "LAUNCH VIPERS\n%s2 PER LAUNCH" % viper_tag
	_tip(launch_button, "Launch interceptors from below. Active: %d / %d" % [contacts.count_vipers(), contacts.max_vipers])
	ftl_button.disabled = not contacts.can_jump()
	var ftl_tag := "AUTO " if contacts.auto_ftl else ""
	ftl_button.text = ("FTL JUMP\n%s-%d POINTS" % [ftl_tag, contacts.ftl_score_cost]) if contacts.ftl_recharge_remaining <= 0.0 else "FTL JUMP\n%sCHARGING %ds" % [ftl_tag, ceili(contacts.ftl_recharge_remaining)]
	_tip(ftl_button, "Escape for %d points (score cannot go below zero). Damage and remaining defense reserve are retained." % contacts.ftl_score_cost)
	prox_button.disabled = not contacts.can_fire_battery()
	prox_button.set_pressed_no_signal(contacts.prox_active)
	var charge := int(contacts.battery_percent())
	var auto_tag := "AUTO " if contacts.auto_defense_battery else ""
	if contacts.prox_active:
		prox_button.text = "DEFENSE BATTERY\n%sFIRING %d%%" % [auto_tag, charge]
	elif charge >= 100:
		prox_button.text = "DEFENSE BATTERY\n%sREADY 100%%" % auto_tag
	else:
		prox_button.text = "DEFENSE BATTERY\n%sRECHARGING %d%%" % [auto_tag, charge]
	_tip(prox_button, "Toggle firing on/off. Charge drains quickly while firing and recharges slowly when stopped. Standard missiles only; cannot hurt Heavy Raiders or nukes.")
	firewall_button.disabled = not contacts.can_deploy_firewall()
	firewall_button.set_pressed_no_signal(contacts.firewall_active)
	var shield := int(contacts.firewall_percent())
	var wall_tag := "AUTO " if contacts.auto_firewall else ""
	if contacts.firewall_active:
		firewall_button.text = "FIREWALL\n%sACTIVE %d%%" % [wall_tag, shield]
	elif shield < 100:
		firewall_button.text = "FIREWALL\n%sRECHARGING %d%%" % [wall_tag, shield]
	elif contacts.firewall_needed():
		firewall_button.text = "FIREWALL\n%sREADY 100%%" % wall_tag
	else:
		firewall_button.text = "FIREWALL\n%sSTANDBY" % wall_tag
	_tip(firewall_button, "Slows a Heavy Raider hack while deployed. Usable once a Heavy Raider starts hacking; used up in %d seconds, recharges in %d." % [int(contacts.firewall_seconds), int(contacts.firewall_recharge_seconds)])
	_update_emp_split(shield)
	raptor_button.disabled = contacts.is_defeated() or contacts.safe_remaining > 0.0 or contacts.raptor_cooldown_remaining > 0.0 or contacts.count_kind("raptor") >= contacts.max_raptors
	var raptor_tag := "AUTO " if contacts.auto_launch_raptors else ""
	raptor_button.text = "LAUNCH RAPTOR\n%s1 PER LAUNCH" % raptor_tag
	if contacts.count_kind("raptor") >= contacts.max_raptors:
		raptor_button.text = "LAUNCH RAPTOR\n%sALL DEPLOYED" % raptor_tag
	elif contacts.raptor_cooldown_remaining > 0.0:
		raptor_button.text = "LAUNCH RAPTOR\n%sREADY IN %ds" % [raptor_tag, ceili(contacts.raptor_cooldown_remaining)]
	_tip(raptor_button, "Launch one Raptor. Prioritizes nukes, then Heavy Raiders, then attacks Basestars with light missiles.")
	repair_button.disabled = not contacts.can_rapid_repair()
	var repair_tag := "AUTO " if contacts.auto_rapid_repair else ""
	if contacts.rapid_repair_remaining > 0.0:
		repair_button.text = "RAPID REPAIR\n%sREPAIRING %.1fs" % [repair_tag, contacts.rapid_repair_remaining]
	elif contacts.repair_charges <= 0:
		repair_button.text = "RAPID REPAIR\n%sNO CHARGES" % repair_tag
	else:
		repair_button.text = "RAPID REPAIR\n%s+%d%% / %d CHARGE%s" % [repair_tag, int(contacts.rapid_repair_percent), contacts.repair_charges, "" if contacts.repair_charges == 1 else "S"]
	_tip(repair_button, "Restore up to %d%% of maximum hull over %.1f seconds per charge. Bonus charges at %d, %d and %d earned points, then every %d more; FTL penalties do not reduce progress." % [int(contacts.rapid_repair_percent), contacts.rapid_repair_seconds, contacts.repair_bonus_threshold(1), contacts.repair_bonus_threshold(2), contacts.repair_bonus_threshold(3), contacts.later_bonus_step])
	score_label.text = str(int(shown_score))
	# Warm flash for nuke explosions, blue-white for an FTL jump (whichever is stronger).
	var warm: float = contacts.screen_flash_alpha()
	var jump: float = contacts.ftl_screen_alpha()
	if jump > warm:
		screen_flash.color = Color(0.7, 0.86, 1.0, jump)
	else:
		screen_flash.color = Color(1.0, 0.9, 0.74, warm)
	gear_button.set_pressed_no_signal(settings_open)
	$HeaderMetrics/Enemies/Value.text = str(contacts.count_kind("raider") + contacts.count_kind("heavy_raider"))
	$HeaderMetrics/Vipers/Value.text = "%d / %d" % [contacts.count_vipers(),contacts.max_vipers]
	$HeaderMetrics/Raptors/Value.text = "%d / %d" % [contacts.count_kind("raptor"),contacts.max_raptors]
	$HeaderMetrics/Basestars/Value.text = str(contacts.count_kind("baseship"))
	battle_readout.text = "INCOMING MISSILES  %d\nHEAVY RAIDERS  %d\nVIPERS RETURNING  %d\nVIPERS LOST  %d\nRAPTORS LOST  %d\nBASESTARS DESTROYED  %d\nEMP CHARGES  %d" % [
		contacts.count_kind("missile"), contacts.count_kind("heavy_raider"), contacts.count_returning("viper"), contacts.vipers_lost, contacts.raptors_lost, contacts.basestars_destroyed, contacts.emp_charges]
	$HackAlert.text = contacts.hacking_warning()
	$HackAlert.visible = not $HackAlert.text.is_empty()
	var hack_state: String = contacts.hack_state()
	var hack_blink: bool = int(contacts.battle_time * 4.0) % 2 == 0
	if hack_state == "draining":
		$HackAlert.modulate = Color(1.0, 0.25, 0.3) if hack_blink else Color(1.0, 0.55, 0.58)
	elif hack_state == "hacking":
		$HackAlert.modulate = Color(1.0, 0.25, 0.3) if hack_blink else Color(1.0, 0.78, 0.25)
	else:
		$HackAlert.modulate = Color(1.0, 0.78, 0.25)
	battle_status.text = contacts.status_message
	if contacts.safe_remaining > 0.0 and not contacts.is_defeated():
		battle_status.text += "   |   SAFE %ds" % ceili(contacts.safe_remaining)
	var defeated: bool = contacts.is_defeated()
	if defeated and not was_defeated:
		begin_game_over()
	elif not defeated and was_defeated:
		entry_active = false
	was_defeated = defeated
	game_over_panel.visible = defeated
	$CenterContainer/Dome/GameOverPanel/FinalScore.text = "FINAL SCORE  %d" % contacts.score
	if defeated:
		_refresh_high_score_panel()
	var nukes: int = contacts.count_kind("nuke")
	nuclear_alert.visible = nukes > 0 and not contacts.is_defeated()
	battle_status.visible = not nuclear_alert.visible
	nuclear_alert.text = "NUCLEAR MISSILE INBOUND (%d) | RAPTOR OR FTL JUMP" % nukes
	nuclear_alert.modulate = Color(1.0, 0.8, 0.2) if int(contacts.battle_time * 4.0) % 2 == 0 else Color(1.0, 0.15, 0.2)

# ------------------------------------------------------------------
# Load the sweep audio manually from the raw WAV file. This avoids
# depending on Godot's import pipeline — we read the WAV bytes ourselves,
# construct an AudioStreamWAV in code, and play it in an infinite loop.
# ------------------------------------------------------------------
func _ensure_audio_loops() -> void:
	print("[AUDIO] _ensure_audio_loops() starting...")
	if sweep_loop == null:
		push_error("[AUDIO] SweepLoop node MISSING - scene tree broken")
		return
	print("[AUDIO] SweepLoop node found: ", sweep_loop)

	var stream := _load_wav("res://assets/audio/dradis_sweep_loop.wav")
	if stream == null:
		push_error("[AUDIO] Failed to load dradis_sweep_loop.wav")
		return
	print("[AUDIO] WAV loaded - rate=", stream.mix_rate, " stereo=", stream.stereo,
		  " format=", stream.format, " bytes=", stream.data.size())

	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	# Runtime loop points are sample frames; zero would create an empty loop.
	var bytes_per_sample := 2 if stream.format == AudioStreamWAV.FORMAT_16_BITS else 1
	var channel_count := 2 if stream.stereo else 1
	stream.loop_end = int(stream.data.size() / float(bytes_per_sample * channel_count))
	print("[AUDIO] loop_mode set to LOOP_FORWARD; loop_end=", stream.loop_end)

	sweep_loop.stream = stream
	sweep_loop.volume_db = sweep_volume_db  # ambient background, not foreground
	sweep_loop.play()
	print("[AUDIO] play() called - playing=", sweep_loop.playing,
		  " volume_db=", sweep_loop.volume_db,
		  " bus=", sweep_loop.bus)

	# Fallback: if the loop ever ends (shouldn't with LOOP_FORWARD), restart it.
	if not sweep_loop.finished.is_connected(_on_sweep_finished):
		sweep_loop.finished.connect(_on_sweep_finished)

func _on_sweep_finished() -> void:
	if sweep_loop:
		sweep_loop.play()

# Exported games (.exe / .app) hold Godot's imported copy of each sound, not the
# raw .wav file. The .import settings keep it uncompressed 16-bit PCM, so the
# exported copy has exactly the same samples as the raw file.
static func load_exported_wav(path: String) -> AudioStreamWAV:
	var imported := load(path) as AudioStreamWAV
	if imported == null or imported.format != AudioStreamWAV.FORMAT_16_BITS:
		push_error("[AUDIO] Exported copy of %s is missing or not uncompressed PCM" % path)
		return null
	print("[AUDIO] Using exported copy of ", path)
	return imported.duplicate() as AudioStreamWAV

# Parse a minimal PCM WAV file into an AudioStreamWAV.
# Handles 16-bit mono/stereo PCM at any sample rate.
func _load_wav(path: String) -> AudioStreamWAV:
	print("[AUDIO] Opening ", path, " - exists=", FileAccess.file_exists(path))
	if not FileAccess.file_exists(path):
		return load_exported_wav(path)
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("[AUDIO] Cannot open %s (error=%d)" % [path, FileAccess.get_open_error()])
		return null
	var bytes := file.get_buffer(file.get_length())
	file.close()

	if bytes.size() < 44 or bytes.slice(0, 4).get_string_from_ascii() != "RIFF":
		push_error("Not a RIFF file: %s" % path)
		return null

	# Walk chunks starting at offset 12 (after RIFF header + WAVE tag)
	var i := 12
	var sample_rate := 0
	var channels := 1
	var bits := 16
	var data: PackedByteArray
	while i + 8 <= bytes.size():
		var tag := bytes.slice(i, i + 4).get_string_from_ascii()
		var chunk_size := int(bytes.decode_u32(i + 4))
		var payload_start := i + 8
		if tag == "fmt ":
			channels = bytes.decode_u16(payload_start + 2)
			sample_rate = bytes.decode_u32(payload_start + 4)
			bits = bytes.decode_u16(payload_start + 14)
		elif tag == "data":
			data = bytes.slice(payload_start, payload_start + chunk_size)
		i += 8 + chunk_size + (chunk_size & 1)

	if data.is_empty():
		push_error("No data chunk in %s" % path)
		return null

	var stream := AudioStreamWAV.new()
	stream.mix_rate = sample_rate
	stream.stereo = channels == 2
	stream.format = AudioStreamWAV.FORMAT_16_BITS if bits == 16 else AudioStreamWAV.FORMAT_8_BITS
	stream.data = data
	return stream

func _input(event: InputEvent) -> void:
	if settings_open and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		close_settings()
		get_viewport().set_input_as_handled()
		return
	if development_build and event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		tuning_panel.visible = not tuning_panel.visible
	if event is InputEventKey and event.pressed and not event.echo and fullscreen_key_enabled:
		if event.keycode == KEY_F11:
			toggle_fullscreen()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_ESCAPE and is_fullscreen():
			toggle_fullscreen()
			get_viewport().set_input_as_handled()
			return
	if entry_active and not settings_open and event is InputEventKey and event.pressed:
		if _handle_entry_key(event):
			get_viewport().set_input_as_handled()

# ------------------------------------------------------------------
# Full screen (F11)
# ------------------------------------------------------------------
func is_fullscreen() -> bool:
	var mode := DisplayServer.window_get_mode()
	return mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

func toggle_fullscreen() -> void:
	if is_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# ------------------------------------------------------------------
# Arcade high score board on Game Over: top 10, three upper-case initials.
# Mouse: click the arrows above/below each letter, then ENTER.
# Keyboard: type letters, or Up/Down to change and Left/Right to move; Enter saves.
# ------------------------------------------------------------------
func _build_high_score_board() -> void:
	var rows: Control = $CenterContainer/Dome/GameOverPanel/Rows
	for child in rows.get_children():
		child.queue_free()
	score_rows.clear()
	for index in range(high_score_slots):
		var row: Array = []
		for column in range(4):
			var label := Label.new()
			label.add_theme_font_size_override("font_size", 19)
			label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			label.position = Vector2([0.0, 60.0, 130.0, 300.0][column], index * 26.0)
			label.size = Vector2([50.0, 70.0, 160.0, 80.0][column], 26.0)
			label.horizontal_alignment = [HORIZONTAL_ALIGNMENT_RIGHT, HORIZONTAL_ALIGNMENT_LEFT, HORIZONTAL_ALIGNMENT_RIGHT, HORIZONTAL_ALIGNMENT_RIGHT][column]
			rows.add_child(label)
			row.append(label)
		score_rows.append(row)
	var entry: Control = $CenterContainer/Dome/GameOverPanel/Entry
	var up_icon := _arrow_icon(true)
	var down_icon := _arrow_icon(false)
	for slot in range(3):
		var up: Button = entry.get_node("Up%d" % slot)
		var down: Button = entry.get_node("Down%d" % slot)
		up.icon = up_icon
		down.icon = down_icon
		up.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		down.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		up.pressed.connect(change_letter.bind(slot, 1))
		down.pressed.connect(change_letter.bind(slot, -1))
	entry.get_node("Enter").pressed.connect(submit_initials)
	board = HighScores.load_board(high_score_file, high_score_slots)

func _arrow_icon(pointing_up: bool) -> Texture2D:
	# The built-in font has no arrow characters, so draw a small smooth triangle.
	var points := "2,12 9,3 16,12" if pointing_up else "2,3 9,12 16,3"
	var svg := '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="15"><polygon points="%s" fill="#ede0e8"/></svg>' % points
	var image := Image.new()
	if image.load_svg_from_string(svg, 1.0) != OK:
		return null
	return ImageTexture.create_from_image(image)

func begin_game_over() -> void:
	board = HighScores.load_board(high_score_file, high_score_slots)
	highlight_row = -1
	entry_slot = 0
	var last := HighScores.clean_initials(board.last_initials)
	for slot in range(3):
		entry_letters[slot] = HighScores.LETTERS.find(last[slot])
	entry_active = HighScores.qualifies(board.scores, contacts.score, high_score_slots)
	_refresh_high_score_panel()
	log_event("game over | score %d | wave %d" % [contacts.score, contacts.wave])

func entry_initials() -> String:
	var text := ""
	for slot in range(3):
		text += HighScores.LETTERS[posmod(entry_letters[slot], 26)]
	return text

func change_letter(slot: int, step: int) -> void:
	if not entry_active:
		return
	entry_slot = clampi(slot, 0, 2)
	entry_letters[entry_slot] = posmod(entry_letters[entry_slot] + step, 26)
	_refresh_high_score_panel()

func submit_initials() -> int:
	if not entry_active:
		return -1
	entry_active = false
	highlight_row = HighScores.insert(board.scores, entry_initials(), contacts.score, contacts.wave, high_score_slots, contacts.difficulty_letter())
	board.last_initials = entry_initials()
	if not HighScores.save_board(high_score_file, board.scores, board.last_initials):
		board.note = "HIGH SCORE COULD NOT BE SAVED"
	_refresh_high_score_panel()
	restart_button.grab_focus()
	return highlight_row

func _handle_entry_key(event: InputEventKey) -> bool:
	match event.keycode:
		KEY_UP:
			change_letter(entry_slot, 1)
		KEY_DOWN:
			change_letter(entry_slot, -1)
		KEY_LEFT, KEY_BACKSPACE:
			entry_slot = maxi(0, entry_slot - 1)
		KEY_RIGHT:
			entry_slot = mini(2, entry_slot + 1)
		KEY_ENTER, KEY_KP_ENTER:
			submit_initials()
		_:
			var typed := String.chr(event.unicode).to_upper() if event.unicode > 0 else ""
			if typed.length() != 1 or not HighScores.LETTERS.contains(typed):
				return false
			entry_letters[entry_slot] = HighScores.LETTERS.find(typed)
			entry_slot = mini(2, entry_slot + 1)
	_refresh_high_score_panel()
	return true

func _refresh_high_score_panel() -> void:
	var panel := game_over_panel
	var blink: bool = int(Time.get_ticks_msec() / 250.0) % 2 == 0
	panel.get_node("Entry").visible = entry_active
	var prompt: Label = panel.get_node("EntryPrompt")
	if entry_active:
		prompt.text = "NEW HIGH SCORE  |  ENTER YOUR INITIALS"
	elif highlight_row >= 0:
		prompt.text = "SAVED  |  RANK %d" % (highlight_row + 1)
	elif not str(board.get("note", "")).is_empty():
		prompt.text = board.note
	else:
		prompt.text = "SCORE DID NOT REACH THE TOP %d" % high_score_slots
	for slot in range(3):
		var letter: Label = panel.get_node("Entry/Letter%d" % slot)
		letter.text = HighScores.LETTERS[posmod(entry_letters[slot], 26)]
		var active := slot == entry_slot
		letter.add_theme_color_override("font_color", Color(1.0, 0.89, 0.55) if active and blink else (Color(1.0, 0.89, 0.55, 0.75) if active else Color(0.93, 0.88, 0.91)))
	panel.get_node("BoardTitle").text = "TOP %d HIGH SCORES" % high_score_slots
	for index in range(score_rows.size()):
		var row: Array = score_rows[index]
		var has_entry: bool = index < board.scores.size()
		var entry: Dictionary = board.scores[index] if has_entry else {}
		row[0].text = "%d." % (index + 1)
		row[1].text = entry.initials if has_entry else "---"
		row[2].text = str(entry.score) if has_entry else ""
		row[3].text = ("W%d %s" % [entry.wave, entry.get("difficulty", "N")]) if has_entry else ""
		var color := Color(0.93, 0.88, 0.91) if has_entry else Color(0.45, 0.40, 0.44)
		if index == highlight_row:
			color = Color(1.0, 0.89, 0.55) if blink else Color(1.0, 0.6, 0.78)
		for column in range(4):
			row[column].add_theme_color_override("font_color", color if column != 3 else Color(color, 0.7))

func _update_score_display(delta: float) -> void:
	# Count toward the real score instead of jumping; Retry snaps back to zero.
	var target := float(contacts.score)
	if contacts.score == 0 and contacts.earned_points == 0:
		shown_score = 0.0
		return
	var gap := target - shown_score
	var step := maxf(absf(gap) * score_count_speed, 120.0) * maxf(0.0, delta)
	shown_score = target if absf(gap) <= step else shown_score + signf(gap) * step

# ------------------------------------------------------------------
# Wire the tuning sliders/checkboxes to dome properties. Every change
# updates the animation immediately — no restart needed.
# ------------------------------------------------------------------
func _wire_tuning_controls() -> void:
	var vbox: VBoxContainer = tuning_panel.get_node("VBox")

	# Ring count
	var ring_count_slider: HSlider = vbox.get_node("RingCount/Slider")
	ring_count_slider.value = dome.ring_count
	ring_count_slider.value_changed.connect(func(v):
		dome.ring_count = int(v)
		vbox.get_node("RingCount/Value").text = str(int(v))
	)
	vbox.get_node("RingCount/Value").text = str(dome.ring_count)

	# Rotation speed (seconds per full rotation)
	var speed_slider: HSlider = vbox.get_node("Speed/Slider")
	speed_slider.value = dome.ring_rotation_seconds
	speed_slider.value_changed.connect(func(v):
		dome.ring_rotation_seconds = v
		vbox.get_node("Speed/Value").text = "%.1fs" % v
	)
	vbox.get_node("Speed/Value").text = "%.1fs" % dome.ring_rotation_seconds

	# Hinged mode
	var hinged_check: CheckBox = vbox.get_node("Hinged/Check")
	hinged_check.button_pressed = dome.rings_hinged_at_top
	hinged_check.toggled.connect(func(pressed):
		dome.rings_hinged_at_top = pressed
	)

	# Ring A tilt
	var a_slider: HSlider = vbox.get_node("RingATilt/Slider")
	a_slider.value = dome.ring_a_axis_tilt_deg
	a_slider.value_changed.connect(func(v):
		dome.ring_a_axis_tilt_deg = v
		vbox.get_node("RingATilt/Value").text = "%d°" % int(v)
	)
	vbox.get_node("RingATilt/Value").text = "%d°" % int(dome.ring_a_axis_tilt_deg)

	# Ring B tilt
	var b_slider: HSlider = vbox.get_node("RingBTilt/Slider")
	b_slider.value = dome.ring_b_axis_tilt_deg
	b_slider.value_changed.connect(func(v):
		dome.ring_b_axis_tilt_deg = v
		vbox.get_node("RingBTilt/Value").text = "%d°" % int(v)
	)
	vbox.get_node("RingBTilt/Value").text = "%d°" % int(dome.ring_b_axis_tilt_deg)

	# Sphere visibility
	var sphere_check: CheckBox = vbox.get_node("Sphere/Check")
	sphere_check.button_pressed = dome.sphere_visible
	sphere_check.toggled.connect(func(pressed):
		dome.sphere_visible = pressed
	)

	# Ripples visibility
	var ripple_check: CheckBox = vbox.get_node("Ripples/Check")
	ripple_check.button_pressed = dome.ripples_visible
	ripple_check.toggled.connect(func(pressed):
		dome.ripples_visible = pressed
	)

	# Scanlines visibility
	var scan_check: CheckBox = vbox.get_node("Scanlines/Check")
	scan_check.button_pressed = dome.scanlines_visible
	scan_check.toggled.connect(func(pressed):
		dome.scanlines_visible = pressed
	)

# ------------------------------------------------------------------
# Launch, proximity defense and FTL are functional. HAIL is still a placeholder.
# ------------------------------------------------------------------
func _on_rapid_repair_pressed() -> void:
	contacts.request_rapid_repair()

func _on_ftl_jump_pressed() -> void:
	if contacts.request_ftl_jump():
		print("[FTL] Jump complete; hull retained=", contacts.hull)

func _on_prox_defense_toggled(enabled: bool) -> void:
	contacts.set_prox_defense(enabled)

# ------------------------------------------------------------------
# 1.07: the FIREWALL button splits into FIREWALL | EMP while the EMP is offered
# (a Heavy Raider hacking, a charge ready, and the Firewall out for 2 seconds).
# ------------------------------------------------------------------
func _build_emp_split_button() -> void:
	emp_split_button = Button.new()
	emp_split_button.name = "EmpSplitButton"
	emp_split_button.focus_mode = Control.FOCUS_NONE
	emp_split_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var blue: Color = $ShipStatus.emp_blue
	for state in ["normal", "hover", "pressed", "focus", "hover_pressed"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color(0.0, 0.05, 0.10, 1.0) if state in ["normal", "focus"] else Color(0.02, 0.12, 0.20, 1.0)
		box.border_color = blue if state in ["normal", "focus"] else blue.lerp(Color.WHITE, 0.45)
		box.set_border_width_all(3 if state in ["hover", "pressed", "hover_pressed"] else 2)
		box.set_corner_radius_all(10)
		box.anti_aliasing = true
		emp_split_button.add_theme_stylebox_override(state, box)
	emp_split_button.add_theme_color_override("font_color", blue.lerp(Color.WHITE, 0.55))
	emp_split_button.add_theme_color_override("font_hover_color", Color(0.92, 0.98, 1.0))
	emp_split_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	emp_split_button.add_theme_font_size_override("font_size", 18)
	emp_split_button.visible = false
	emp_split_button.pressed.connect(_on_emp_split_pressed)
	_tip(emp_split_button, "Overloads every hacking Heavy Raider: they stop hacking and fly back to their Basestar for repairs. Uses one EMP charge.")
	# A child of the FIREWALL button, so Settings and the game-over panel stay on top.
	firewall_button.add_child(emp_split_button)

func _on_emp_split_pressed() -> void:
	if contacts.request_emp():
		log_event("EMP used | %d charge%s left" % [contacts.emp_charges, "" if contacts.emp_charges == 1 else "s"])

func _update_emp_split(shield: int) -> void:
	if not is_instance_valid(emp_split_button):
		return
	var split: bool = contacts.can_use_emp()
	var full := firewall_button.size
	if split:
		var half := floorf(full.x * 0.5)
		emp_split_button.position = Vector2(half + 3.0, 0.0)
		emp_split_button.size = Vector2(full.x - half - 3.0, full.y)
		var charges: int = contacts.emp_charges
		emp_split_button.text = "EMP\n%d CHARGE%s" % [charges, "" if charges == 1 else "S"]
		firewall_button.text = "FIREWALL\n%d%%" % shield
	if split != firewall_split:
		firewall_split = split
		emp_split_button.visible = split
		# Keep the FIREWALL text in the left half while split.
		for state in ["normal", "hover", "pressed", "disabled", "focus"]:
			if split:
				var box: StyleBox = firewall_button.get_theme_stylebox(state).duplicate()
				box.content_margin_right = full.x * 0.5 + 3.0
				firewall_button.add_theme_stylebox_override(state, box)
			else:
				firewall_button.remove_theme_stylebox_override(state)
		if split:
			firewall_button.add_theme_font_size_override("font_size", 18)
		else:
			firewall_button.remove_theme_font_size_override("font_size")

func _on_firewall_toggled(enabled: bool) -> void:
	contacts.set_firewall(enabled)

func _on_restart_pressed() -> void:
	# A high score is never lost: Retry saves it under the initials shown.
	if entry_active:
		submit_initials()
	log_event("retry | score %d" % contacts.score)
	contacts.reset_battle()

func _on_launch_vipers_pressed() -> void:
	var launched: int = contacts.launch_vipers()
	print("[VIPERS] Launched ", launched, "; active=", contacts.count_vipers())

func _on_launch_raptor_pressed() -> void:
	print("[RAPTORS] Launched ", contacts.launch_raptor(), "; active=", contacts.count_kind("raptor"))
