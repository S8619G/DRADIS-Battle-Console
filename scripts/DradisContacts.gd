extends Control
## Independent overlay: never changes the ambient dome or its animation clock.
## Coordinates are normalized to the dome; +Z is farther away from the viewer.

signal contact_spawned(contact_id: String, kind: String, faction: String)
signal arrival_beep_played(contact_id: String, kind: String)
signal viper_launch_played(count: int)
signal hostile_intercepted(viper_id: String, hostile_id: String)
signal ship_damaged(amount: float, hull_remaining: float)
signal ftl_jumped
signal basestar_identified(contact_id: String)
signal basestar_destroyed(contact_id: String)
signal wave_changed(wave_number: int)
signal resurrection_arrived(contact_id: String)
signal resurrection_destroyed(contact_id: String)

## 1.07: kinds a ship or Raptor missile may attack (also when it changes target).
const MISSILE_TARGET_KINDS := ["baseship", "heavy_raider", "resurrection_ship", "nuke"]
const Icons = preload("res://scripts/DradisContactIcons.gd")
const BattleAudio = preload("res://scripts/BattleAudio.gd")
const FirewallAudio = preload("res://scripts/FirewallAudio.gd")
const ACTIVE_KINDS := ["viper", "raptor", "raider", "heavy_raider", "unknown", "baseship", "missile"]
const CAPITAL_KINDS := ["baseship", "resurrection_ship"]
const SMALL_HOSTILE_KINDS := ["raider"]

@export_group("Contacts")
@export var auto_spawn: bool = true
## Raised from 14 so later waves have room for up to four Basestars and a Resurrection Ship.
@export_range(1, 40) var max_contacts: int = 20
@export_range(3.0, 30.0) var wave_interval_seconds: float = 9.0
@export_range(0.5, 3.0) var arrival_gap_seconds: float = 0.85
@export_range(0.25, 3.0) var movement_speed: float = 1.0
## Overall contact icon size (1.0 was the Returning Flights size).
@export_range(0.4, 2.5) var icon_size: float = 1.3
@export var show_labels: bool = true
## 1.07: off = short tags (RAIDER, VIPER, RAPTOR, VIPERS x3; no tags on missiles).
## Tick to bring back the full tags with IDs, RTB and strength (for testing).
@export var show_full_tags: bool = false
## Contact name text size in design pixels (capital ships use 2 more).
@export_range(10, 32) var label_font_size: int = 16
## How much lighter than the icon color the name text is drawn.
@export_range(0.0, 0.6) var label_brighten: float = 0.15
## Thin dark outline behind the name text, in pixels. 0 turns it off.
@export_range(0, 8) var label_outline_size: int = 4
@export var label_outline_color := Color(0.0, 0.0, 0.0, 0.85)
@export var random_seed: int = 0

@export_group("Ship Sizes")
@export_range(0.4, 1.5) var small_ship_icon_scale: float = 0.75
@export_range(0.8, 2.0) var baseship_icon_scale: float = 1.35

@export_group("Ship Speeds")
## Speeds are scope-radius units per second, then multiplied by Movement Speed.
@export_range(0.01, 0.15) var normal_ship_speed: float = 0.035
@export_range(0.02, 0.25) var small_hostile_speed: float = 0.05
@export_range(0.06, 0.6) var viper_speed: float = 0.14
@export_range(0.03, 0.6) var fighter_acceleration: float = 0.12

@export_group("Battlefield")
## Unseen own ship; +Y is up the scope and +Z is farther away.
@export var own_ship_position := Vector3(0.0, -1.05, -0.15)
@export_range(1, 3) var max_basestars: int = 2
@export_range(1, 16) var max_raiders: int = 8
@export_range(1, 8) var max_raiders_per_basestar: int = 4
@export_range(1, 20) var max_missiles: int = 10
@export var basestar_weapons_enabled: bool = true
@export_range(2.0, 30.0) var raider_launch_interval: float = 7.0
@export_range(3.0, 40.0) var missile_launch_interval: float = 11.0
@export_range(0.08, 0.5) var missile_speed: float = 0.12
@export_range(0.06, 0.2) var basestar_emission_radius: float = 0.10

@export_group("Identification and Ship Weapons")
@export_range(1.0, 8.0) var identification_seconds: float = 3.0
@export var klaxon_enabled: bool = true
@export_range(-40.0, 0.0) var klaxon_volume_db: float = -5.0
@export var own_weapons_enabled: bool = true
@export_range(2.0, 20.0) var own_missile_interval: float = 6.0
@export_range(0.1, 0.6) var own_missile_speed: float = 0.28
@export_range(2, 20) var basestar_hits_to_destroy: int = 6
@export_range(1, 8) var max_own_missiles: int = 4
## 1.05: ship missiles also go after a nuclear missile once it has flown past
## Ship Nuke Target Fraction of the way to the ship (0.5 = halfway). Nukes then come
## first, ahead of close Heavy Raiders. Each ship missile counts as one nuke hit.
@export var ship_missiles_target_nukes: bool = true
@export_range(0.0, 1.0) var ship_nuke_target_fraction: float = 0.5

@export_group("Ship Defense")
@export_range(10.0, 500.0) var max_hull: float = 100.0
@export_range(1.0, 100.0) var missile_damage: float = 10.0
@export_range(0.001, 0.02) var missile_impact_radius: float = 0.004
@export_range(-30.0, 0.0) var impact_volume_db: float = -10.0
@export_range(0.15, 1.0) var hit_flash_seconds: float = 0.45
## Defense Battery kill zone: distance from the ship (scope radii). Missile paths cross
## the flak arc at about 0.06 to 0.10, so 0.12 destroys missiles on or just above the arc.
@export_range(0.05, 0.7) var prox_defense_radius: float = 0.12
## Auto Defense Battery starts firing when a missile is this close, a moment before
## it reaches the kill zone, so the arc is already active when it arrives.
@export_range(0.05, 0.7) var auto_battery_lead_radius: float = 0.22
## Chance that each battery shot destroys a missile in the defense zone. Capped at 95%.
@export_range(0.0, 0.95) var prox_success_chance: float = 0.45
## Seconds between battery shots at each missile while firing.
@export_range(0.05, 1.0) var battery_shot_interval: float = 0.1
## Seconds of continuous fire from a full battery to empty.
@export_range(2.0, 15.0) var prox_burst_seconds: float = 6.0
## Seconds to recharge from empty to full once firing stops, on NORMAL.
## 1.03: slower than the earlier 18 seconds; Easy and Hard scale it (Difficulty group).
@export_range(5.0, 60.0) var battery_recharge_seconds: float = 24.0
## Short pause after firing stops before recharging begins.
@export_range(0.0, 5.0) var battery_recharge_delay: float = 1.0
## Minimum charge needed to start firing again after the battery runs dry.
@export_range(0.0, 50.0) var battery_restart_percent: float = 15.0
@export_range(-40.0, 0.0) var battery_volume_db: float = -9.0
@export_range(1.0, 5.0) var battery_sound_speed: float = 3.0
## Repairs one percentage point per tick, after a quiet period without a hit.
@export_range(0.0, 120.0) var repair_delay_seconds: float = 20.0
@export_range(1.0, 60.0) var repair_tick_seconds: float = 8.0

@export_group("Score and Rapid Repair")
@export_range(0, 10000) var fighter_points: int = 100
@export_range(0, 10000) var nuclear_points: int = 500
@export_range(0, 10000) var basestar_points: int = 1000
@export_range(0, 10000) var heavy_raider_points: int = 300
@export_range(0, 10000) var ftl_score_cost: int = 3000
@export_range(1000, 100000) var bonus_repair_points: int = 10000
## Later bonus charges are spaced out: 10,000, then 25,000, 50,000, then every 50,000 more.
@export_range(1000, 500000) var second_bonus_points: int = 25000
@export_range(1000, 500000) var third_bonus_points: int = 50000
@export_range(1000, 500000) var later_bonus_step: int = 50000
@export_range(1.0, 100.0) var rapid_repair_percent: float = 25.0
@export_range(1.0, 20.0) var rapid_repair_seconds: float = 5.0
## 1.05: base points for each enemy missile the Defense Battery destroys (all levels).
## The score multiplier applies, and the points count toward bonus repairs.
@export_range(0, 1000) var battery_kill_points: int = 10

@export_group("FTL")
@export_range(5.0, 180.0) var ftl_recharge_seconds: float = 45.0
@export_range(2.0, 30.0) var post_jump_safe_seconds: float = 8.0
@export var ftl_starts_ready: bool = true
@export_range(-40.0, 0.0) var jump_volume_db: float = -8.0

@export_group("Nuclear Threat")
@export var nuclear_weapons_enabled: bool = true
@export_range(5.0, 90.0) var nuclear_launch_delay: float = 18.0
@export_range(0.02, 0.10) var nuclear_speed: float = 0.055
@export_range(20.0, 100.0) var nuclear_damage: float = 60.0
@export_range(-40.0, 0.0) var nuclear_alert_volume_db: float = -7.0
@export_range(1.0, 3.0) var nuclear_alert_speed: float = 1.5
@export_range(-40.0, 0.0) var nuclear_beep_volume_db: float = -12.0
@export_range(0.5, 3.0) var nuclear_beep_far_seconds: float = 1.2
@export_range(0.10, 0.4) var nuclear_beep_near_seconds: float = 0.15

@export_group("Raptors")
@export_range(1, 4) var max_raptors: int = 2
@export_range(0.03, 0.13) var raptor_speed: float = 0.10
@export_range(2.0, 30.0) var raptor_launch_cooldown: float = 8.0
@export_range(30.0, 180.0) var raptor_sortie_seconds: float = 70.0
@export_range(3.0, 20.0) var raptor_fire_interval: float = 8.0
@export_range(0.1, 0.9) var raptor_missile_damage: float = 0.5
@export_range(0.0, 0.95) var raptor_evasion_chance: float = 0.75
@export_range(2.0, 15.0) var basestar_flak_interval: float = 4.0
@export_range(0.3, 1.5) var basestar_flak_range: float = 0.85

@export_group("Heavy Raiders")
@export var heavy_raiders_enabled: bool = true
@export_range(1, 4) var max_heavy_raiders: int = 2
@export_range(1, 2) var max_heavy_per_basestar: int = 1
@export_range(5.0, 60.0) var heavy_launch_interval: float = 22.0
@export_range(0.03, 0.12) var heavy_raider_speed: float = 0.075
@export_range(2.0, 20.0) var hacking_seconds: float = 6.0
@export_range(0.5, 8.0) var hack_drain_percent_per_second: float = 2.0
@export_range(0.27, 0.5) var hacking_range: float = 0.30
## Where Heavy Raiders park beside the ship: X to each side, Y above the hull.
@export var hack_park_offset := Vector2(0.16, 0.10)
@export_range(1, 6) var heavy_raider_hit_points: int = 3
## Ship missiles target Heavy Raiders parked within this distance of the ship before Basestars.
@export_range(0.15, 2.0) var ship_missile_heavy_range: float = 0.3

@export_group("Waves")
## The wave number rises every Wave Seconds of battle; later waves are harder.
@export var waves_enabled: bool = true
@export_range(30.0, 600.0) var wave_seconds: float = 120.0
## Basestars allowed at once grows from Max Basestars (2) up to this number.
@export_range(1, 6) var wave_max_basestars: int = 4
## One more Basestar is allowed every this many waves (wave 3, wave 5 ...).
@export_range(1, 10) var extra_basestar_every_waves: int = 2
## Raider and missile launch intervals shrink by this fraction each wave...
@export_range(0.0, 0.3) var wave_interval_step: float = 0.1
## ...but never below this fraction of their normal value.
@export_range(0.3, 1.0) var wave_interval_floor: float = 0.6
## From this wave on, up to Wave Max Heavy Raiders may be on screen.
@export_range(1, 10) var extra_heavy_from_wave: int = 4
@export_range(1, 4) var wave_max_heavy_raiders: int = 3

@export_group("Resurrection Ship")
@export var resurrection_enabled: bool = true
## Never appears before this wave. Only one can be on screen at a time.
@export_range(1, 10) var resurrection_first_wave: int = 2
## Every this many seconds there is a Spawn Chance that one arrives.
@export_range(5.0, 120.0) var resurrection_check_seconds: float = 20.0
@export_range(0.0, 1.0) var resurrection_spawn_chance: float = 0.25
## Quiet period after one is destroyed before another can arrive.
@export_range(0.0, 600.0) var resurrection_cooldown_seconds: float = 90.0
## Hit points in ship-missile hits (a Basestar has 6). Raptor missiles do half.
## Lowered from 16 now that it crosses the scope and can escape.
@export_range(4, 60) var resurrection_hit_points: int = 10
@export_range(0, 20000) var resurrection_points: int = 2500
@export_range(1, 8) var resurrection_barrage_missiles: int = 3
## Seconds between missiles inside one barrage (timed, not all at once).
@export_range(0.1, 3.0) var resurrection_barrage_spacing: float = 1.0
## Seconds from the start of one barrage to the start of the next. Shortened by
## the wave like Basestar launches, and always shorter than the Basestar interval.
@export_range(3.0, 60.0) var resurrection_barrage_interval: float = 8.0
@export_range(1.0, 30.0) var resurrection_first_barrage_delay: float = 3.0
## How far apart (scope radii, left/right) barrage missiles fan out on the way in.
@export_range(0.0, 1.0) var resurrection_missile_spread: float = 0.6
## Hull damage per Resurrection Ship missile (a Basestar missile does Missile Damage, 10).
@export_range(1.0, 50.0) var resurrection_missile_damage: float = 5.0
## Crossing speed in scope radii per second (about 65 seconds edge to edge).
@export_range(0.01, 0.15) var resurrection_speed: float = 0.03
## Height band of its crossing path (scope radii above the center).
@export var resurrection_lane := Vector2(0.05, 0.22)
## Later waves: chance per check rises by this much each wave, up to Max Chance...
@export_range(0.0, 0.3) var resurrection_chance_step: float = 0.05
@export_range(0.0, 1.0) var resurrection_max_chance: float = 0.6
## ...and the quiet period shrinks by this many seconds each wave, down to Min Cooldown.
@export_range(0.0, 60.0) var resurrection_cooldown_step: float = 10.0
@export_range(0.0, 300.0) var resurrection_min_cooldown: float = 40.0
## Vipers may attack the Resurrection Ship (never Basestars): damage per hit and seconds between hits per Viper.
@export_range(0.05, 1.0) var viper_resurrection_damage: float = 0.5
@export_range(0.5, 6.0) var viper_resurrection_hit_interval: float = 2.0
@export_range(0.8, 2.0) var resurrection_icon_scale: float = 1.45
## Its arrival alert is the approved alert played twice, slower and deeper.
@export_range(-40.0, 0.0) var resurrection_alert_volume_db: float = -5.0
@export_range(0.5, 1.0) var resurrection_alert_speed: float = 0.8

@export_group("Firewall")
## FIREWALL slows a Heavy Raider hack (and its hull drain) while deployed.
## It can be deployed only while a Heavy Raider is hacking or draining.
@export var firewall_enabled: bool = true
## Hack runs at this fraction of normal speed while the firewall is up (0.25 = four times slower).
@export_range(0.0, 1.0) var firewall_slow_factor: float = 0.25
## Seconds of use from full to empty (used up quickly).
@export_range(1.0, 15.0) var firewall_seconds: float = 4.0
## Seconds to recharge from empty to full (faster than the Defense Battery's 18).
@export_range(2.0, 60.0) var firewall_recharge_seconds: float = 8.0
@export_range(0.0, 5.0) var firewall_recharge_delay: float = 0.5
## Minimum charge needed to deploy it again after it runs dry.
@export_range(0.0, 80.0) var firewall_restart_percent: float = 25.0
@export_range(-40.0, 0.0) var firewall_volume_db: float = -12.0

@export_group("Difficulty")
## Chosen in the gear Settings panel. A change starts with the next battle (Retry / New Battle).
## Normal plays exactly as before; Easy and Hard multiply the values below.
@export_enum("Easy", "Normal", "Hard") var difficulty: int = 1
## Enemy toughness: Heavy Raider, Basestar and Resurrection Ship hits to destroy (Raiders stay 1 hit).
@export_range(0.3, 1.0) var easy_toughness: float = 0.67
@export_range(1.0, 3.0) var hard_toughness: float = 1.34
## Attack frequency: Raider launches, missiles, nukes, flak, Heavy Raiders and barrages.
@export_range(0.3, 1.0) var easy_attack_rate: float = 0.75
@export_range(1.0, 3.0) var hard_attack_rate: float = 1.3
## Damage from enemy missiles and nukes.
@export_range(0.3, 1.0) var easy_damage: float = 0.75
@export_range(1.0, 3.0) var hard_damage: float = 1.25
## How fast a Heavy Raider hack completes and drains the hull.
@export_range(0.3, 1.0) var easy_hack_speed: float = 0.7
@export_range(1.0, 3.0) var hard_hack_speed: float = 1.3
## Wave length: longer waves escalate more slowly.
@export_range(1.0, 3.0) var easy_wave_length: float = 1.25
@export_range(0.3, 1.0) var hard_wave_length: float = 0.8
## Defense Battery recharge time: Easy recharges faster, Hard slower (24 s on Normal).
@export_range(0.3, 1.0) var easy_battery_recharge: float = 0.8
@export_range(1.0, 3.0) var hard_battery_recharge: float = 1.3
## Enemy missile speed on each level (1.0 = the 1.03 speed). Easy keeps the old speed.
@export_range(0.5, 3.0) var easy_missile_speed: float = 1.0
@export_range(0.5, 3.0) var normal_missile_speed: float = 1.1
@export_range(0.5, 3.0) var hard_missile_speed: float = 1.6
## Nuclear missile speed on each level (1.0 = the 1.03 speed).
@export_range(0.5, 3.0) var easy_nuke_speed: float = 1.0
@export_range(0.5, 3.0) var normal_nuke_speed: float = 1.1
@export_range(0.5, 3.0) var hard_nuke_speed: float = 1.6
## Score multiplier for each difficulty.
@export_range(0.1, 1.0) var easy_score_multiplier: float = 0.75
@export_range(1.0, 5.0) var hard_score_multiplier: float = 1.5

@export_group("Automation")
## Fires the Defense Battery by itself when standard missiles enter its zone.
@export var auto_defense_battery: bool = false
## Raises the Firewall by itself when a Heavy Raider starts hacking.
@export var auto_firewall: bool = false
## Score reduction for each auto option that is on (0.10 = 10% fewer points).
@export_range(0.0, 0.5) var auto_score_penalty: float = 0.10
## Once an auto option switches on, it stays on at least this long (no quick flicker).
@export_range(0.0, 3.0) var auto_min_engage_seconds: float = 0.5
## Launches Vipers by itself while enemy fighters are on the scope.
@export var auto_launch_vipers: bool = false
## Launches Raptors by itself for nukes, and keeps one Raptor out against Basestars.
@export var auto_launch_raptors: bool = false
## Jumps by itself when the hull falls below the level below (costs the usual FTL points).
@export var auto_ftl: bool = false
@export_range(1.0, 50.0) var auto_ftl_hull_percent: float = 10.0
## Uses a Rapid Repair charge by itself when the hull is at or below this level.
@export var auto_rapid_repair: bool = false
@export_range(10.0, 90.0) var auto_repair_hull_percent: float = 50.0

@export_group("FTL Flash")
## Blue-white wipe across the DRADIS scope and a brief screen flash when FTL engages.
@export var ftl_flash_enabled: bool = true
@export_range(0.3, 3.0) var ftl_flash_seconds: float = 1.1
## Strength of the full-screen blue-white flash (0 = wipe only). Screen Flash Enabled also applies.
@export_range(0.0, 0.6) var ftl_screen_flash_strength: float = 0.35

@export_group("Explosions")
## Small flash and boom when a missile is destroyed; larger explosion for a nuke.
@export var explosion_effects_enabled: bool = true
@export_range(0.1, 1.0) var missile_flash_seconds: float = 0.3
@export_range(0.3, 3.0) var missile_flash_size: float = 1.0
@export_range(0.3, 2.0) var nuke_explosion_seconds: float = 0.8
@export_range(0.3, 3.0) var nuke_explosion_size: float = 1.0
## Brief full-screen flash when a nuke explodes (one flash, no strobing).
@export var screen_flash_enabled: bool = true
## Flash strength when a Raptor destroys a nuke in flight (0 = off, 0.6 = strongest).
@export_range(0.0, 0.6) var nuke_screen_flash_strength: float = 0.28
## Flash strength when a nuke hits the ship.
@export_range(0.0, 0.6) var nuke_impact_flash_strength: float = 0.42
@export_range(0.1, 1.0) var screen_flash_seconds: float = 0.35
## Destruction sounds (Effects bus, below the alert levels).
@export_range(-40.0, 0.0) var missile_boom_volume_db: float = -15.0
@export_range(-40.0, 0.0) var nuke_boom_volume_db: float = -9.0
## Several destructions inside this time make only one boom (no loud stacking).
@export_range(0.0, 0.5) var boom_min_gap_seconds: float = 0.12
## Destroyed Raiders, Heavy Raiders, Vipers and Raptors: a small burst and short boom, no screen flash.
@export var craft_explosions_enabled: bool = true
@export_range(0.1, 1.0) var craft_explosion_seconds: float = 0.4
@export_range(0.3, 3.0) var craft_explosion_size: float = 1.0
## Heavy Raiders are this much bigger than Raiders.
@export_range(1.0, 2.5) var heavy_explosion_scale: float = 1.4
@export var enemy_craft_color := Color(1.0, 0.62, 0.22)
## Lost Vipers and Raptors burst in this colour so own losses are easy to spot.
@export var own_craft_color := Color(0.62, 1.0, 0.78)
@export_range(-40.0, 0.0) var craft_boom_volume_db: float = -19.0
@export_range(-40.0, 0.0) var heavy_boom_volume_db: float = -16.0
## Destroyed Basestars and Resurrection Ships: a large explosion, deep boom and one screen flash.
@export_range(0.5, 3.0) var capital_explosion_seconds: float = 1.4
@export_range(0.3, 3.0) var capital_explosion_size: float = 1.0
@export_range(0.0, 0.6) var capital_screen_flash_strength: float = 0.32
@export_range(-40.0, 0.0) var capital_boom_volume_db: float = -7.0

@export_group("Nuclear Interception")
## Raptor hits needed to destroy a nuclear missile (difficulty toughness applies).
@export_range(1, 8) var nuclear_hit_points: int = 3
## Time between a Raptor's hits on a nuke, so it has to chase it.
@export_range(0.1, 2.0) var raptor_nuke_hit_interval: float = 0.6

@export_group("Bonus Features")
## 1.05: two ship missiles per volley once enough points are earned in a battle.
## FTL costs do not take it away; Retry or a new battle starts over.
@export var double_missile_bonus: bool = true
@export_range(1000, 200000, 500) var easy_double_missile_points: int = 15000
@export_range(1000, 200000, 500) var normal_double_missile_points: int = 17500
@export_range(1000, 200000, 500) var hard_double_missile_points: int = 20000
## Short rising chime when the bonus unlocks (Effects bus, below the alerts).
@export_range(-40.0, 0.0) var bonus_chime_volume_db: float = -14.0

@export_group("EMP Defense")
## 1.06: USE EMP appears in the middle of the ship while a Heavy Raider hacks and
## a charge is ready. It overloads every hacking Heavy Raider: they shimmer blue,
## stop hacking and fly back to their Basestar for repairs (not destroyed, no points).
@export var emp_enabled: bool = true
## One EMP charge per this many earned points (FTL costs do not take it away).
@export_range(1000, 50000, 500) var emp_points_per_charge: int = 5000
## Most charges held at once.
@export_range(1, 5) var emp_max_charges: int = 2
## How long overloaded Heavy Raiders shimmer before they turn for home.
@export_range(0.2, 4.0) var emp_shimmer_seconds: float = 1.0
@export var emp_color := Color(0.35, 0.78, 1.0)
## Electric zap when the EMP fires (Effects bus).
@export_range(-40.0, 0.0) var emp_zap_volume_db: float = -10.0
## 1.07: the EMP is offered only this many seconds after the Firewall has run out
## (or cannot be raised) during a hack. The Firewall is always the first answer.
@export_range(0.0, 10.0) var emp_delay_after_firewall: float = 2.0

@export_group("Rapid Repair Feedback")
## 1.06: a rising recharge sound plays while a Rapid Repair runs.
@export var repair_sound_enabled: bool = true
@export_range(-40.0, 0.0) var repair_sound_volume_db: float = -16.0
## The ship outline pulses brighter green while a Rapid Repair runs.
@export var repair_flash_enabled: bool = true
@export_range(0.5, 6.0) var repair_flash_hz: float = 2.0

@export_group("Viper Squadrons")
## Vipers flying close together show as one Viper Squadron icon (display only).
@export var viper_squadrons_enabled: bool = true
## Vipers closer than this join a squadron.
@export_range(0.02, 0.2) var squadron_join_distance: float = 0.075
## A Viper further than this from its squadron's centre splits off (larger = steadier).
## 1.07: 0.06 (was 0.12), so Vipers that break off to fight show as separate icons.
@export_range(0.04, 0.3) var squadron_split_distance: float = 0.06
## 1.07: with several enemies about, Vipers spread over different targets, then fly
## back and rejoin one patrol formation when the area is clear.
@export var squadrons_split_to_engage: bool = true
## Vipers allowed on one tough target (Heavy Raider, Resurrection Ship) before the rest look elsewhere.
@export_range(1, 6) var max_vipers_per_tough_target: int = 2
## How strongly a Viper avoids a Raider or missile a squadron mate already chases (1 = no spreading).
@export_range(1.0, 10.0) var squadron_spread_penalty: float = 3.0
## Gap between Vipers in the shared patrol formation (keep under the join distance).
@export_range(0.01, 0.07) var formation_spacing: float = 0.02

@export_group("Missile Visibility")
## 1.07: enemy missiles pulse so the eye picks them out; they never fully vanish.
@export var enemy_missile_pulse: bool = true
@export_range(0.5, 4.0) var enemy_missile_pulse_hz: float = 2.0
## Lowest brightness of the pulse (1.0 = no pulse).
@export_range(0.1, 1.0) var enemy_missile_pulse_min: float = 0.35

@export_group("Fighter Losses")
## Vipers and Raptors can be shot down in battle. They are tougher than Raiders (1) and Heavy Raiders (3).
@export var fighter_losses_enabled: bool = true
## Vipers are lighter (fewer hit points) but nimble: Viper Evasion Chance dodges some hits.
## Raptors are armored: more hit points, plus Raptor Evasion Chance against fire.
@export_range(1, 10) var viper_hit_points: int = 2
@export_range(1, 12) var raptor_hit_points: int = 7
@export_range(0.0, 0.95) var viper_evasion_chance: float = 0.2
## Chance each Raider attack on an active Viper or Raptor scores a hit (before evasion).
@export_range(0.0, 1.0) var raider_hit_chance: float = 0.5
## Points lost when one of our fighters is destroyed (score never drops below zero;
## earned progress toward bonus repairs is kept).
@export_range(0, 5000) var viper_loss_points: int = 200
@export_range(0, 5000) var raptor_loss_points: int = 400

@export_group("Viper Launch")
@export_range(1, 12) var max_vipers: int = 6
@export_range(1, 4) var vipers_per_launch: int = 2
@export_range(1.0, 15.0) var launch_cooldown_seconds: float = 4.0
@export_range(10.0, 120.0) var sortie_seconds: float = 45.0

@export_group("Returning Flights")
## Raiders return to their Basestar to refuel and rearm after this long.
@export_range(15.0, 120.0) var raider_sortie_seconds: float = 40.0
## Returning ships fly at this fraction of normal speed (low on fuel).
@export_range(0.4, 1.0) var returning_speed_factor: float = 0.8
## Lighter tint and slow flash for returning ships.
@export_range(0.0, 0.8) var returning_lighten: float = 0.45
@export_range(0.2, 3.0) var returning_flash_hz: float = 0.8
## Raiders hunt returning Vipers within this range.
@export_range(0.1, 0.6) var raider_attack_range: float = 0.30
## Chance a Raider reaching a returning Viper destroys it (each attack).
@export_range(0.0, 1.0) var returning_viper_loss_chance: float = 0.5
@export_range(0.5, 5.0) var raider_attack_cooldown: float = 1.5
## Returning Raptors evade Basestar flak less often.
@export_range(0.0, 0.95) var returning_raptor_evasion_chance: float = 0.35
## Heavy Raiders flash this fast while hacking or draining.
@export_range(2.0, 12.0) var hacking_flash_hz: float = 6.0
@export var launch_sound_enabled: bool = true
@export_range(-40.0, 0.0) var launch_volume_db: float = -12.0

@export_group("Depth")
@export_range(2.0, 6.0) var perspective_distance: float = 2.8
@export_range(0.0, 1.0) var depth_strength: float = 0.25

@export_group("Contact Colors")
@export var friendly_color := Color(0.3, 1.0, 0.55)
@export var hostile_color := Color(1.0, 0.22, 0.28)
@export var unknown_color := Color(1.0, 0.73, 0.22)

@export_group("Arrival Audio")
@export var arrival_sound_enabled: bool = true
@export_range(-40.0, 0.0) var arrival_volume_db: float = -8.0

var contacts: Array[Dictionary] = []
var pending: Array[Dictionary] = []
var next_id: int = 1
var beep_count: int = 0
var spawn_count: int = 0
var rng := RandomNumberGenerator.new()
var arrival_player: AudioStreamPlayer
var spawn_countdown: float = 0.8
var wave_countdown: float = 9.0
var launch_player: AudioStreamPlayer
var launch_cooldown_remaining: float = 0.0
var launch_sound_count: int = 0
var intercepted_count: int = 0
var impacts: Array[Dictionary] = []
var hull: float = 100.0
var prox_active: bool = false
var ftl_recharge_remaining: float = 0.0
var safe_remaining: float = 0.0
var missile_hits: int = 0
var prox_kills: int = 0
var missile_intercepts: int = 0
var jumps_used: int = 0
var status_message: String = "DEFEND THE LOWER SCOPE | LAUNCH VIPERS WHEN RAIDERS APPEAR"
var status_remaining: float = 0.0
var repair_delay_remaining: float = 0.0
var repair_elapsed: float = 0.0
var own_fire_remaining: float = 0.0
var basestars_destroyed: int = 0
var own_missile_hits: int = 0
var identification_count: int = 0
var klaxon_count: int = 0
var klaxon_player: AudioStreamPlayer
## Difficulty used by the current battle (set from difficulty at each new battle).
var active_difficulty: int = 1
var auto_battery_started: bool = false
var auto_battery_since: float = 0.0
var auto_firewall_started: bool = false
var auto_firewall_since: float = 0.0
var explosions: Array[Dictionary] = []
var explosions_made: int = 0
var screen_flash_remaining: float = 0.0
var screen_flash_peak: float = 0.0
var last_boom := {"missile": -INF, "nuke": -INF, "craft": -INF, "heavy": -INF, "capital": -INF}
var booms_played := {"missile": 0, "nuke": 0, "craft": 0, "heavy": 0, "capital": 0}
var nuke_hits_landed: int = 0
var viper_squadrons: Array = []
## 1.07: targets claimed by Vipers this frame, the shared patrol angle and missile retargets.
var viper_claims := {}
var squadron_patrol_angle := 0.0
var missile_retargets := 0
## 1.07: when the Firewall became unusable during the current hack (-1 = not), and
## whether the EMP is now offered for this hack.
var firewall_out_since := -1.0
var emp_offer_open := false
var missile_boom_player: AudioStreamPlayer
var nuke_boom_player: AudioStreamPlayer
var craft_boom_player: AudioStreamPlayer
var heavy_boom_player: AudioStreamPlayer
var capital_boom_player: AudioStreamPlayer
var auto_repairs: int = 0
var craft_explosions: int = 0
var capital_explosions: int = 0
var auto_battery_starts: int = 0
var auto_firewall_starts: int = 0
var auto_viper_launches: int = 0
var auto_raptor_launches: int = 0
var auto_ftl_jumps: int = 0
var ftl_flash_remaining: float = 0.0
var klaxon_queue: Array[String] = []
var battery_player: AudioStreamPlayer
var jump_player: AudioStreamPlayer
var nuclear_player: AudioStreamPlayer
var nuclear_beep_player: AudioStreamPlayer
var nuclear_alert_queue: Array[String] = []
var nuclear_alert_contact_id: String = ""
var nuclear_alert_count: int = 0
var nuclear_beep_count: int = 0
var prox_burst_remaining: float = 0.0
var prox_cooldown_remaining: float = 0.0
var raptor_cooldown_remaining: float = 0.0
var nuclear_alarm_remaining: float = 0.0
var battle_time: float = 0.0
var nuclear_launches: int = 0
var nuclear_intercepts: int = 0
var nuclear_hits: int = 0
var raptor_evades: int = 0
var raptors_lost: int = 0
var raptors_returned: int = 0
var vipers_returned: int = 0
var vipers_lost: int = 0
var raiders_docked: int = 0
var battery_idle: float = 0.0
var raptor_missile_hits: int = 0
var score: int = 0
var scored_contacts: Dictionary = {}
var rapid_repair_used: bool = false
var rapid_repair_remaining: float = 0.0
var rapid_repair_rate: float = 0.0
var repair_charges: int = 1
var earned_points: int = 0
## 1.05 bonus state. Battle time when Double Missile unlocked (-1 = not yet).
var double_missile_unlocked_at: float = -1.0
var bonus_chimes: int = 0
var battery_kill_score: int = 0
var ship_nuke_hits: int = 0
var ship_nuke_kills: int = 0
var bonus_chime_player: AudioStreamPlayer
## 1.06 EMP and repair feedback state.
var emp_charges: int = 0
var emp_awards_earned: int = 0
var emp_uses: int = 0
var emp_heavies_overloaded: int = 0
var emp_heavies_docked: int = 0
var emp_player: AudioStreamPlayer
var repair_sound_player: AudioStreamPlayer
var repair_sounds: int = 0
var repair_bonuses_earned: int = 0
var hit_flash_remaining: float = 0.0
var impact_player: AudioStreamPlayer
var impact_sound_count: int = 0
var heavy_raiders_destroyed: int = 0
var wave: int = 1
var resurrection_alert_player: AudioStreamPlayer
var resurrection_alert_pending: bool = false
var resurrection_alert_count: int = 0
var resurrection_check_remaining: float = 20.0
var resurrection_cooldown_remaining: float = 0.0
var resurrection_spawns: int = 0
var resurrections_destroyed: int = 0
var resurrection_barrages: int = 0
var resurrection_missiles_fired: int = 0
var resurrection_hits_by: Dictionary = {"ship": 0, "raptor": 0, "viper": 0}
var own_volley_count: int = 0
var firewall_active: bool = false
var firewall_charge: float = 4.0
var firewall_idle: float = 0.0
var firewall_uses: int = 0
var firewall_player: AudioStreamPlayer
var resurrections_escaped: int = 0
var fighter_points_lost: int = 0
var viper_evades: int = 0
var fighter_losses_by := {"raider": 0, "flak": 0, "returning": 0}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if random_seed == 0:
		rng.randomize()
	else:
		rng.seed = random_seed
	arrival_player = AudioStreamPlayer.new()
	arrival_player.name = "ContactArrivalAudio"
	arrival_player.stream = make_arrival_sound()
	arrival_player.volume_db = arrival_volume_db
	add_child(arrival_player)
	launch_player = AudioStreamPlayer.new()
	launch_player.name = "ViperLaunchAudio"
	launch_player.stream = make_launch_sound()
	launch_player.volume_db = launch_volume_db
	add_child(launch_player)
	klaxon_player = AudioStreamPlayer.new()
	klaxon_player.name = "IdentificationKlaxon"
	klaxon_player.stream = make_klaxon_sound()
	add_child(klaxon_player)
	battery_player = _effect_player("DefenseBatteryAudio", "battery", battery_volume_db)
	battery_player.pitch_scale = battery_sound_speed
	jump_player = _effect_player("FTLJumpAudio", "jump", jump_volume_db)
	nuclear_player = _effect_player("NuclearAlertAudio", "nuclear", nuclear_alert_volume_db)
	nuclear_player.stream = make_alert_sequence(2)
	nuclear_player.pitch_scale = nuclear_alert_speed
	nuclear_beep_player = AudioStreamPlayer.new()
	nuclear_beep_player.name = "NuclearApproachBeep"
	nuclear_beep_player.stream = BattleAudio.make_approach_beep()
	nuclear_beep_player.volume_db = nuclear_beep_volume_db
	add_child(nuclear_beep_player)
	impact_player = AudioStreamPlayer.new()
	impact_player.name = "HullImpactAudio"
	impact_player.stream = BattleAudio.make_hull_impact()
	impact_player.volume_db = impact_volume_db
	add_child(impact_player)
	resurrection_alert_player = AudioStreamPlayer.new()
	resurrection_alert_player.name = "ResurrectionAlert"
	resurrection_alert_player.stream = make_alert_sequence(2)
	resurrection_alert_player.volume_db = resurrection_alert_volume_db
	resurrection_alert_player.pitch_scale = resurrection_alert_speed
	add_child(resurrection_alert_player)
	firewall_player = AudioStreamPlayer.new()
	firewall_player.name = "FirewallAudio"
	firewall_player.stream = FirewallAudio.make_firewall_loop()
	firewall_player.volume_db = firewall_volume_db
	add_child(firewall_player)
	missile_boom_player = AudioStreamPlayer.new()
	missile_boom_player.name = "MissileBoomAudio"
	missile_boom_player.stream = BattleAudio.make_missile_boom()
	missile_boom_player.volume_db = missile_boom_volume_db
	missile_boom_player.max_polyphony = 2
	add_child(missile_boom_player)
	nuke_boom_player = AudioStreamPlayer.new()
	nuke_boom_player.name = "NukeBoomAudio"
	nuke_boom_player.stream = BattleAudio.make_nuke_boom()
	nuke_boom_player.volume_db = nuke_boom_volume_db
	nuke_boom_player.max_polyphony = 2
	add_child(nuke_boom_player)
	craft_boom_player = _boom_player("CraftBoomAudio", BattleAudio.make_craft_boom(), craft_boom_volume_db)
	heavy_boom_player = _boom_player("HeavyBoomAudio", BattleAudio.make_heavy_boom(), heavy_boom_volume_db)
	capital_boom_player = _boom_player("CapitalBoomAudio", BattleAudio.make_capital_boom(), capital_boom_volume_db)
	bonus_chime_player = _boom_player("BonusChimeAudio", BattleAudio.make_bonus_chime(), bonus_chime_volume_db)
	bonus_chime_player.max_polyphony = 1
	emp_player = _boom_player("EmpZapAudio", BattleAudio.make_emp_zap(), emp_zap_volume_db)
	emp_player.max_polyphony = 1
	repair_sound_player = _boom_player("RepairChargeAudio", BattleAudio.make_repair_charge(rapid_repair_seconds), repair_sound_volume_db)
	repair_sound_player.max_polyphony = 1
	reset_battle()

func _process(delta: float) -> void:
	hit_flash_remaining = maxf(0.0, hit_flash_remaining - delta)
	if rapid_repair_remaining <= 0.0 and is_instance_valid(repair_sound_player) and repair_sound_player.playing:
		repair_sound_player.stop()
	_age_explosions(delta)
	for index in range(impacts.size() - 1, -1, -1):
		impacts[index].age += delta
		if impacts[index].age >= 0.45:
			impacts.remove_at(index)
	if is_defeated():
		queue_redraw()
		return
	battle_time += delta
	_update_wave()
	_update_battery(delta)
	_update_firewall(delta)
	_update_emp_offer()
	_update_automation()
	_update_viper_squadrons()
	raptor_cooldown_remaining = maxf(0.0, raptor_cooldown_remaining - delta)
	_update_repair(delta)
	_update_rapid_repair(delta)
	_update_klaxon()
	launch_cooldown_remaining = maxf(0.0, launch_cooldown_remaining - delta)
	ftl_recharge_remaining = maxf(0.0, ftl_recharge_remaining - delta)
	safe_remaining = maxf(0.0, safe_remaining - delta)
	status_remaining = maxf(0.0, status_remaining - delta)
	if status_remaining <= 0.0:
		status_message = "DEFEND THE LOWER SCOPE | VIPERS ENGAGE RAIDERS AND MISSILES"
	for index in range(contacts.size() - 1, -1, -1):
		var contact: Dictionary = contacts[index]
		contact.age += delta
		if Icons.is_viper(contact.kind):
			continue
		if contact.kind == "baseship":
			_update_basestar(contact, delta)
			continue
		if contact.kind == "resurrection_ship":
			_update_resurrection(contact, delta)
			continue
		if contact.kind == "raider":
			_update_raider(contact, delta)
			continue
		if contact.kind == "missile":
			var aim := own_ship_position
			if contact.has("spread"):
				# Resurrection barrage: fan out sideways across the flight path,
				# closing in on the ship near the end.
				var far: float = clampf((contact.position.distance_to(own_ship_position) - 0.35) / 0.9, 0.0, 1.0)
				aim += contact.get("side", Vector3.RIGHT) * contact.spread * far
			contact.position = contact.position.move_toward(aim,
				delta * movement_speed * missile_speed * missile_speed_factor())
			continue
		if contact.kind == "unknown" and contact.age >= identification_seconds:
			_identify_basestar(contact)
	_update_vipers(delta)
	_update_raptors(delta)
	_resolve_missiles()
	if not is_defeated():
		_update_own_weapons(delta)
		_update_special_projectiles(delta)
	if not is_defeated():
		_update_nuclear_alarm(delta)
		_update_heavy_raiders(delta)
		_update_resurrection_spawning(delta)
		_update_resurrection_alert()
	if auto_spawn and safe_remaining <= 0.0 and not is_defeated():
		spawn_countdown -= delta
		wave_countdown -= delta
		if pending.is_empty() and wave_countdown <= 0.0:
			_queue_wave()
			wave_countdown = maxf(3.0, wave_interval_seconds)
	# Emitter and distant-contact arrivals share one queue, preventing beep overlap.
	if not pending.is_empty() and safe_remaining <= 0.0 and not is_defeated():
		spawn_countdown -= delta if not auto_spawn else 0.0
		if spawn_countdown <= 0.0:
			var request: Dictionary = pending.pop_front()
			if request.has("origin_id"):
				spawn_from_basestar(request.kind, request.origin_id)
			else:
				spawn_contact(request.kind, request.faction)
			spawn_countdown = maxf(0.5, arrival_gap_seconds)
	arrival_player.volume_db = arrival_volume_db
	launch_player.volume_db = launch_volume_db
	queue_redraw()

func _queue_wave() -> void:
	if pending.size() >= 10:
		return
	if count_kind("baseship") + count_kind("unknown") < basestar_cap() and count_tracks() < max_contacts:
		pending.append({"kind": "unknown", "faction": "unknown"})

func spawn_contact(kind: String, faction: String) -> String:
	if not ACTIVE_KINDS.has(kind):
		return ""
	if is_defeated() or safe_remaining > 0.0:
		return ""
	if faction not in ["friendly", "hostile", "unknown"]:
		return ""
	if Icons.is_viper(kind):
		return _spawn_viper(kind, true) if faction == "friendly" else ""
	if kind == "raptor":
		return _spawn_raptor() if faction == "friendly" else ""
	# Raiders and missiles have no independent/random spawn path.
	if kind in ["raider", "heavy_raider", "missile"]:
		return ""
	if faction != ("unknown" if kind == "unknown" else "hostile"):
		return ""
	if count_tracks() >= max_contacts:
		return ""
	if count_kind("baseship") + count_kind("unknown") >= basestar_cap():
		return ""
	# Every distant arrival is unidentified, including requests for a capital ship.
	kind = "unknown"
	faction = "unknown"
	var start := _place_capital()
	if start == Vector3.INF:
		return ""
	var finish := start
	var contact_id := _new_id("U")
	contacts.append({
		"id": contact_id, "kind": kind, "faction": faction,
		"start": start, "finish": finish, "position": start,
		"progress": 0.0, "age": 0.0,
		"duration": 45.0,
		"raider_timer": rng.randf_range(4.0, 6.0),
		"missile_timer": rng.randf_range(8.0, 11.0)
	})
	_announce_contact(contact_id, kind, faction)
	return contact_id

func _new_id(prefix: String) -> String:
	var id := "%s-%03d" % [prefix, next_id]
	next_id += 1
	return id

func _announce_contact(contact_id: String, kind: String, faction: String) -> void:
	spawn_count += 1
	contact_spawned.emit(contact_id, kind, faction)
	if arrival_sound_enabled and not Icons.is_viper(kind):
		arrival_player.volume_db = arrival_volume_db
		arrival_player.play()
		beep_count += 1
		arrival_beep_played.emit(contact_id, kind)
	queue_redraw()

func find_contact(id: String) -> Dictionary:
	for contact in contacts:
		if contact.id == id:
			return contact
	return {}

func count_kind(kind: String) -> int:
	var count := 0
	for contact in contacts:
		if contact.kind == kind:
			count += 1
	return count

func spawn_from_basestar(kind: String, origin_id: String) -> String:
	if kind not in ["raider", "heavy_raider", "missile"] or is_defeated() or safe_remaining > 0.0:
		return ""
	var base := find_contact(origin_id)
	if base.is_empty() or base.kind not in ["baseship", "resurrection_ship"]:
		return ""
	# A Resurrection Ship launches missiles only, never fighters.
	if base.kind == "resurrection_ship" and kind != "missile":
		return ""
	if kind == "raider" and (count_kind("raider") >= max_raiders or count_tracks() >= max_contacts or count_base_raiders(origin_id) >= max_raiders_per_basestar):
		return ""
	if kind == "missile" and count_kind("missile") >= missile_cap():
		return ""
	if kind == "heavy_raider" and (not heavy_raiders_enabled or count_kind("heavy_raider") >= heavy_raider_cap() or count_tracks() >= max_contacts or count_base_heavies(origin_id) >= max_heavy_per_basestar):
		return ""
	var direction: Vector3 = base.position.direction_to(own_ship_position)
	var origin: Vector3 = base.position + direction * basestar_emission_radius
	var id := _new_id("M" if kind == "missile" else ("HR" if kind == "heavy_raider" else "H"))
	contacts.append({
		"id": id, "kind": kind, "faction": "hostile", "position": origin,
		"start": origin, "finish": own_ship_position, "age": 0.0, "progress": 0.0,
		"origin_id": origin_id, "origin_position": base.position,
		"target_position": own_ship_position, "defense_checked": false,
		"phase": "approach", "patrol_angle": rng.randf_range(0.0, TAU),
		"approach_point": Vector3(rng.randf_range(-0.3, 0.3), -0.10, 0.05),
		"velocity": Vector3.ZERO,
		"health": scaled_hits(heavy_raider_hit_points) if kind == "heavy_raider" else 1,
		"hack_remaining": maxf(0.1, hacking_seconds / hack_speed()),
		"hack_point": _hack_point_for(next_id % 2 == 0) if kind == "heavy_raider" else own_ship_position + Vector3(-hack_park_offset.x if next_id % 2 == 0 else hack_park_offset.x, hack_park_offset.y, 0.0),
		"next_battery_shot": 0.0
	})
	_announce_contact(id, kind, "hostile")
	return id

func _update_basestar(base: Dictionary, delta: float) -> void:
	# Stationary until destroyed or left behind by an FTL jump.
	if not basestar_weapons_enabled or safe_remaining > 0.0:
		return
	if heavy_raiders_enabled:
		base.heavy_timer -= delta
		if base.heavy_timer <= 0.0:
			if pending.size() < 12 and count_kind("heavy_raider") + pending_heavies() < heavy_raider_cap() and count_base_heavies(base.id, true) < max_heavy_per_basestar:
				pending.append({"kind": "heavy_raider", "origin_id": base.id})
			base.heavy_timer = maxf(5.0, heavy_launch_interval) / attack_rate()
	if nuclear_weapons_enabled and not base.get("nuclear_launched", false):
		base.nuclear_timer -= delta
		if base.nuclear_timer <= 0.0:
			_launch_nuclear(base)
	base.flak_timer -= delta
	if base.flak_timer <= 0.0:
		_fire_flak(base)
		base.flak_timer = maxf(2.0, basestar_flak_interval) / attack_rate()
	base.raider_timer -= delta
	base.missile_timer -= delta
	if base.raider_timer <= 0.0:
		if pending.size() < 12 and count_kind("raider") < max_raiders and count_base_raiders(base.id, true) < max_raiders_per_basestar:
			pending.append({"kind": "raider", "origin_id": base.id})
		base.raider_timer = maxf(2.0, raider_launch_interval) * wave_interval_multiplier() * rng.randf_range(0.85, 1.15) / attack_rate()
	if base.missile_timer <= 0.0:
		if pending.size() < 12 and count_kind("missile") < max_missiles:
			pending.append({"kind": "missile", "origin_id": base.id})
		base.missile_timer = maxf(3.0, missile_launch_interval) * wave_interval_multiplier() * rng.randf_range(0.85, 1.15) / attack_rate()

func _update_raider(raider: Dictionary, delta: float) -> void:
	raider.attack_cooldown = maxf(0.0, raider.get("attack_cooldown", 0.0) - delta)
	if raider.phase != "return" and raider.age >= raider_sortie_seconds:
		var home := _raider_home(raider)
		if not home.is_empty():
			raider.phase = "return"
			raider.home_id = home.id
	if raider.phase == "return":
		var home := _raider_home(raider)
		if home.is_empty():
			# No Basestar left to refuel at: keep fighting.
			raider.phase = "harass"
			raider.age = 0.0
			return
		raider.home_id = home.id
		_steer(raider, home.position, small_hostile_speed * returning_speed_factor, delta)
		if raider.position.distance_to(home.position) <= 0.05:
			raiders_docked += 1
			_remove_contact(raider.id)
		return
	# Hunt returning Vipers (low on fuel and ammunition) first; with Fighter
	# Losses on, Raiders also attack active Vipers and Raptors nearby.
	var prey: Dictionary = {}
	var nearest := raider_attack_range
	var best := INF
	for other in contacts:
		var returning_viper: bool = Icons.is_viper(other.kind) and other.get("phase", "") == "return"
		var fighter: bool = fighter_losses_enabled and (Icons.is_viper(other.kind) or other.kind == "raptor") and other.get("phase", "") != "launch"
		if returning_viper or fighter:
			var gap: float = raider.position.distance_to(other.position)
			var rank := gap * (0.5 if returning_viper else 1.0)
			if gap < raider_attack_range and rank < best:
				best = rank
				nearest = gap
				prey = other
	if not prey.is_empty() and raider.phase == "harass":
		_steer(raider, prey.position, small_hostile_speed * 1.3, delta)
		if nearest <= 0.05 and raider.attack_cooldown <= 0.0:
			raider.attack_cooldown = maxf(0.5, raider_attack_cooldown)
			if Icons.is_viper(prey.kind) and prey.get("phase", "") == "return":
				if rng.randf() < clampf(returning_viper_loss_chance, 0.0, 1.0):
					fighter_losses_by["returning"] += 1
					_lose_fighter(prey, "VIPER LOST ON RETURN | RAIDERS HUNTING RETURNING FLIGHTS")
			elif rng.randf() < clampf(raider_hit_chance, 0.0, 1.0):
				if prey.kind == "raptor" and rng.randf() < clampf(raptor_evasion_chance, 0.0, 0.95):
					raptor_evades += 1
				elif prey.kind != "raptor" and rng.randf() < clampf(viper_evasion_chance, 0.0, 0.95):
					viper_evades += 1
				else:
					_damage_fighter(prey, "RAIDER FIRE")
		return
	if raider.phase == "approach":
		_steer(raider, raider.approach_point, small_hostile_speed, delta)
		if raider.position.distance_to(raider.approach_point) < 0.03:
			raider.phase = "harass"
			raider.patrol_angle = atan2((raider.position.y + 0.10) / 0.22, raider.position.x / 0.40)
	else:
		raider.patrol_angle += delta * 0.11
		var patrol := Vector3(cos(raider.patrol_angle) * 0.40,
			-0.10 + sin(raider.patrol_angle) * 0.22, 0.08)
		_steer(raider, patrol, small_hostile_speed, delta)

func _raider_home(raider: Dictionary) -> Dictionary:
	# Prefer the launching Basestar; otherwise the nearest surviving one.
	# origin_id is never changed, so per-Basestar launch caps stay exact.
	for key in ["home_id", "origin_id"]:
		var preferred := find_contact(raider.get(key, ""))
		if not preferred.is_empty() and preferred.kind == "baseship":
			return preferred
	var home: Dictionary = {}
	var best := INF
	for contact in contacts:
		if contact.kind == "baseship":
			var gap: float = raider.position.distance_to(contact.position)
			if gap < best:
				best = gap
				home = contact
	return home

func is_returning(contact: Dictionary) -> bool:
	return contact.get("phase", "") == "return" and (Icons.is_viper(contact.kind) or contact.kind in ["raider", "raptor"])

func display_color(contact: Dictionary) -> Color:
	var color := unknown_color
	if contact.faction == "friendly":
		color = friendly_color
	elif contact.faction == "hostile":
		color = hostile_color
	if is_returning(contact):
		color = color.lerp(Color.WHITE, clampf(returning_lighten, 0.0, 0.8))
		color.a = 0.55 + 0.45 * (0.5 + 0.5 * cos(TAU * returning_flash_hz * battle_time))
	elif contact.kind == "heavy_raider" and contact.get("phase", "") in ["hacking", "draining"]:
		color.a = 1.0 if int(battle_time * hacking_flash_hz * 2.0) % 2 == 0 else 0.22
	elif contact.kind == "heavy_raider" and contact.get("phase", "") == "emp":
		# Electric-blue shimmer while overloaded.
		var shimmer := 0.5 + 0.5 * sin(TAU * 9.0 * battle_time + float(String(contact.id).hash() % 7))
		color = emp_color.lerp(Color(0.85, 0.96, 1.0), shimmer * 0.6)
		color.a = 0.65 + 0.35 * shimmer
	elif contact.kind == "heavy_raider" and contact.get("phase", "") == "emp_return":
		color = color.lerp(Color.WHITE, clampf(returning_lighten, 0.0, 0.8))
		color.a = 0.55 + 0.45 * (0.5 + 0.5 * cos(TAU * returning_flash_hz * battle_time))
	elif contact.kind == "missile" and enemy_missile_pulse:
		color = _pulse_dim(color, missile_pulse_level())
	return color

## 1.07: enemy missile brightness, from enemy_missile_pulse_min up to 1.0.
func missile_pulse_level() -> float:
	if not enemy_missile_pulse:
		return 1.0
	var low := clampf(enemy_missile_pulse_min, 0.0, 1.0)
	return lerpf(low, 1.0, 0.5 + 0.5 * cos(TAU * enemy_missile_pulse_hz * battle_time))

func _pulse_dim(color: Color, level: float) -> Color:
	return Color(color.r * level, color.g * level, color.b * level, color.a)

func _steer(ship: Dictionary, destination: Vector3, speed: float, delta: float) -> void:
	# Acceleration-limited velocity avoids instantaneous reversals and target jitter.
	var offset: Vector3 = destination - ship.position
	var limit := maxf(0.0, speed * movement_speed)
	var desired := offset.normalized() * minf(limit, offset.length() * 2.0)
	var velocity: Vector3 = ship.get("velocity", Vector3.ZERO)
	velocity = velocity.move_toward(desired, fighter_acceleration * movement_speed * delta)
	ship.velocity = velocity.limit_length(limit)
	ship.position += ship.velocity * delta

func _resolve_missiles() -> void:
	for index in range(contacts.size() - 1, -1, -1):
		var missile: Dictionary = contacts[index]
		if missile.kind != "missile":
			continue
		var distance: float = missile.position.distance_to(own_ship_position)
		if prox_active and distance <= prox_defense_radius and battle_time >= missile.get("next_battery_shot", 0.0):
			# Continuous fire: each missile in the zone draws a shot every interval.
			missile.defense_checked = true
			missile.next_battery_shot = battle_time + maxf(0.1, battery_shot_interval)
			if rng.randf() < clampf(prox_success_chance, 0.0, 0.95):
				prox_kills += 1
				var battery_points := points_for(battery_kill_points)
				battery_kill_score += battery_points
				_add_points(battery_points)
				impacts.append({"position": missile.position, "age": 0.0, "battery": true})
				_explode(missile.position, "missile")
				contacts.remove_at(index)
				_set_status("DEFENSE BATTERY: MISSILE DESTROYED", 2.0)
				continue
		if distance <= missile_impact_radius:
			contacts.remove_at(index)
			missile_hits += 1
			impacts.append({"position": own_ship_position, "age": 0.0})
			apply_damage(missile.get("damage", missile_damage) * damage_factor())
			if is_defeated():
				break

func is_defeated() -> bool:
	return hull <= 0.0

func apply_damage(amount: float, missile_impact: bool = true) -> void:
	if is_defeated() or amount <= 0.0:
		return
	hull = maxf(0.0, hull - amount)
	repair_delay_remaining = repair_delay_seconds
	repair_elapsed = 0.0
	ship_damaged.emit(amount, hull)
	_set_status(("MISSILE HIT" if missile_impact else "COMPUTER HACK: HULL DRAIN") + " | HULL %d / %d" % [ceili(hull), ceili(max_hull)], 3.0)
	if is_defeated():
		pending.clear()
		arrival_player.stop()
		launch_player.stop()
		klaxon_player.stop()
		klaxon_queue.clear()
		_stop_special_audio()
		prox_active = false
		prox_burst_remaining = 0.0
		rapid_repair_remaining = 0.0
		status_message = "SHIP LOST | GAME OVER"
	if missile_impact:
		# Play after defeat cleanup so the final impact is also audible.
		hit_flash_remaining = hit_flash_seconds
		impact_player.volume_db = impact_volume_db
		impact_player.play()
		impact_sound_count += 1

func set_prox_defense(enabled: bool) -> void:
	if is_defeated():
		return
	if not enabled:
		if prox_active:
			_end_battery_burst()
		return
	if prox_active or not can_fire_battery():
		return
	prox_active = true
	battery_player.volume_db = battery_volume_db
	battery_player.pitch_scale = battery_sound_speed
	battery_player.play()
	_set_status("DEFENSE BATTERY FIRING | STANDARD MISSILES ONLY", 3.0)

func can_jump() -> bool:
	return not is_defeated() and ftl_recharge_remaining <= 0.0

func request_ftl_jump() -> bool:
	if not can_jump():
		return false
	score = maxi(0, score - ftl_score_cost)
	var left_resurrection := count_kind("resurrection_ship") > 0
	contacts.clear()
	pending.clear()
	impacts.clear()
	arrival_player.stop()
	launch_player.stop()
	klaxon_player.stop()
	klaxon_queue.clear()
	if prox_active:
		_end_battery_burst()
	nuclear_player.stop()
	nuclear_beep_player.stop()
	nuclear_alert_queue.clear()
	nuclear_alert_contact_id = ""
	nuclear_alarm_remaining = 0.0
	impact_player.stop()
	hit_flash_remaining = 0.0
	# Any Resurrection Ship is left behind; after the quiet period another may find the fleet.
	if left_resurrection:
		resurrection_cooldown_remaining = resurrection_cooldown_now()
	resurrection_alert_player.stop()
	resurrection_alert_pending = false
	resurrection_check_remaining = maxf(5.0, resurrection_check_seconds)
	jump_player.volume_db = jump_volume_db
	jump_player.play()
	own_fire_remaining = own_missile_interval
	launch_cooldown_remaining = 0.0
	ftl_recharge_remaining = maxf(1.0, ftl_recharge_seconds)
	safe_remaining = maxf(1.0, post_jump_safe_seconds)
	spawn_countdown = 0.8
	wave_countdown = 0.0
	jumps_used += 1
	_set_status("FTL JUMP COMPLETE | -%d POINTS | DAMAGE RETAINED" % ftl_score_cost, safe_remaining)
	if ftl_flash_enabled:
		ftl_flash_remaining = maxf(0.3, ftl_flash_seconds)
	ftl_jumped.emit()
	return true

func _set_status(message: String, seconds: float) -> void:
	status_message = message
	status_remaining = seconds

func reset_battle() -> void:
	active_difficulty = clampi(difficulty, 0, 2)
	auto_battery_started = false
	auto_firewall_started = false
	explosions.clear()
	screen_flash_remaining = 0.0
	screen_flash_peak = 0.0
	last_boom = {"missile": -INF, "nuke": -INF, "craft": -INF, "heavy": -INF, "capital": -INF}
	booms_played = {"missile": 0, "nuke": 0, "craft": 0, "heavy": 0, "capital": 0}
	nuke_hits_landed = 0
	viper_squadrons.clear()
	auto_battery_starts = 0
	auto_firewall_starts = 0
	auto_viper_launches = 0
	auto_raptor_launches = 0
	auto_ftl_jumps = 0
	auto_repairs = 0
	craft_explosions = 0
	capital_explosions = 0
	ftl_flash_remaining = 0.0
	contacts.clear()
	pending.clear()
	impacts.clear()
	next_id = 1
	hull = max_hull
	repair_delay_remaining = 0.0
	repair_elapsed = 0.0
	own_fire_remaining = own_missile_interval
	basestars_destroyed = 0
	own_missile_hits = 0
	identification_count = 0
	double_missile_unlocked_at = -1.0
	bonus_chimes = 0
	emp_charges = 0
	firewall_out_since = -1.0
	emp_offer_open = false
	viper_claims.clear()
	squadron_patrol_angle = 0.0
	missile_retargets = 0
	emp_awards_earned = 0
	emp_uses = 0
	emp_heavies_overloaded = 0
	emp_heavies_docked = 0
	repair_sounds = 0
	if is_instance_valid(repair_sound_player):
		repair_sound_player.stop()
	battery_kill_score = 0
	ship_nuke_hits = 0
	ship_nuke_kills = 0
	klaxon_count = 0
	klaxon_queue.clear()
	klaxon_player.stop()
	_stop_special_audio()
	prox_burst_remaining = maxf(0.1, prox_burst_seconds)
	prox_cooldown_remaining = 0.0
	battery_idle = 0.0
	vipers_lost = 0
	raiders_docked = 0
	raptor_cooldown_remaining = 0.0
	nuclear_alarm_remaining = 0.0
	battle_time = 0.0
	nuclear_alert_count = 0
	nuclear_beep_count = 0
	nuclear_launches = 0
	nuclear_intercepts = 0
	nuclear_hits = 0
	raptor_evades = 0
	raptors_lost = 0
	raptors_returned = 0
	vipers_returned = 0
	raptor_missile_hits = 0
	score = 0
	earned_points = 0
	repair_bonuses_earned = 0
	repair_charges = 1
	heavy_raiders_destroyed = 0
	wave = 1
	resurrection_alert_pending = false
	resurrection_alert_count = 0
	resurrection_check_remaining = maxf(5.0, resurrection_check_seconds)
	resurrection_cooldown_remaining = 0.0
	resurrection_spawns = 0
	resurrections_destroyed = 0
	resurrection_barrages = 0
	resurrection_missiles_fired = 0
	resurrection_hits_by = {"ship": 0, "raptor": 0, "viper": 0}
	own_volley_count = 0
	firewall_active = false
	firewall_charge = maxf(1.0, firewall_seconds)
	firewall_idle = 0.0
	firewall_uses = 0
	resurrections_escaped = 0
	fighter_points_lost = 0
	viper_evades = 0
	fighter_losses_by = {"raider": 0, "flak": 0, "returning": 0}
	hit_flash_remaining = 0.0
	impact_sound_count = 0
	impact_player.stop()
	scored_contacts.clear()
	rapid_repair_used = false
	rapid_repair_remaining = 0.0
	rapid_repair_rate = 0.0
	prox_active = false
	ftl_recharge_remaining = 0.0 if ftl_starts_ready else ftl_recharge_seconds
	safe_remaining = 0.0
	launch_cooldown_remaining = 0.0
	missile_hits = 0
	prox_kills = 0
	missile_intercepts = 0
	jumps_used = 0
	intercepted_count = 0
	spawn_count = 0
	beep_count = 0
	launch_sound_count = 0
	spawn_countdown = 0.8
	wave_countdown = wave_interval_seconds
	arrival_player.stop()
	launch_player.stop()
	_set_status("DEFEND THE LOWER SCOPE | FTL IS YOUR ESCAPE", 4.0)
	if auto_spawn:
		pending.append({"kind": "unknown", "faction": "unknown"})

func speed_for_kind(kind: String) -> float:
	if Icons.is_viper(kind):
		return maxf(0.001, viper_speed)
	if kind in CAPITAL_KINDS:
		return 0.0
	if kind == "missile":
		return missile_speed
	if kind == "heavy_raider":
		return heavy_raider_speed
	if kind in SMALL_HOSTILE_KINDS:
		return maxf(0.001, small_hostile_speed)
	return maxf(0.001, normal_ship_speed)

func size_for_kind(kind: String) -> float:
	if kind == "baseship":
		return baseship_icon_scale
	if kind == "resurrection_ship":
		return resurrection_icon_scale
	if kind == "heavy_raider":
		return small_ship_icon_scale * 1.20
	if kind == "viper" or kind == "raider":
		return small_ship_icon_scale
	return 1.0

func count_vipers() -> int:
	var count := 0
	for contact in contacts:
		if Icons.is_viper(contact.kind):
			count += 1
	return count

func count_tracks() -> int:
	return count_kind("baseship") + count_kind("unknown") + count_kind("raider") + count_kind("heavy_raider") + count_kind("resurrection_ship")

func launch_vipers() -> int:
	if is_defeated() or safe_remaining > 0.0 or launch_cooldown_remaining > 0.0:
		return 0
	var launched := 0
	for index in range(mini(vipers_per_launch, maxi(0, max_vipers - count_vipers()))):
		if not _spawn_viper("viper", false).is_empty():
			launched += 1
	if launched > 0:
		launch_cooldown_remaining = launch_cooldown_seconds
		_play_launch(launched)
	return launched

func launch_origin(lane: float = 0.0) -> Vector3:
	# The latest field model places the unseen ship at the lower scope edge.
	return own_ship_position + Vector3(lane / 640.0, 0.0, 0.0)

func _spawn_viper(kind: String, play_sound: bool) -> String:
	if kind != "viper" or count_vipers() >= max_vipers or is_defeated() or safe_remaining > 0.0:
		return ""
	var contact_id := "F-%03d" % next_id
	next_id += 1
	var lane := -22.0 if next_id % 2 == 0 else 22.0
	var origin := launch_origin(lane)
	contacts.append({
		"id": contact_id, "kind": kind, "faction": "friendly",
		"start": origin, "finish": Vector3.ZERO, "position": origin,
		"progress": 0.0, "age": 0.0, "duration": sortie_seconds,
		"phase": "launch", "target_id": "", "lane": lane,
		"patrol_angle": rng.randf_range(0.0, TAU), "velocity": Vector3.ZERO,
		"health": maxi(1, viper_hit_points), "max_health": maxi(1, viper_hit_points)
	})
	spawn_count += 1
	contact_spawned.emit(contact_id, kind, "friendly")
	if play_sound:
		_play_launch(1)
	queue_redraw()
	return contact_id

func _play_launch(count: int) -> void:
	if not launch_sound_enabled:
		return
	launch_player.volume_db = launch_volume_db
	launch_player.play()
	launch_sound_count += 1
	viper_launch_played.emit(count)

func _hostile_target(viper: Dictionary, excluded: Array[String]) -> Dictionary:
	# Raiders and missiles keep Vipers busy; they break away for Heavy Raiders only when clear.
	var primary := _viper_target_of(viper, excluded, ["raider", "missile"])
	if not primary.is_empty():
		return primary
	var heavy := _viper_target_of(viper, excluded, ["heavy_raider"])
	if not heavy.is_empty():
		return heavy
	# Last: the Resurrection Ship, the only capital ship Vipers will attack.
	return _viper_target_of(viper, excluded, ["resurrection_ship"])

## 1.07: slot position in the shared Viper patrol formation (a shallow V).
func formation_point(slot: int, count: int) -> Vector3:
	var centre := Vector3(cos(squadron_patrol_angle) * 0.30, -0.10 + sin(squadron_patrol_angle) * 0.20, 0.0)
	var spread := float(slot) - 0.5 * float(maxi(1, count) - 1)
	return centre + Vector3(spread * formation_spacing, -absf(spread) * formation_spacing * 0.45, 0.0)

func _viper_target_of(viper: Dictionary, excluded: Array[String], kinds: Array) -> Dictionary:
	var closest: Dictionary = {}
	var distance := INF
	for other in contacts:
		if other.faction != "hostile" or other.kind not in kinds or other.id in excluded:
			continue
		var candidate: float = viper.position.distance_to(other.position)
		# Hold a central defensive screen instead of chasing freshly launched
		# fighters beside the distant Basestars.
		if other.kind == "raider":
			if other.position.y > 0.42 and other.get("phase", "") != "return":
				continue
			candidate += Vector2(other.position.x, other.position.y).length() * 1.5
			# Returning Raiders are low on fuel and ammunition: easier prey.
			if other.get("phase", "") == "return":
				candidate *= 0.5
		if other.kind == "heavy_raider":
			if other.position.y > 0.42:
				continue
			candidate *= 0.08 if other.phase in ["hacking", "draining"] else 0.5
		# Nearby incoming missiles take priority, but still require physical pursuit.
		if other.kind == "missile" and other.position.distance_to(own_ship_position) < 0.65:
			candidate *= 0.35
		if other.id == viper.target_id:
			candidate *= 0.55
		elif squadrons_split_to_engage:
			# 1.07: spread out over targets squadron mates are not already chasing.
			var claims: int = viper_claims.get(other.id, 0)
			if other.kind in ["heavy_raider", "resurrection_ship"]:
				if claims >= max_vipers_per_tough_target:
					candidate *= squadron_spread_penalty
			elif claims >= 1:
				candidate *= squadron_spread_penalty
		if candidate < distance:
			distance = candidate
			closest = other
	return closest

func _update_vipers(delta: float) -> void:
	var removed: Array[String] = []
	# 1.07: who is chasing what, and the shared patrol formation for idle Vipers.
	viper_claims.clear()
	var patrol_slots: Array[String] = []
	if squadrons_split_to_engage:
		squadron_patrol_angle += delta * 0.16
		for other in contacts:
			if Icons.is_viper(other.kind) and other.get("phase", "") != "return":
				var claimed: String = other.get("target_id", "")
				if not claimed.is_empty():
					viper_claims[claimed] = int(viper_claims.get(claimed, 0)) + 1
				elif other.get("phase", "") == "patrol":
					patrol_slots.append(other.id)
		patrol_slots.sort()
	for viper in contacts.duplicate():
		if not Icons.is_viper(viper.kind):
			continue
		viper.heavy_fire_remaining = maxf(0.0, viper.get("heavy_fire_remaining", 0.0) - delta)
		viper.res_fire_remaining = maxf(0.0, viper.get("res_fire_remaining", 0.0) - delta)
		if viper.age >= sortie_seconds:
			viper.phase = "return"
			viper.target_id = ""
		if viper.phase == "return":
			var home := launch_origin(viper.lane)
			_steer(viper, home, viper_speed, delta)
			if viper.position.distance_to(home) < 0.025:
				removed.append(viper.id)
				vipers_returned += 1
				_set_status("VIPER RECOVERED | SORTIE COMPLETE, NOT DESTROYED", 3.0)
			continue
		if viper.phase == "launch":
			var entry := Vector3(viper.lane / 320.0, -0.68, -0.35)
			_steer(viper, entry, viper_speed, delta)
			if viper.position.distance_to(entry) < 0.025:
				viper.phase = "intercept"
			continue
		var old_claim: String = viper.get("target_id", "")
		if squadrons_split_to_engage and not old_claim.is_empty():
			viper_claims[old_claim] = maxi(0, int(viper_claims.get(old_claim, 0)) - 1)
		var target := _hostile_target(viper, removed)
		if not target.is_empty():
			viper.phase = "intercept"
			viper.target_id = target.id
			if squadrons_split_to_engage:
				viper_claims[target.id] = int(viper_claims.get(target.id, 0)) + 1
			_steer(viper, target.position, viper_speed, delta)
			if target.kind == "resurrection_ship":
				if viper.position.distance_to(target.position) <= 0.08 and viper.res_fire_remaining <= 0.0:
					_hit_resurrection(target, viper_resurrection_damage, "viper")
					viper.res_fire_remaining = maxf(0.5, viper_resurrection_hit_interval)
				continue
			if viper.position.distance_to(target.position) <= 0.05:
				if target.kind == "heavy_raider":
					if viper.heavy_fire_remaining <= 0.0:
						_hit_heavy_raider(target)
						viper.heavy_fire_remaining = 0.8
					continue
				# Prototype outcome: reaching a hostile clears that contact.
				removed.append(target.id)
				_award_destroyed(target)
				impacts.append({"position": target.position, "age": 0.0})
				intercepted_count += 1
				if target.kind == "missile":
					missile_intercepts += 1
					_explode(target.position, "missile")
				hostile_intercepted.emit(viper.id, target.id)
				viper.target_id = ""
		else:
			viper.phase = "patrol"
			viper.target_id = ""
			if squadrons_split_to_engage:
				# 1.07: idle Vipers fly back and rejoin one shared patrol formation.
				if viper.id not in patrol_slots:
					patrol_slots.append(viper.id)
					patrol_slots.sort()
				_steer(viper, formation_point(patrol_slots.find(viper.id), patrol_slots.size()), viper_speed, delta)
				continue
			viper.patrol_angle += delta * 0.16
			var patrol := Vector3(cos(viper.patrol_angle) * 0.30,
				-0.10 + sin(viper.patrol_angle) * 0.20, 0.0)
			_steer(viper, patrol, viper_speed, delta)
	for index in range(contacts.size() - 1, -1, -1):
		if contacts[index].id in removed:
			contacts.remove_at(index)

func projection(world: Vector3) -> Dictionary:
	var dome := get_parent()
	var radius: float = dome.sphere_radius
	var focal := maxf(2.0, perspective_distance)
	var depth_scale := focal / (focal + world.z * depth_strength)
	return {
		"point": size * 0.5 + Vector2(world.x, -world.y) * radius * depth_scale,
		"scale": depth_scale * (radius / 320.0) * icon_size
	}

func _draw() -> void:
	for impact in impacts:
		var point: Vector2 = projection(impact.position).point
		var color := Color(1.0, 0.45, 0.3, (1.0 - impact.age / 0.45) * 0.8)
		if impact.get("battery", false):
			color = Color(1.0, 0.89, 0.42, (1.0 - impact.age / 0.45) * 0.95)
			draw_arc(point, 5.0 + impact.age * 40.0, 0.0, TAU, 24, color, 2.0, true)
			draw_circle(point, 4.0 * (1.0 - impact.age / 0.45), color)
			continue
		draw_arc(point, 7.0 + impact.age * 20.0, 0.0, TAU, 24, color, 1.0, true)
	var ordered := contacts.duplicate()
	# Paint far contacts first; near contacts remain on top.
	ordered.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.position.z > b.position.z)
	var font := ThemeDB.fallback_font
	# 1.06: ships first, then explosions, then every missile, nuke and flak shot
	# on top so they are never hidden on a crowded scope.
	var projectiles: Array = []
	for contact in ordered:
		if contact.kind in PROJECTILE_KINDS:
			projectiles.append(contact)
			continue
		_draw_contact(contact, font)
	_draw_viper_squadrons(font)
	_draw_explosions()
	for contact in projectiles:
		_draw_contact(contact, font)
	_draw_ftl_flash()

## Missiles, nukes and flak: drawn after (on top of) everything else (1.06).
const PROJECTILE_KINDS := ["missile", "own_missile", "raptor_missile", "nuke", "flak"]

## 1.07: the tag shown under a contact ("" = none). Short tags unless Show Full Tags.
func contact_tag(contact: Dictionary) -> String:
	var text: String = contact.id
	if contact.kind == "unknown":
		text = "IDENTIFYING"
	elif contact.kind == "baseship":
		text = "BASESTAR %d%%" % ceili(100.0 * contact.hits_remaining / contact.max_hits)
	elif contact.kind == "resurrection_ship":
		text = "RESURRECTION %d%%" % ceili(100.0 * contact.hits_remaining / contact.max_hits)
	elif contact.kind == "nuke":
		text = "NUCLEAR"
		if contact.has("nuke_hits") and contact.nuke_hits < contact.nuke_max_hits:
			text += " %d%%" % ceili(100.0 * contact.nuke_hits / contact.nuke_max_hits)
	elif contact.kind == "heavy_raider":
		text = "HEAVY RAIDER"
		if contact.phase == "hacking":
			text = "HACKING %ds" % ceili(contact.hack_remaining)
		elif contact.phase == "draining":
			text = "HULL DRAIN"
		elif contact.phase == "emp":
			text = "EMP OVERLOAD"
		elif contact.phase == "emp_return":
			text = "HEAVY RAIDER RTB"
	elif contact.kind in ["viper", "raider", "raptor"] and not show_full_tags:
		text = contact.kind.to_upper()
	elif contact.kind in ["missile", "own_missile", "raptor_missile"] and not show_full_tags:
		text = ""
	elif contact.kind in ["viper", "raider", "raptor"]:
		text = contact.kind.to_upper() + " " + contact.id
		if contact.get("phase", "") == "return":
			text += " RTB"
		# Damaged Vipers and Raptors show their remaining strength.
		if contact.kind in ["viper", "raptor"] and int(contact.get("health", 1)) < int(contact.get("max_health", 1)):
			text += " %d%%" % fighter_health_percent(contact)
	elif contact.kind == "flak":
		text = ""
	return text

func _draw_contact(contact: Dictionary, font: Font) -> void:
	if contact.kind == "viper" and squadron_of(contact.id) != -1:
		return  # drawn once as a squadron
	var projected := projection(contact.position)
	var point: Vector2 = projected.point
	var marker_scale: float = projected.scale * size_for_kind(contact.kind)
	var color := display_color(contact)
	var state_alpha: float = color.a
	if contact.kind == "nuke":
		color = Color(1.0, 0.85, 0.2) if int(battle_time * 5.0) % 2 == 0 else Color(1.0, 0.12, 0.15)
		draw_arc(point, 16.0 * marker_scale, 0.0, TAU, 32, color, 2.0, true)
	# A short arrival flash, not a repeated spawn or repeated sound.
	var flash := maxf(0.0, 1.0 - contact.age / 0.7)
	color.a = (0.88 + 0.12 * flash) * state_alpha
	if flash > 0.0:
		var halo := color
		halo.a = flash * 0.38
		draw_arc(point, (18.0 + (1.0 - flash) * 9.0) * marker_scale, 0.0, TAU, 40, halo, 1.0, true)
	if contact.kind in ["missile", "own_missile", "raptor_missile", "nuke", "flak"]:
		var aim: Vector2 = projection(contact.get("target_position", own_ship_position)).point
		var direction := point.direction_to(aim)
		var side := Vector2(-direction.y, direction.x)
		var length_scale := 1.8 if contact.kind == "nuke" else (0.65 if contact.kind in ["raptor_missile", "flak"] else 1.0)
		var arrow := PackedVector2Array([
			point + direction * 6.0 * length_scale,
			point - direction * 4.0 * length_scale + side * 2.5 * length_scale,
			point - direction * 4.0 * length_scale - side * 2.5 * length_scale])
		draw_colored_polygon(arrow, color)
		# Smoothing: an anti-aliased edge softens the filled triangle's jagged sides.
		arrow.append(arrow[0])
		draw_polyline(arrow, color, 1.0, true)
		draw_line(point - direction * 5.0, point - direction * 12.0, Color(color, 0.45), 1.0, true)
	else:
		Icons.draw_icon(self, contact.kind, point, marker_scale, color)
	if show_labels:
		var font_size := label_font_size + (2 if contact.kind in ["baseship", "resurrection_ship", "unknown"] else 0)
		var text: String = contact_tag(contact)
		if text.is_empty():
			return
		var label_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var label_point := point + Vector2(-label_size.x * 0.5, 29.0 * marker_scale)
		if contact.kind == "nuke":
			# Above the warhead, so it stays clear of a Raptor chasing it from below.
			label_point = point + Vector2(-label_size.x * 0.5, -22.0 * marker_scale)
		draw_string_outline_and_text(font, label_point, text, font_size, label_color(color))
	if contact.kind == "heavy_raider" and contact.get("phase", "") == "emp":
		_draw_emp_sparks(point, marker_scale, contact)

func label_color(icon_color: Color) -> Color:
	# Slightly lighter than the icon, at full strength unless the ship is flashing.
	var lighter := Color(icon_color.r, icon_color.g, icon_color.b).lerp(Color.WHITE, clampf(label_brighten, 0.0, 0.6))
	lighter.a = clampf(icon_color.a / 0.88, 0.0, 1.0)
	return lighter

func draw_string_outline_and_text(font: Font, at: Vector2, text: String, font_size: int, color: Color) -> void:
	if label_outline_size > 0:
		var edge := label_outline_color
		edge.a *= color.a
		draw_string_outline(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, label_outline_size, edge)
	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

func hull_percent() -> int:
	if is_defeated():
		return 0
	return clampi(ceili(hull / maxf(1.0, max_hull) * 100.0), 1, 100)

func ftl_percent() -> int:
	if ftl_recharge_remaining <= 0.0:
		return 100
	return clampi(1 + floori(99.0 * (1.0 - ftl_recharge_remaining / maxf(1.0, ftl_recharge_seconds))), 1, 99)

func _update_repair(delta: float) -> void:
	if is_defeated() or hull >= max_hull:
		return
	var available := maxf(0.0, delta - repair_delay_remaining)
	repair_delay_remaining = maxf(0.0, repair_delay_remaining - delta)
	repair_elapsed += available
	while repair_elapsed >= maxf(1.0, repair_tick_seconds):
		repair_elapsed -= maxf(1.0, repair_tick_seconds)
		hull = minf(max_hull, hull + max_hull * 0.01)
		if hull >= max_hull:
			repair_elapsed = 0.0
			break

func count_base_raiders(id: String, include_pending: bool = false) -> int:
	var total := 0
	for contact in contacts:
		if contact.kind == "raider" and contact.get("origin_id", "") == id:
			total += 1
	if include_pending:
		for request in pending:
			if request.kind == "raider" and request.get("origin_id", "") == id:
				total += 1
	return total

func _identify_basestar(contact: Dictionary) -> void:
	if contact.kind != "unknown":
		return
	# Preserve track ID and exact position; only classification changes.
	contact.kind = "baseship"
	contact.faction = "hostile"
	contact.hits_remaining = float(maxi(2, scaled_hits(basestar_hits_to_destroy)))
	contact.max_hits = contact.hits_remaining
	contact.nuclear_launched = false
	contact.nuclear_timer = maxf(1.0, nuclear_launch_delay) / attack_rate()
	contact.flak_timer = maxf(2.0, basestar_flak_interval) / attack_rate()
	contact.heavy_timer = maxf(5.0, heavy_launch_interval) / attack_rate()
	identification_count += 1
	if klaxon_enabled:
		klaxon_queue.append(contact.id)
	_set_status("HOSTILE BASESTAR IDENTIFIED | AUTOMATIC MISSILES ARMED", 3.0)
	basestar_identified.emit(contact.id)
	_update_klaxon()

func _update_klaxon() -> void:
	klaxon_player.volume_db = klaxon_volume_db
	if not klaxon_enabled:
		klaxon_queue.clear()
		return
	if count_kind("nuke") > 0:
		return
	# Wait while the Resurrection Ship alert plays so the two never overlap.
	if not klaxon_player.playing and (resurrection_alert_player == null or not resurrection_alert_player.playing):
		while not klaxon_queue.is_empty():
			var id: String = klaxon_queue.pop_front()
			if not find_contact(id).is_empty():
				klaxon_player.play()
				klaxon_count += 1
				break

func _update_own_weapons(delta: float) -> void:
	if is_defeated() or safe_remaining > 0.0:
		return
	# Work from IDs: a hit may remove its target and other missiles safely.
	var missile_ids: Array[String] = []
	for contact in contacts:
		if contact.kind in ["own_missile", "raptor_missile"]:
			missile_ids.append(contact.id)
	for id in missile_ids:
		var missile := find_contact(id)
		if missile.is_empty():
			continue
		var target := find_contact(missile.target_id)
		if target.is_empty() or target.kind not in MISSILE_TARGET_KINDS:
			# 1.07: turn toward the nearest valid enemy instead of being wasted.
			target = missile_retarget(missile)
			if target.is_empty():
				_remove_contact(id)
				continue
			missile.target_id = target.id
			missile_retargets += 1
		missile.target_position = target.position
		missile.position = missile.position.move_toward(target.position, delta * movement_speed * own_missile_speed)
		if missile.position.distance_to(target.position) <= 0.025:
			_remove_contact(id)
			if target.kind == "nuke":
				_ship_hit_nuke(target)
			elif target.kind == "heavy_raider":
				_hit_heavy_raider(target)
			elif target.kind == "resurrection_ship":
				_hit_resurrection(target, missile.get("damage", 1.0), "raptor" if missile.kind == "raptor_missile" else "ship")
			else:
				_hit_basestar(target, missile.get("damage", 1.0), missile.kind == "raptor_missile")
	own_fire_remaining = maxf(0.0, own_fire_remaining - delta)
	if not own_weapons_enabled or own_fire_remaining > 0.0 or count_kind("own_missile") >= max_own_missiles:
		return
	# One missile per volley, or two with the Double Missile bonus.
	var fired := 0
	for shot in range(missiles_per_volley()):
		if count_kind("own_missile") >= max_own_missiles or not _fire_ship_missile():
			break
		fired += 1
	if fired > 0:
		own_fire_remaining = maxf(2.0, own_missile_interval)
	# Own weapons are not newly detected contacts: no arrival beep.

## 1.05: ship missiles per volley (2 once the Double Missile bonus is active).
func missiles_per_volley() -> int:
	return 2 if double_missile_active() else 1

## Picks one target and launches one ship missile. Returns false when nothing is in reach.
## 1.07: the nearest enemy a ship or Raptor missile may attack. A nuke is skipped when
## enough ship missiles are already flying at it for the hits it still needs.
func missile_retarget(missile: Dictionary) -> Dictionary:
	var best: Dictionary = {}
	var closest := INF
	for contact in contacts:
		if contact.get("faction", "") != "hostile" or contact.kind not in MISSILE_TARGET_KINDS:
			continue
		if contact.kind == "nuke" and missile.kind == "own_missile" and _missiles_at(contact.id) >= nuke_hits_left(contact):
			continue
		var gap: float = missile.position.distance_to(contact.position)
		if gap < closest:
			closest = gap
			best = contact
	return best

func _fire_ship_missile() -> bool:
	var target := ship_nuke_target()
	if not target.is_empty():
		_launch_ship_missile(target)
		return true
	# Close Heavy Raiders come next; one missile in flight per remaining hit point.
	var nearest := INF
	for contact in contacts:
		if contact.kind != "heavy_raider":
			continue
		var gap: float = contact.position.distance_to(own_ship_position)
		if gap <= ship_missile_heavy_range and gap < nearest and _missiles_at(contact.id) < contact.health:
			nearest = gap
			target = contact
	if target.is_empty():
		for contact in contacts:
			if contact.kind == "baseship" and (target.is_empty() or contact.hits_remaining < target.hits_remaining):
				target = contact
		# With a Resurrection Ship present, every second missile goes to it
		# (all of them when no Basestar remains).
		for contact in contacts:
			if contact.kind == "resurrection_ship" and (target.is_empty() or own_volley_count % 2 == 1):
				target = contact
	if target.is_empty():
		return false
	if target.kind in ["baseship", "resurrection_ship"]:
		own_volley_count += 1
	_launch_ship_missile(target)
	return true

func _launch_ship_missile(target: Dictionary) -> void:
	var id := _new_id("P")
	contacts.append({"id": id, "kind": "own_missile", "faction": "friendly",
		"position": own_ship_position, "age": 0.0, "target_id": target.id,
		"target_position": target.position})

## Hits a nuke still needs (difficulty toughness applies), the same count Raptors use.
func nuke_hits_left(nuke: Dictionary) -> int:
	return int(nuke.get("nuke_hits", scaled_hits(nuclear_hit_points)))

## 1.05: share of its flight a nuke has covered (0 at launch, 1 at the ship).
func nuke_progress(nuke: Dictionary) -> float:
	var gap: float = nuke.position.distance_to(own_ship_position)
	var total: float = nuke.get("launch_distance", gap)
	if total <= 0.0:
		return 0.0
	return clampf(1.0 - gap / total, 0.0, 1.0)

## 1.05: the closest nuke past the target point that still needs more ship missiles
## than are already flying at it (never sends more missiles than hits left).
func ship_nuke_target() -> Dictionary:
	var target: Dictionary = {}
	if not ship_missiles_target_nukes:
		return target
	var closest := INF
	for contact in contacts:
		if contact.kind != "nuke":
			continue
		var gap: float = contact.position.distance_to(own_ship_position)
		if nuke_progress(contact) > ship_nuke_target_fraction and gap < closest and _missiles_at(contact.id) < nuke_hits_left(contact):
			closest = gap
			target = contact
	return target

## 1.05: a ship missile reaches a nuke. One hit, the same as a Raptor hit.
func _ship_hit_nuke(target: Dictionary) -> void:
	if target.is_empty() or find_contact(target.id).is_empty():
		return
	if not target.has("nuke_hits"):
		target.nuke_hits = scaled_hits(nuclear_hit_points)
		target.nuke_max_hits = target.nuke_hits
	target.nuke_hits -= 1
	nuke_hits_landed += 1
	ship_nuke_hits += 1
	impacts.append({"position": target.position, "age": 0.0})
	if target.nuke_hits > 0:
		_set_status("SHIP MISSILE HIT NUCLEAR MISSILE | %d MORE TO DESTROY" % target.nuke_hits, 2.0)
		return
	_award_destroyed(target)
	nuclear_intercepts += 1
	ship_nuke_kills += 1
	_explode(target.position, "nuke")
	_remove_contact(target.id)
	_set_status("SHIP MISSILE DESTROYED NUCLEAR MISSILE", 4.0)

func _missiles_at(target_id: String) -> int:
	var total := 0
	for contact in contacts:
		if contact.kind == "own_missile" and contact.get("target_id", "") == target_id:
			total += 1
	return total

func _hit_basestar(base: Dictionary, damage: float = 1.0, from_raptor: bool = false) -> void:
	if base.is_empty() or base.kind != "baseship" or find_contact(base.id).is_empty():
		return
	base.hits_remaining -= maxf(0.0, damage)
	if from_raptor:
		raptor_missile_hits += 1
	else:
		own_missile_hits += 1
	impacts.append({"position": base.position, "age": 0.0})
	if base.hits_remaining > 0:
		return
	var id: String = base.id
	_award_destroyed(base)
	_remove_contact(id)
	for index in range(pending.size() - 1, -1, -1):
		if pending[index].get("origin_id", "") == id:
			pending.remove_at(index)
	for index in range(contacts.size() - 1, -1, -1):
		if contacts[index].kind in ["own_missile", "raptor_missile"] and contacts[index].target_id == id:
			contacts[index].target_id = ""
	klaxon_queue.erase(id)
	basestars_destroyed += 1
	_set_status("BASESTAR DESTROYED | REMAINING RAIDERS STILL ACTIVE", 3.0)
	basestar_destroyed.emit(id)

func _remove_contact(id: String) -> void:
	for index in range(contacts.size() - 1, -1, -1):
		if contacts[index].id == id:
			contacts.remove_at(index)
			return

func _effect_player(node_name: String, effect: String, volume: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.name = node_name
	player.stream = BattleAudio.synth(effect)
	player.volume_db = volume
	add_child(player)
	return player

func _stop_special_audio() -> void:
	for player in [battery_player, jump_player, nuclear_player, nuclear_beep_player, impact_player, resurrection_alert_player, firewall_player]:
		if is_instance_valid(player):
			player.stop()
	nuclear_alert_queue.clear()
	nuclear_alert_contact_id = ""
	nuclear_alarm_remaining = 0.0

func _update_battery(delta: float) -> void:
	# Use meter: drains quickly while firing, recharges slowly whenever idle.
	prox_cooldown_remaining = 0.0
	battery_player.volume_db = battery_volume_db
	battery_player.pitch_scale = battery_sound_speed
	var full := maxf(0.1, prox_burst_seconds)
	if prox_active:
		battery_idle = 0.0
		prox_burst_remaining = maxf(0.0, prox_burst_remaining - delta)
		if prox_burst_remaining <= 0.0:
			_end_battery_burst()
		return
	if prox_burst_remaining >= full:
		prox_burst_remaining = full
		return
	var wait := maxf(0.0, battery_recharge_delay - battery_idle)
	battery_idle += delta
	var charging := maxf(0.0, delta - wait)
	if charging > 0.0:
		var was_full := prox_burst_remaining >= full
		prox_burst_remaining = minf(full, prox_burst_remaining + charging * full / battery_recharge_time())
		if not was_full and prox_burst_remaining >= full:
			_set_status("DEFENSE BATTERY FULLY CHARGED", 2.0)

## Full recharge time for the current battle's difficulty (Normal 24 s, Easy 19.2 s, Hard 31.2 s).
func battery_recharge_time() -> float:
	return maxf(1.0, battery_recharge_seconds * difficulty_factor(easy_battery_recharge, hard_battery_recharge))

func battery_percent() -> float:
	return 100.0 * clampf(prox_burst_remaining / maxf(0.1, prox_burst_seconds), 0.0, 1.0)

func can_fire_battery() -> bool:
	return not is_defeated() and safe_remaining <= 0.0 and (prox_active or battery_percent() >= maxf(1.0, battery_restart_percent))

func _end_battery_burst() -> void:
	prox_active = false
	battery_idle = 0.0
	battery_player.stop()
	if prox_burst_remaining <= 0.0:
		prox_burst_remaining = 0.0
		_set_status("DEFENSE BATTERY EMPTY | RECHARGING", 2.0)
	else:
		_set_status("DEFENSE BATTERY STOPPED | RECHARGING FROM %d%%" % int(battery_percent()), 2.0)

func count_returning(kind: String) -> int:
	var count := 0
	for contact in contacts:
		if contact.kind == kind and contact.get("phase", "") == "return":
			count += 1
	return count

func _launch_nuclear(base: Dictionary) -> String:
	if is_defeated() or safe_remaining > 0.0 or base.is_empty() or base.kind != "baseship":
		return ""
	if find_contact(base.id).is_empty() or base.get("nuclear_launched", false):
		return ""
	base.nuclear_launched = true  # Lifetime latch; never replenished on this track.
	var origin: Vector3 = base.position + base.position.direction_to(own_ship_position) * basestar_emission_radius
	var id := _new_id("N")
	contacts.append({"id": id, "kind": "nuke", "faction": "hostile",
		"position": origin, "age": 0.0, "origin_id": base.id, "target_position": own_ship_position,
		"launch_distance": origin.distance_to(own_ship_position)})
	nuclear_launches += 1
	nuclear_alert_queue.append(id)
	_set_status("NUCLEAR LAUNCH DETECTED | LAUNCH RAPTOR OR FTL JUMP", 6.0)
	return id

func _update_nuclear_alarm(delta: float) -> void:
	nuclear_player.volume_db = nuclear_alert_volume_db
	nuclear_player.pitch_scale = nuclear_alert_speed
	nuclear_beep_player.volume_db = nuclear_beep_volume_db
	if count_kind("nuke") == 0:
		nuclear_player.stop()
		nuclear_beep_player.stop()
		nuclear_alert_queue.clear()
		nuclear_alert_contact_id = ""
		nuclear_alarm_remaining = 0.0
		return
	# A threat that was intercepted or hit no longer owns an active warning.
	if not nuclear_alert_contact_id.is_empty() and find_contact(nuclear_alert_contact_id).is_empty():
		nuclear_player.stop()
		nuclear_alert_contact_id = ""
	if nuclear_player.playing:
		return
	while not nuclear_alert_queue.is_empty():
		var id: String = nuclear_alert_queue.pop_front()
		if find_contact(id).is_empty():
			continue
		nuclear_alert_contact_id = id
		klaxon_player.stop()
		nuclear_beep_player.stop()
		nuclear_player.play()
		nuclear_alert_count += 1
		nuclear_alarm_remaining = 0.0
		return
	# Only one approach-beep train, following the physically nearest nuke.
	var interval := nuclear_beep_interval()
	nuclear_alarm_remaining = minf(nuclear_alarm_remaining, interval) - delta
	if nuclear_alarm_remaining <= 0.0:
		nuclear_beep_player.play()
		nuclear_beep_count += 1
		nuclear_alarm_remaining = interval

func nuclear_beep_interval() -> float:
	var nearest: Dictionary = {}
	var distance := INF
	for contact in contacts:
		if contact.kind == "nuke":
			var candidate: float = contact.position.distance_to(own_ship_position)
			if candidate < distance:
				distance = candidate
				nearest = contact
	if nearest.is_empty():
		return nuclear_beep_far_seconds
	var fraction := clampf(distance / maxf(0.01, nearest.get("launch_distance", distance)), 0.0, 1.0)
	return lerpf(nuclear_beep_near_seconds, maxf(nuclear_beep_near_seconds, nuclear_beep_far_seconds), fraction)

func launch_raptor() -> int:
	if raptor_cooldown_remaining > 0.0:
		return 0
	var id := _spawn_raptor()
	if id.is_empty():
		return 0
	raptor_cooldown_remaining = maxf(1.0, raptor_launch_cooldown)
	return 1

func _spawn_raptor() -> String:
	if is_defeated() or safe_remaining > 0.0 or count_kind("raptor") >= max_raptors:
		return ""
	var id := _new_id("R")
	var lane := -35.0 if next_id % 2 == 0 else 35.0
	var origin := launch_origin(lane)
	contacts.append({"id": id, "kind": "raptor", "faction": "friendly",
		"position": origin, "age": 0.0, "phase": "launch", "lane": lane,
		"velocity": Vector3.ZERO, "target_id": "", "fire_timer": 2.0,
		"health": maxi(1, raptor_hit_points), "max_health": maxi(1, raptor_hit_points),
		"patrol_angle": rng.randf_range(0.0, TAU)})
	spawn_count += 1
	contact_spawned.emit(id, "raptor", "friendly")
	_play_launch(1)
	_set_status("RAPTOR LAUNCHED | NUCLEAR INTERCEPTION PRIORITY", 3.0)
	return id

func _raptor_target(raptor: Dictionary, removed: Array[String]) -> Dictionary:
	var chosen: Dictionary = {}
	var best := INF
	# Nukes outrank capital attacks regardless of current task.
	for contact in contacts:
		if contact.kind != "nuke" or contact.id in removed:
			continue
		var score: float = contact.position.distance_to(own_ship_position)
		if contact.id == raptor.target_id:
			score *= 0.8
		if score < best:
			best = score
			chosen = contact
	if not chosen.is_empty():
		return chosen
	# After nuclear defense, stop computer hackers before attacking capitals,
	# unless this Raptor is currently under Basestar flak attack.
	var under_fire := false
	for bolt in contacts:
		if bolt.kind == "flak" and bolt.get("target_id", "") == raptor.id:
			under_fire = true
	for contact in contacts:
		if under_fire or contact.kind != "heavy_raider" or contact.id in removed:
			continue
		var priority: float = raptor.position.distance_to(contact.position)
		if contact.phase in ["hacking", "draining"]:
			priority *= 0.1
		if priority < best:
			best = priority
			chosen = contact
	if not chosen.is_empty():
		return chosen
	for contact in contacts:
		if contact.kind in ["baseship", "resurrection_ship"]:
			var score: float = raptor.position.distance_to(contact.position)
			# Raptors prefer the Resurrection Ship over Basestars.
			if contact.kind == "resurrection_ship":
				score *= 0.6
			if contact.id == raptor.target_id:
				score *= 0.7
			if score < best:
				best = score
				chosen = contact
	return chosen

func _update_raptors(delta: float) -> void:
	var removed: Array[String] = []
	for raptor in contacts.duplicate():
		if raptor.kind != "raptor":
			continue
		raptor.fire_timer = maxf(0.0, raptor.fire_timer - delta)
		raptor.heavy_fire_remaining = maxf(0.0, raptor.get("heavy_fire_remaining", 0.0) - delta)
		raptor.nuke_fire_remaining = maxf(0.0, raptor.get("nuke_fire_remaining", 0.0) - delta)
		var speed := minf(raptor_speed, viper_speed * 0.9)
		if raptor.age >= raptor_sortie_seconds:
			raptor.phase = "return"
		if raptor.phase == "return":
			_steer(raptor, launch_origin(raptor.lane), speed, delta)
			if raptor.position.distance_to(launch_origin(raptor.lane)) <= 0.03:
				removed.append(raptor.id)
				raptors_returned += 1
				_set_status("RAPTOR RECOVERED | SORTIE COMPLETE", 3.0)
			continue
		if raptor.phase == "launch":
			var entry := Vector3(raptor.lane / 320.0, -0.66, -0.15)
			_steer(raptor, entry, speed, delta)
			if raptor.position.distance_to(entry) <= 0.03:
				raptor.phase = "patrol"
			continue
		var target := _raptor_target(raptor, removed)
		var destination := Vector3(sin(battle_time * 0.1 + raptor.lane) * 0.25, -0.2, 0.05)
		if not target.is_empty():
			raptor.target_id = target.id
			if target.kind in ["nuke", "heavy_raider"]:
				raptor.phase = "intercept"
				destination = target.position
			else:
				raptor.phase = "attack"
				destination = target.position + target.position.direction_to(own_ship_position) * 0.38
				if raptor.position.distance_to(target.position) < 0.85 and raptor.fire_timer <= 0.0 and count_kind("raptor_missile") < 4:
					var id := _new_id("RM")
					contacts.append({"id": id, "kind": "raptor_missile", "faction": "friendly",
						"position": raptor.position, "age": 0.0, "target_id": target.id,
						"target_position": target.position, "damage": clampf(raptor_missile_damage, 0.1, 0.9)})
					raptor.fire_timer = maxf(1.0, raptor_fire_interval)
		else:
			raptor.phase = "patrol"
			raptor.target_id = ""
		for bolt in contacts:
			if bolt.kind == "flak" and bolt.target_id == raptor.id and bolt.position.distance_to(raptor.position) < 0.28:
				# Small lateral evasive movement, still acceleration limited.
				destination += Vector3(sin(battle_time * 2.0 + raptor.lane) * 0.16, 0.04, 0.0)
				break
		_steer(raptor, destination, speed, delta)
		if not target.is_empty() and target.kind == "heavy_raider" and raptor.position.distance_to(target.position) <= 0.08 and raptor.heavy_fire_remaining <= 0.0:
			_hit_heavy_raider(target)
			raptor.heavy_fire_remaining = 1.2
		if not target.is_empty() and target.kind == "nuke" and raptor.position.distance_to(target.position) <= 0.08 and raptor.nuke_fire_remaining <= 0.0:
			# Nukes take several hits, so the Raptor has to stay with it.
			if not target.has("nuke_hits"):
				target.nuke_hits = scaled_hits(nuclear_hit_points)
				target.nuke_max_hits = target.nuke_hits
			target.nuke_hits -= 1
			nuke_hits_landed += 1
			raptor.nuke_fire_remaining = maxf(0.1, raptor_nuke_hit_interval)
			impacts.append({"position": target.position, "age": 0.0})
			if target.nuke_hits > 0:
				_set_status("RAPTOR HIT NUCLEAR MISSILE | %d MORE TO DESTROY" % target.nuke_hits, 2.0)
				continue
			removed.append(target.id)
			_award_destroyed(target)
			nuclear_intercepts += 1
			_explode(target.position, "nuke")
			_set_status("RAPTOR DESTROYED NUCLEAR MISSILE", 4.0)
	for id in removed:
		_remove_contact(id)

func _fire_flak(base: Dictionary) -> String:
	if count_kind("flak") >= 8:
		return ""
	var target: Dictionary = {}
	var nearest := basestar_flak_range
	for contact in contacts:
		if contact.kind == "raptor":
			var distance: float = base.position.distance_to(contact.position)
			if distance < nearest:
				nearest = distance
				target = contact
	if target.is_empty():
		return ""
	var id := _new_id("FL")
	var origin: Vector3 = base.position + base.position.direction_to(target.position) * basestar_emission_radius
	contacts.append({"id": id, "kind": "flak", "faction": "hostile", "position": origin,
		"age": 0.0, "target_id": target.id, "target_position": target.position})
	return id

func _update_special_projectiles(delta: float) -> void:
	for projectile in contacts.duplicate():
		if projectile.kind == "nuke":
			projectile.position = projectile.position.move_toward(own_ship_position, nuclear_speed * nuke_speed_factor() * movement_speed * delta)
			if projectile.position.distance_to(own_ship_position) <= missile_impact_radius:
				_remove_contact(projectile.id)
				nuclear_hits += 1
				impacts.append({"position": own_ship_position, "age": 0.0})
				_explode(own_ship_position, "nuke_impact")
				apply_damage(nuclear_damage * damage_factor())
				if is_defeated():
					return
				_set_status("NUCLEAR IMPACT | HULL SEVERELY DAMAGED", 4.0)
		elif projectile.kind == "flak":
			var target := find_contact(projectile.target_id)
			if target.is_empty() or target.kind != "raptor" or projectile.age > 12.0:
				_remove_contact(projectile.id)
				continue
			projectile.target_position = target.position
			projectile.position = projectile.position.move_toward(target.position, 0.18 * movement_speed * delta)
			if projectile.position.distance_to(target.position) <= 0.025:
				_remove_contact(projectile.id)
				var evasion := returning_raptor_evasion_chance if target.get("phase", "") == "return" else raptor_evasion_chance
				if rng.randf() < clampf(evasion, 0.0, 0.95):
					raptor_evades += 1
					_set_status("RAPTOR EVADED BASESTAR FIRE", 2.0)
				else:
					_damage_fighter(target, "BASESTAR FIRE")

func _award_destroyed(contact: Dictionary) -> void:
	if is_defeated() or contact.is_empty() or scored_contacts.has(contact.id) or find_contact(contact.id).is_empty():
		return
	var points := 0
	match contact.kind:
		"raider": points = fighter_points
		"heavy_raider": points = heavy_raider_points
		"nuke": points = nuclear_points
		"baseship": points = basestar_points
		"resurrection_ship": points = resurrection_points
		_: return
	scored_contacts[contact.id] = true
	_destruction_effect(contact)
	_add_points(points_for(points))

## Adds already-multiplied points to the score and earned total, then checks the
## bonus repairs and (1.05) the Double Missile bonus.
func _add_points(points: int) -> void:
	if is_defeated():
		return
	score += maxi(0, points)
	earned_points += maxi(0, points)
	var entitled := repair_bonuses_for(earned_points)
	if entitled > repair_bonuses_earned:
		var bonus := entitled - repair_bonuses_earned
		repair_charges += bonus
		repair_bonuses_earned = entitled
		_set_status("BONUS RAPID REPAIR +%d | %d CHARGE%s" % [bonus, repair_charges, "" if repair_charges == 1 else "S"], 4.0)
	_check_emp_award()
	_check_double_missile_bonus()

# ------------------------------------------------------------------
# Bonus features (1.05): Double Missile
# ------------------------------------------------------------------
## Earned points needed for Double Missile on the level being played.
func double_missile_threshold() -> int:
	return [easy_double_missile_points, normal_double_missile_points, hard_double_missile_points][clampi(active_difficulty, 0, 2)]

func double_missile_active() -> bool:
	return double_missile_bonus and double_missile_unlocked_at >= 0.0

## Bonus lines shown under SCORE while active (room for more bonuses later).
func active_bonus_names() -> Array[String]:
	var names: Array[String] = []
	if double_missile_active():
		names.append("DOUBLE MISSILE BONUS")
	return names

func _check_double_missile_bonus() -> void:
	if not double_missile_bonus or double_missile_unlocked_at >= 0.0 or earned_points < double_missile_threshold():
		return
	double_missile_unlocked_at = battle_time
	bonus_chimes += 1
	if is_instance_valid(bonus_chime_player):
		bonus_chime_player.volume_db = bonus_chime_volume_db
		bonus_chime_player.play()
	_set_status("DOUBLE MISSILE BONUS ACTIVE", 4.0)
	# Shown again after this frame, so the kill message that unlocked it does not hide it.
	call_deferred("_set_status", "DOUBLE MISSILE BONUS ACTIVE", 4.0)

# ------------------------------------------------------------------
# Difficulty and automation (gear Settings panel)
# ------------------------------------------------------------------
func difficulty_factor(easy: float, hard: float) -> float:
	match active_difficulty:
		0: return easy
		2: return hard
	return 1.0

## Missile and nuke speed for the level being played (Easy keeps the 1.03 speed).
func missile_speed_factor() -> float:
	return maxf(0.1, [easy_missile_speed, normal_missile_speed, hard_missile_speed][clampi(active_difficulty, 0, 2)])

func nuke_speed_factor() -> float:
	return maxf(0.1, [easy_nuke_speed, normal_nuke_speed, hard_nuke_speed][clampi(active_difficulty, 0, 2)])

func scaled_hits(hits: int) -> int:
	return maxi(1, roundi(hits * difficulty_factor(easy_toughness, hard_toughness)))

func attack_rate() -> float:
	return maxf(0.1, difficulty_factor(easy_attack_rate, hard_attack_rate))

func damage_factor() -> float:
	return difficulty_factor(easy_damage, hard_damage)

func hack_speed() -> float:
	return maxf(0.1, difficulty_factor(easy_hack_speed, hard_hack_speed))

func wave_length() -> float:
	return maxf(1.0, wave_seconds * difficulty_factor(easy_wave_length, hard_wave_length))

func auto_options_on() -> int:
	return int(auto_defense_battery) + int(auto_firewall) + int(auto_launch_vipers) + int(auto_launch_raptors) + int(auto_ftl) + int(auto_rapid_repair)

func score_multiplier_for(level: int, autos: int) -> float:
	var base: float = [easy_score_multiplier, 1.0, hard_score_multiplier][clampi(level, 0, 2)]
	return maxf(0.0, base * (1.0 - auto_score_penalty * autos))

func score_multiplier() -> float:
	return score_multiplier_for(active_difficulty, auto_options_on())

func points_for(base_points: int) -> int:
	return roundi(maxi(0, base_points) * score_multiplier())

func difficulty_letter() -> String:
	return ["E", "N", "H"][clampi(active_difficulty, 0, 2)]

func missiles_in_defense_zone(radius: float = -1.0) -> int:
	var reach := prox_defense_radius if radius < 0.0 else radius
	var total := 0
	for contact in contacts:
		if contact.kind == "missile" and contact.position.distance_to(own_ship_position) <= reach:
			total += 1
	return total

func _update_automation() -> void:
	_update_auto_repair()
	if _update_auto_ftl():
		return
	_update_auto_launch()
	if not firewall_active:
		auto_firewall_started = false
	if auto_firewall and not firewall_active and firewall_needed() and can_deploy_firewall():
		set_firewall(true)
		if firewall_active:
			auto_firewall_starts += 1
			auto_firewall_started = true
			auto_firewall_since = battle_time
	if not auto_defense_battery:
		auto_battery_started = false
		return
	if not prox_active:
		auto_battery_started = false
	var threats := missiles_in_defense_zone(maxf(prox_defense_radius, auto_battery_lead_radius))
	if threats > 0 and not prox_active and can_fire_battery():
		set_prox_defense(true)
		if prox_active:
			auto_battery_started = true
			auto_battery_since = battle_time
			auto_battery_starts += 1
	elif threats == 0 and prox_active and auto_battery_started and battle_time - auto_battery_since >= auto_min_engage_seconds:
		# Zone is clear and the minimum time has passed: stop the burst the
		# automation started and keep the rest of the charge.
		set_prox_defense(false)
		auto_battery_started = false

## Auto Rapid Repair: use one charge when the hull is at or below the set level.
func _update_auto_repair() -> bool:
	if not auto_rapid_repair or hull > max_hull * auto_repair_hull_percent / 100.0 or not can_rapid_repair():
		return false
	if not request_rapid_repair():
		return false
	auto_repairs += 1
	_set_status("AUTO RAPID REPAIR | HULL AT %d%% | %d CHARGE%s LEFT" % [roundi(100.0 * hull / maxf(1.0, max_hull)), repair_charges, "" if repair_charges == 1 else "S"], 3.0)
	return true

## Auto FTL: jump as soon as the hull is below the set level and FTL is charged.
func _update_auto_ftl() -> bool:
	if not auto_ftl or is_defeated() or hull >= max_hull * auto_ftl_hull_percent / 100.0 or not can_jump():
		return false
	if not request_ftl_jump():
		return false
	auto_ftl_jumps += 1
	_set_status("AUTO FTL JUMP | HULL BELOW %d%% | -%d POINTS" % [roundi(auto_ftl_hull_percent), ftl_score_cost], safe_remaining)
	return true

func enemy_fighters() -> int:
	return count_kind("raider") + count_kind("heavy_raider")

func vipers_on_patrol() -> int:
	var total := 0
	for contact in contacts:
		if Icons.is_viper(contact.kind) and not is_returning(contact):
			total += 1
	return total

## Auto launch: Vipers while enemy fighters are present (at least 2 out, one per
## fighter up to the limit); Raptors for each nuke, and one against Basestars.
## Uses the normal launch rules, so cooldowns and limits still apply.
func _update_auto_launch() -> void:
	if is_defeated() or safe_remaining > 0.0:
		return
	if auto_launch_vipers:
		var fighters := enemy_fighters()
		if fighters > 0 and vipers_on_patrol() < clampi(fighters, 2, max_vipers):
			if launch_vipers() > 0:
				auto_viper_launches += 1
	if auto_launch_raptors:
		var raptors := count_kind("raptor")
		var nukes := count_kind("nuke")
		var wanted := mini(max_raptors, nukes) if nukes > 0 else (1 if count_kind("baseship") > 0 else 0)
		if raptors < wanted and launch_raptor() > 0:
			auto_raptor_launches += 1

func auto_firewall_holding() -> bool:
	return firewall_active and auto_firewall_started and battle_time - auto_firewall_since < auto_min_engage_seconds

# ------------------------------------------------------------------
# Explosions: missile flash and boom, nuke explosion, screen flash
# ------------------------------------------------------------------
func _explode(at: Vector3, kind: String) -> void:
	if kind in ["craft", "heavy", "own_craft"]:
		if not craft_explosions_enabled:
			return
		craft_explosions += 1
	if explosion_effects_enabled:
		explosions.append({"position": at, "age": 0.0, "kind": kind, "seed": explosions_made})
	explosions_made += 1
	if kind == "missile":
		_play_boom(missile_boom_player, "missile", missile_boom_volume_db)
	elif kind == "craft" or kind == "own_craft":
		_play_boom(craft_boom_player, "craft", craft_boom_volume_db)
	elif kind == "heavy":
		_play_boom(heavy_boom_player, "heavy", heavy_boom_volume_db)
	elif kind == "capital":
		capital_explosions += 1
		_play_boom(capital_boom_player, "capital", capital_boom_volume_db)
		_screen_flash(capital_screen_flash_strength)
	else:
		_play_boom(nuke_boom_player, "nuke", nuke_boom_volume_db)
		_screen_flash(nuke_impact_flash_strength if kind == "nuke_impact" else nuke_screen_flash_strength)

## Explosion for a destroyed enemy craft (missiles and nukes have their own).
func _destruction_effect(contact: Dictionary) -> void:
	match contact.kind:
		"raider": _explode(contact.position, "craft")
		"heavy_raider": _explode(contact.position, "heavy")
		"baseship", "resurrection_ship": _explode(contact.position, "capital")

func _boom_player(node_name: String, stream: AudioStream, volume: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.name = node_name
	player.stream = stream
	player.volume_db = volume
	player.max_polyphony = 2
	add_child(player)
	return player

func _play_boom(player: AudioStreamPlayer, which: String, volume: float) -> void:
	if not is_instance_valid(player) or battle_time - float(last_boom.get(which, -INF)) < boom_min_gap_seconds:
		return
	last_boom[which] = battle_time
	booms_played[which] = int(booms_played.get(which, 0)) + 1
	player.volume_db = volume
	player.play()

func _screen_flash(strength: float) -> void:
	if not screen_flash_enabled or strength <= 0.0:
		return
	screen_flash_peak = maxf(screen_flash_alpha(), clampf(strength, 0.0, 0.6))
	screen_flash_remaining = maxf(0.1, screen_flash_seconds)

func screen_flash_alpha() -> float:
	if screen_flash_remaining <= 0.0:
		return 0.0
	var f := clampf(screen_flash_remaining / maxf(0.1, screen_flash_seconds), 0.0, 1.0)
	return screen_flash_peak * f * f

# ------------------------------------------------------------------
# FTL flash: a blue-white band wipes across the scope, with a brief screen flash
# ------------------------------------------------------------------
## 0 at the start of the flash, 1 at the end (or -1 when no flash is running).
func ftl_flash_progress() -> float:
	if ftl_flash_remaining <= 0.0:
		return -1.0
	return clampf(1.0 - ftl_flash_remaining / maxf(0.3, ftl_flash_seconds), 0.0, 1.0)

## Full-screen flash strength: instant on at the jump, fading over the first 45%.
func ftl_screen_alpha() -> float:
	var t := ftl_flash_progress()
	if t < 0.0 or not screen_flash_enabled:
		return 0.0
	var f := clampf(1.0 - t / 0.45, 0.0, 1.0)
	return clampf(ftl_screen_flash_strength, 0.0, 0.6) * f * f

## Where the wipe band is, from -1 (left edge of the scope) to +1 (right edge).
func ftl_band_position() -> float:
	var t := ftl_flash_progress()
	if t < 0.0:
		return -2.0
	return lerpf(-1.25, 1.25, 1.0 - pow(1.0 - t, 2.0))

func _draw_ftl_flash() -> void:
	var t := ftl_flash_progress()
	if t < 0.0:
		return
	var radius: float = get_parent().sphere_radius
	var centre := size * 0.5
	var fade := 1.0 - t
	var band := ftl_band_position()
	var width := 0.28
	# Vertical strokes inside the scope circle, brightest at the band centre.
	var steps := 160
	for index in range(steps + 1):
		var x := band - width + 2.0 * width * index / steps
		if absf(x) >= 1.0:
			continue
		var closeness := 1.0 - absf(x - band) / width
		var half := sqrt(1.0 - x * x) * radius
		var px := centre.x + x * radius
		var color := Color(0.72, 0.88, 1.0).lerp(Color(1.0, 1.0, 1.0), closeness * closeness * closeness)
		color.a = 0.85 * closeness * closeness * fade
		draw_line(Vector2(px, centre.y - half), Vector2(px, centre.y + half), color, radius * 2.0 * width / steps + 0.75, true)
	# Horizontal streaks trailing the band, like the jump stretching space.
	for line in range(9):
		var y := -0.8 + 1.6 * line / 8.0
		var half_w := sqrt(maxf(0.0, 1.0 - y * y))
		var tail := maxf(-half_w, band - 0.9)
		var head := minf(half_w, band)
		if head <= tail:
			continue
		draw_line(centre + Vector2(tail, y) * radius, centre + Vector2(head, y) * radius, Color(0.75, 0.9, 1.0, 0.45 * fade), 1.5, true)

func explosion_life(kind: String) -> float:
	match kind:
		"missile": return maxf(0.1, missile_flash_seconds)
		"craft", "heavy", "own_craft": return maxf(0.1, craft_explosion_seconds * (1.25 if kind == "heavy" else 1.0))
		"capital": return maxf(0.3, capital_explosion_seconds)
	return maxf(0.1, nuke_explosion_seconds)

func _age_explosions(delta: float) -> void:
	screen_flash_remaining = maxf(0.0, screen_flash_remaining - delta)
	ftl_flash_remaining = maxf(0.0, ftl_flash_remaining - delta)
	for index in range(explosions.size() - 1, -1, -1):
		explosions[index].age += delta
		if explosions[index].age >= explosion_life(explosions[index].kind):
			explosions.remove_at(index)

func _draw_explosions() -> void:
	for blast in explosions:
		var projected := projection(blast.position)
		var point: Vector2 = projected.point
		var k: float = projected.scale
		var t: float = clampf(blast.age / explosion_life(blast.kind), 0.0, 1.0)
		var fade := 1.0 - t
		if blast.kind == "missile":
			k *= missile_flash_size
			draw_circle(point, maxf(0.5, 5.0 * fade * k), Color(1.0, 0.97, 0.86, fade))
			draw_arc(point, (4.0 + 13.0 * t) * k, 0.0, TAU, 24, Color(1.0, 0.62, 0.25, fade * 0.9), 1.5, true)
			continue
		if blast.kind in ["craft", "heavy", "own_craft"]:
			_draw_craft_burst(blast, point, k, t, fade)
			continue
		if blast.kind == "capital":
			_draw_capital_burst(blast, point, k, t, fade)
			continue
		k *= nuke_explosion_size * (1.35 if blast.kind == "nuke_impact" else 1.0)
		var radius: float = (10.0 + 30.0 * sqrt(t)) * k
		var heat := Color(1.0, lerpf(0.95, 0.55, t), lerpf(0.78, 0.2, t), 0.9 * pow(fade, 2.6))
		draw_circle(point, radius, heat)
		draw_circle(point, radius * 0.5 * fade, Color(1.0, 1.0, 0.95, fade))
		draw_arc(point, (14.0 + 72.0 * t) * k, 0.0, TAU, 48, Color(1.0, 0.78, 0.45, 0.7 * fade), 2.0, true)
		for spark in range(8):
			var angle := TAU * spark / 8.0 + float(blast.seed) * 0.7
			var direction := Vector2(cos(angle), sin(angle))
			draw_line(point + direction * radius * 0.9, point + direction * (radius * 0.9 + 16.0 * k * fade + 6.0 * k),
				Color(1.0, 0.85, 0.4, fade), 1.5, true)

## Small fiery burst for a destroyed fighter: hot core, expanding ring and a few sparks.
func _draw_craft_burst(blast: Dictionary, point: Vector2, k: float, t: float, fade: float) -> void:
	k *= craft_explosion_size * (heavy_explosion_scale if blast.kind == "heavy" else 1.0)
	var tint: Color = own_craft_color if blast.kind == "own_craft" else enemy_craft_color
	var radius: float = (4.0 + 9.0 * sqrt(t)) * k
	draw_circle(point, radius, Color(tint, 0.75 * pow(fade, 2.2)))
	draw_circle(point, maxf(0.5, radius * 0.45 * fade), Color(1.0, 1.0, 0.94, fade))
	draw_arc(point, (5.0 + 18.0 * t) * k, 0.0, TAU, 24, Color(tint.lightened(0.25), 0.8 * fade), 1.5, true)
	for spark in range(5):
		var angle := TAU * spark / 5.0 + float(blast.seed) * 1.3
		var direction := Vector2(cos(angle), sin(angle))
		draw_line(point + direction * radius * 0.8, point + direction * (radius * 0.8 + 7.0 * k * fade + 2.0 * k),
			Color(tint.lightened(0.4), fade), 1.2, true)

## Large explosion for a destroyed Basestar or Resurrection Ship: bright core, two shock rings and debris.
func _draw_capital_burst(blast: Dictionary, point: Vector2, k: float, t: float, fade: float) -> void:
	k *= capital_explosion_size
	var radius: float = (16.0 + 46.0 * sqrt(t)) * k
	var heat := Color(1.0, lerpf(0.96, 0.5, t), lerpf(0.82, 0.18, t), 0.85 * pow(fade, 2.0))
	draw_circle(point, radius, heat)
	draw_circle(point, radius * 0.55 * fade, Color(1.0, 1.0, 0.96, fade))
	draw_arc(point, (20.0 + 110.0 * t) * k, 0.0, TAU, 64, Color(1.0, 0.8, 0.5, 0.75 * fade), 2.5, true)
	var late := clampf((t - 0.15) / 0.85, 0.0, 1.0)
	if late > 0.0:
		draw_arc(point, (16.0 + 80.0 * late) * k, 0.0, TAU, 64, Color(1.0, 0.62, 0.3, 0.6 * (1.0 - late)), 1.5, true)
	for piece in range(12):
		var angle := TAU * piece / 12.0 + float(blast.seed) * 0.9
		var direction := Vector2(cos(angle), sin(angle))
		var reach := radius * (0.9 + 0.25 * float((piece * 7 + int(blast.seed)) % 5) / 4.0)
		draw_line(point + direction * reach, point + direction * (reach + 22.0 * k * fade + 6.0 * k),
			Color(1.0, 0.86, 0.45, fade), 1.8, true)

# ------------------------------------------------------------------
# Viper squadrons (display only; every Viper keeps its own health and losses)
# ------------------------------------------------------------------
func _squadron_centre(members: Array, by_id: Dictionary) -> Vector3:
	var total := Vector3.ZERO
	for id in members:
		total += by_id[id].position
	return total / maxf(1.0, members.size())

func _update_viper_squadrons() -> void:
	if not viper_squadrons_enabled:
		viper_squadrons.clear()
		return
	var by_id := {}
	var order: Array[String] = []
	for contact in contacts:
		if contact.kind == "viper" and contact.get("phase", "") != "return":
			by_id[contact.id] = contact
			order.append(contact.id)
	var groups: Array = []
	var used := {}
	# Existing squadrons hold together until a member passes the split distance.
	for group in viper_squadrons:
		var members: Array = []
		for id in group:
			if by_id.has(id) and not used.has(id):
				members.append(id)
		if members.size() < 2:
			continue
		var centre := _squadron_centre(members, by_id)
		var kept: Array = []
		for id in members:
			if by_id[id].position.distance_to(centre) <= squadron_split_distance:
				kept.append(id)
		if kept.size() >= 2:
			for id in kept:
				used[id] = true
			groups.append(kept)
	# Loose Vipers join a nearby squadron or pair up within the join distance.
	for id in order:
		if used.has(id):
			continue
		var joined := false
		for group in groups:
			if by_id[id].position.distance_to(_squadron_centre(group, by_id)) <= squadron_join_distance:
				group.append(id)
				used[id] = true
				joined = true
				break
		if joined:
			continue
		for other in order:
			if other != id and not used.has(other) and by_id[id].position.distance_to(by_id[other].position) <= squadron_join_distance:
				groups.append([id, other])
				used[id] = true
				used[other] = true
				break
	viper_squadrons = groups

func squadron_of(id: String) -> int:
	for index in range(viper_squadrons.size()):
		if id in viper_squadrons[index]:
			return index
	return -1

func _draw_viper_squadrons(font: Font) -> void:
	for group in viper_squadrons:
		var members: Array = []
		for id in group:
			var viper := find_contact(id)
			if not viper.is_empty():
				members.append(viper)
		if members.size() < 2:
			continue
		var centre := Vector3.ZERO
		var weakest := 100
		for viper in members:
			centre += viper.position
			weakest = mini(weakest, fighter_health_percent(viper))
		centre /= members.size()
		var projected := projection(centre)
		var point: Vector2 = projected.point
		var marker_scale: float = projected.scale * small_ship_icon_scale
		var color := display_color(members[0])
		Icons.draw_icon(self, "viper_squadron", point, marker_scale, color)
		if show_labels:
			var text := "VIPERS x%d" % members.size()
			if show_full_tags:
				text = "VIPER SQUADRON x%d" % members.size()
			if show_full_tags and weakest < 100:
				text += " %d%%" % weakest
			var label_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, label_font_size)
			draw_string_outline_and_text(font, point + Vector2(-label_size.x * 0.5, 29.0 * marker_scale), text, label_font_size, label_color(color))

func pending_heavies() -> int:
	var total := 0
	for request in pending:
		if request.kind == "heavy_raider":
			total += 1
	return total

func count_base_heavies(base_id: String, include_pending: bool = false) -> int:
	var total := 0
	for contact in contacts:
		if contact.kind == "heavy_raider" and contact.get("origin_id", "") == base_id:
			total += 1
	if include_pending:
		for request in pending:
			if request.kind == "heavy_raider" and request.get("origin_id", "") == base_id:
				total += 1
	return total

func _update_heavy_raiders(delta: float) -> void:
	if is_defeated() or safe_remaining > 0.0:
		return
	for heavy in contacts.duplicate():
		if heavy.kind != "heavy_raider":
			continue
		if heavy.phase in ["emp", "emp_return"]:
			_update_emp_heavy(heavy, delta)
			continue
		if heavy.phase == "approach":
			_steer(heavy, heavy.hack_point, heavy_raider_speed, delta)
			if heavy.position.distance_to(heavy.hack_point) <= 0.025 and heavy.position.distance_to(own_ship_position) <= hacking_range:
				heavy.phase = "hacking"
				heavy.velocity = Vector3.ZERO
				heavy.hack_remaining = maxf(0.1, hacking_seconds / hack_speed())
				_set_status("HEAVY RAIDER HACKING | SHIP MISSILES, VIPERS OR RAPTORS", 4.0)
			# Arrival never retroactively consumes an entire frame's hack time.
			continue
		if heavy.position.distance_to(own_ship_position) > hacking_range:
			heavy.phase = "approach"
			heavy.hack_remaining = maxf(0.1, hacking_seconds / hack_speed())
			continue
		# FIREWALL: while deployed, the hack and its drain run slower.
		var drain_time := maxf(0.0, delta) * (clampf(firewall_slow_factor, 0.0, 1.0) if firewall_active else 1.0)
		if heavy.phase == "hacking":
			var step := minf(drain_time, heavy.hack_remaining)
			heavy.hack_remaining = maxf(0.0, heavy.hack_remaining - step)
			drain_time -= step
			if heavy.hack_remaining <= 0.0:
				heavy.phase = "draining"
		if heavy.phase == "draining" and drain_time > 0.0:
			apply_damage(max_hull * hack_drain_percent_per_second * hack_speed() * 0.01 * drain_time, false)
			if is_defeated():
				return

func active_hackers() -> int:
	var total := 0
	for contact in contacts:
		if contact.kind == "heavy_raider" and contact.phase == "draining":
			total += 1
	return total

func hacking_count() -> int:
	var total := 0
	for contact in contacts:
		if contact.kind == "heavy_raider" and contact.phase == "hacking":
			total += 1
	return total

func hack_breach_seconds() -> float:
	# Time until the next hacking Heavy Raider breaks through; INF when none.
	var soonest := INF
	for contact in contacts:
		if contact.kind == "heavy_raider" and contact.phase == "hacking":
			soonest = minf(soonest, contact.hack_remaining)
	return soonest

func hack_state() -> String:
	if is_defeated():
		return ""
	if active_hackers() > 0:
		return "draining"
	if hacking_count() > 0:
		return "hacking"
	if count_kind("heavy_raider") - emp_heavies_present() > 0:
		return "approach"
	return ""

func hacking_warning() -> String:
	var state := hack_state()
	if state == "":
		return ""
	if state == "approach":
		return "HEAVY RAIDER APPROACHING\nBATTERY CANNOT STOP IT"
	var lines: Array[String] = []
	var active := active_hackers()
	if active > 0:
		lines.append("COMPUTERS BREACHED")
		lines.append("HULL DRAIN %.1f%% / SEC" % (hack_drain_percent_per_second * hack_speed() * active))
	var hacking := hacking_count()
	if hacking > 0:
		if active == 0:
			lines.append("HEAVY RAIDER%s HACKING SHIP" % ("S" if hacking > 1 else ""))
			lines.append("FIREWALL UP | HACK SLOWED" if firewall_active else "PENETRATING DEFENSES")
			lines.append("BREACH IN %.1f s" % hack_breach_seconds())
		else:
			lines.append("NEXT BREACH IN %.1f s" % hack_breach_seconds())
	if firewall_active and active > 0:
		lines.append("FIREWALL UP | DRAIN SLOWED")
	lines.append("SHIP MISSILES / VIPERS / RAPTORS")
	return "\n".join(lines)

func _hit_heavy_raider(heavy: Dictionary) -> void:
	if is_defeated() or heavy.is_empty() or heavy.kind != "heavy_raider" or find_contact(heavy.id).is_empty():
		return
	heavy.health -= 1
	impacts.append({"position": heavy.position, "age": 0.0})
	if heavy.health > 0:
		return
	_award_destroyed(heavy)
	_remove_contact(heavy.id)
	heavy_raiders_destroyed += 1
	_set_status("HEAVY RAIDER DESTROYED | HACKING LINK TERMINATED", 3.0)

func can_rapid_repair() -> bool:
	return not is_defeated() and repair_charges > 0 and rapid_repair_remaining <= 0.0 and hull < max_hull

func request_rapid_repair() -> bool:
	if not can_rapid_repair():
		return false
	rapid_repair_used = true
	repair_charges -= 1
	rapid_repair_remaining = maxf(0.1, rapid_repair_seconds)
	rapid_repair_rate = max_hull * clampf(rapid_repair_percent, 0.0, 100.0) / 100.0 / rapid_repair_remaining
	_set_status("RAPID REPAIR ENGAGED | %d CHARGE%s LEFT" % [repair_charges, "" if repair_charges == 1 else "S"], rapid_repair_remaining)
	if repair_sound_enabled and is_instance_valid(repair_sound_player):
		repair_sound_player.volume_db = repair_sound_volume_db
		repair_sound_player.play()
		repair_sounds += 1
	return true

func _update_rapid_repair(delta: float) -> void:
	if is_defeated() or rapid_repair_remaining <= 0.0:
		return
	var step := minf(maxf(0.0, delta), rapid_repair_remaining)
	hull = minf(max_hull, hull + rapid_repair_rate * step)
	rapid_repair_remaining = maxf(0.0, rapid_repair_remaining - step)

## 0 to 1 pulse for the ship outline while a Rapid Repair runs (0 when idle).
func repair_flash_level() -> float:
	if not repair_flash_enabled or rapid_repair_remaining <= 0.0 or is_defeated():
		return 0.0
	return 0.5 - 0.5 * cos(TAU * repair_flash_hz * battle_time)

# ------------------------------------------------------------------
# EMP defense (1.06): overloads hacking Heavy Raiders and sends them home.
# ------------------------------------------------------------------
func _check_emp_award() -> void:
	if not emp_enabled:
		return
	var entitled := earned_points / maxi(1, emp_points_per_charge)
	if entitled <= emp_awards_earned:
		return
	var before := emp_charges
	emp_charges = mini(maxi(1, emp_max_charges), emp_charges + entitled - emp_awards_earned)
	emp_awards_earned = entitled
	if emp_charges > before and status_remaining <= 0.0:
		_set_status("EMP CHARGE READY | %d HELD" % emp_charges, 3.0)

## Heavy Raiders currently hacking or draining the ship's computers.
func emp_targets() -> Array:
	var found: Array = []
	for contact in contacts:
		if contact.kind == "heavy_raider" and contact.get("phase", "") in ["hacking", "draining"]:
			found.append(contact)
	return found

## Heavy Raiders overloaded by the EMP (shimmering or flying home).
func emp_heavies_present() -> int:
	var total := 0
	for contact in contacts:
		if contact.kind == "heavy_raider" and contact.get("phase", "") in ["emp", "emp_return"]:
			total += 1
	return total

## USE EMP is offered only while being hacked, with a charge ready, and (1.07) only
## once the Firewall has run out for emp_delay_after_firewall seconds.
func can_use_emp() -> bool:
	return emp_enabled and not is_defeated() and emp_charges > 0 and not emp_targets().is_empty() and (emp_offer_open or not firewall_enabled)

func _update_emp_offer() -> void:
	if emp_targets().is_empty():
		firewall_out_since = -1.0
		emp_offer_open = false
		return
	if emp_offer_open:
		return
	if not firewall_enabled:
		emp_offer_open = true
		return
	if firewall_active or can_deploy_firewall():
		firewall_out_since = -1.0
		return
	if firewall_out_since < 0.0:
		firewall_out_since = battle_time
	if battle_time - firewall_out_since >= maxf(0.0, emp_delay_after_firewall):
		emp_offer_open = true

func request_emp() -> bool:
	if not can_use_emp():
		return false
	var targets := emp_targets()
	emp_charges -= 1
	emp_uses += 1
	for heavy in targets:
		heavy.phase = "emp"
		heavy.emp_remaining = maxf(0.1, emp_shimmer_seconds)
		heavy.velocity = Vector3.ZERO
		emp_heavies_overloaded += 1
	if is_instance_valid(emp_player):
		emp_player.volume_db = emp_zap_volume_db
		emp_player.play()
	_set_status("EMP DISCHARGED | %d HEAVY RAIDER%s OVERLOADED, RETURNING FOR REPAIRS" % [targets.size(), "" if targets.size() == 1 else "S"], 4.0)
	return true

func _update_emp_heavy(heavy: Dictionary, delta: float) -> void:
	if heavy.phase == "emp":
		heavy.emp_remaining = maxf(0.0, float(heavy.get("emp_remaining", 0.0)) - delta)
		if heavy.emp_remaining <= 0.0:
			heavy.phase = "emp_return"
			heavy.emp_return_age = 0.0
		return
	heavy.emp_return_age = float(heavy.get("emp_return_age", 0.0)) + delta
	var home := find_contact(heavy.get("origin_id", ""))
	if home.is_empty() or home.kind != "baseship":
		home = {}
		var best := INF
		for contact in contacts:
			if contact.kind == "baseship" and heavy.position.distance_to(contact.position) < best:
				best = heavy.position.distance_to(contact.position)
				home = contact
	if home.is_empty():
		# No Basestar left: fly away from the ship and leave the scope.
		var away: Vector3 = heavy.position + (heavy.position - own_ship_position).normalized()
		_steer(heavy, away, heavy_raider_speed, delta)
		if heavy.emp_return_age >= 8.0:
			emp_heavies_docked += 1
			_remove_contact(heavy.id)
		return
	_steer(heavy, home.position, heavy_raider_speed, delta)
	if heavy.position.distance_to(home.position) <= 0.05:
		emp_heavies_docked += 1
		_remove_contact(heavy.id)

## Small jagged electric arcs around an overloaded Heavy Raider.
func _draw_emp_sparks(point: Vector2, marker_scale: float, contact: Dictionary) -> void:
	var tick := int(battle_time * 18.0)
	var seed_base: int = String(contact.id).hash()
	for arc in range(4):
		var angle := TAU * _spark01(seed_base + arc, tick)
		var radius := (14.0 + 8.0 * _spark01(seed_base + arc * 3, tick + 1)) * maxf(0.6, marker_scale)
		var bolt := PackedVector2Array()
		for step in range(5):
			var a := angle + step * 0.32
			var r := radius + (_spark01(seed_base + arc * 11 + step, tick) - 0.5) * 8.0
			bolt.append(point + Vector2(cos(a), sin(a)) * r)
		draw_polyline(bolt, Color(emp_color.lerp(Color.WHITE, 0.35), 0.85), 1.5, true)

static func _spark01(a: int, b: int) -> float:
	var h := (a * 73856093) ^ (b * 19349663)
	h = (h ^ (h >> 13)) * 1274126177
	return float((h >> 8) & 0xFFFF) / 65535.0

# ------------------------------------------------------------------
# Waves: difficulty rises every Wave Seconds of battle time.
# ------------------------------------------------------------------
func current_wave() -> int:
	if not waves_enabled:
		return 1
	return 1 + int(battle_time / wave_length())

func seconds_to_next_wave() -> float:
	var length := wave_length()
	return length - fmod(battle_time, length)

func _update_wave() -> void:
	var now := current_wave()
	if now == wave:
		return
	wave = now
	_set_status("WAVE %d | ENEMY ACTIVITY INCREASING" % wave, 4.0)
	wave_changed.emit(wave)

func basestar_cap() -> int:
	var extra := int(float(wave - 1) / float(maxi(1, extra_basestar_every_waves)))
	return mini(maxi(max_basestars, wave_max_basestars), max_basestars + extra)

func heavy_raider_cap() -> int:
	if wave >= extra_heavy_from_wave:
		return maxi(max_heavy_raiders, wave_max_heavy_raiders)
	return max_heavy_raiders

func missile_cap() -> int:
	# Room for a Resurrection Ship barrage on top of the normal limit, including
	# barrage missiles still in flight after the ship has gone.
	var extra := 0
	if not resurrection_ship().is_empty():
		extra = maxi(1, resurrection_barrage_missiles)
	var in_flight := 0
	for contact in contacts:
		if contact.kind == "missile" and contact.has("spread"):
			in_flight += 1
	return max_missiles + maxi(extra, in_flight)

func wave_interval_multiplier() -> float:
	return maxf(clampf(wave_interval_floor, 0.1, 1.0), 1.0 - maxf(0.0, wave_interval_step) * float(wave - 1))

func _capital_boxes(spot: Vector3, kind: String) -> Array:
	# Approximate space a capital ship's icon and name label take on the scope
	# (scope-radius units, +Y up): icon around the center, label just below.
	var icon_scale := 0.95 * icon_size * size_for_kind("resurrection_ship" if kind == "resurrection_ship" else "baseship")
	var icon_half := Vector2(13.0, 16.0) * 1.5 * icon_scale / 320.0
	var font := float(label_font_size + 2)
	# Labels are drawn in fixed screen pixels, so convert them by the scope radius.
	var radius := 320.0
	var dome := get_parent()
	if dome != null and "sphere_radius" in dome:
		radius = maxf(1.0, float(dome.sphere_radius))
	var text := "RESURRECTION 100%" if kind == "resurrection_ship" else "BASESTAR 100%"
	var label_half := 0.5 * ThemeDB.fallback_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, int(font)).x / radius + 0.02
	var baseline := 29.0 * icon_scale / 320.0
	return [Rect2(spot.x - icon_half.x, spot.y - icon_half.y, icon_half.x * 2.0, icon_half.y * 2.0),
		Rect2(spot.x - label_half, spot.y - baseline - 0.012, label_half * 2.0, font / radius + 0.012)]

func _capital_spot_free(spot: Vector3, kind: String = "baseship") -> bool:
	# Capital ships, and their name labels, must not overlap one another.
	var mine := _capital_boxes(spot, kind)
	for other in contacts:
		if other.kind in ["baseship", "unknown"]:
			for theirs in _capital_boxes(other.position, other.kind):
				for box in mine:
					if box.grow(0.012).intersects(theirs):
						return false
	return true

func _place_capital(kind: String = "baseship") -> Vector3:
	# Far upper row first (three places, like the original far band); later-wave
	# extras use a nearer second row. Small random offsets keep it from looking fixed.
	var upper := [Vector2(-0.56, 0.715), Vector2(0.0, 0.715), Vector2(0.56, 0.715)]
	var lower := [Vector2(-0.56, 0.395), Vector2(0.0, 0.395), Vector2(0.56, 0.395)]
	for row in [upper, lower]:
		var order: Array = row.duplicate()
		for index in range(order.size() - 1, 0, -1):
			var swap := rng.randi_range(0, index)
			var held: Vector2 = order[index]
			order[index] = order[swap]
			order[swap] = held
		for slot in order:
			for attempt in range(7):
				var jitter := Vector2(rng.randf_range(-0.05, 0.05), rng.randf_range(-0.005, 0.005)) if attempt < 6 else Vector2.ZERO
				var spot := Vector3(slot.x + jitter.x, slot.y + jitter.y, rng.randf_range(0.50, 0.60))
				if _capital_spot_free(spot, kind):
					return spot
	# Last resort: sweep the two rows in small steps so a free place is never missed.
	for y in [0.715, 0.395]:
		for step in range(34):
			var spot := Vector3(-0.66 + 0.04 * step, y, 0.55)
			if _capital_spot_free(spot, kind):
				return spot
	return Vector3.INF

func _hack_point_for(left_preferred: bool) -> Vector3:
	# Park beside the ship on a free side; a third Heavy Raider parks above the center.
	var left := own_ship_position + Vector3(-hack_park_offset.x, hack_park_offset.y, 0.0)
	var right := own_ship_position + Vector3(hack_park_offset.x, hack_park_offset.y, 0.0)
	var center := own_ship_position + Vector3(0.0, hack_park_offset.y + 0.06, 0.0)
	var taken: Array = []
	for contact in contacts:
		if contact.kind == "heavy_raider":
			taken.append(contact.hack_point)
	for spot in ([left, right] if left_preferred else [right, left]) + [center]:
		if spot not in taken:
			return spot
	return left if left_preferred else right

# ------------------------------------------------------------------
# Spaced-out bonus repairs: 10,000, 25,000, 50,000, then every 50,000 more.
# ------------------------------------------------------------------
func repair_bonus_threshold(number: int) -> int:
	var first := maxi(1, bonus_repair_points)
	var second := maxi(first + 1, second_bonus_points)
	var third := maxi(second + 1, third_bonus_points)
	if number <= 1:
		return first
	if number == 2:
		return second
	if number == 3:
		return third
	return third + (number - 3) * maxi(1, later_bonus_step)

func repair_bonuses_for(points: int) -> int:
	var total := 0
	while total < 1000 and repair_bonus_threshold(total + 1) <= points:
		total += 1
	return total

func points_to_next_bonus() -> int:
	return repair_bonus_threshold(repair_bonuses_for(earned_points) + 1) - earned_points

# ------------------------------------------------------------------
# Resurrection Ship: rare, stationary, hard to kill, fires missile barrages.
# ------------------------------------------------------------------
func resurrection_ship() -> Dictionary:
	for contact in contacts:
		if contact.kind == "resurrection_ship":
			return contact
	return {}

func _update_resurrection_spawning(delta: float) -> void:
	if not resurrection_enabled or is_defeated() or safe_remaining > 0.0:
		return
	if wave < resurrection_first_wave or not resurrection_ship().is_empty():
		return
	if resurrection_cooldown_remaining > 0.0:
		resurrection_cooldown_remaining = maxf(0.0, resurrection_cooldown_remaining - delta)
		return
	resurrection_check_remaining -= delta
	if resurrection_check_remaining > 0.0:
		return
	resurrection_check_remaining = maxf(5.0, resurrection_check_seconds)
	if rng.randf() < resurrection_chance_now():
		spawn_resurrection_ship()

func spawn_resurrection_ship() -> String:
	if is_defeated() or safe_remaining > 0.0 or not resurrection_ship().is_empty():
		return ""
	if count_tracks() >= max_contacts:
		return ""
	# Crosses the scope from one side to the other, chosen at random.
	var from_left := rng.randf() < 0.5
	var lane_low := minf(resurrection_lane.x, resurrection_lane.y)
	var lane_high := maxf(resurrection_lane.x, resurrection_lane.y)
	var y := rng.randf_range(lane_low, lane_high)
	var edge := sqrt(maxf(0.0, 1.0 - y * y))
	var spot := Vector3(-edge if from_left else edge, y, 0.3)
	var finish := Vector3(edge if from_left else -edge, y, 0.3)
	var id := _new_id("RS")
	contacts.append({
		"id": id, "kind": "resurrection_ship", "faction": "hostile",
		"start": spot, "finish": finish, "position": spot, "age": 0.0, "progress": 0.0,
		"direction": 1.0 if from_left else -1.0,
		"hits_remaining": float(scaled_hits(resurrection_hit_points)),
		"max_hits": float(scaled_hits(resurrection_hit_points)),
		"barrage_timer": maxf(0.5, resurrection_first_barrage_delay),
		"barrage_left": 0, "barrage_gap": 0.0, "barrage_index": 0
	})
	resurrection_spawns += 1
	resurrection_alert_pending = true
	_announce_contact(id, "resurrection_ship", "hostile")
	_set_status("RESURRECTION SHIP CROSSING %s | MISSILE BARRAGES | VIPERS, RAPTORS, SHIP MISSILES" % ("LEFT TO RIGHT" if from_left else "RIGHT TO LEFT"), 5.0)
	resurrection_arrived.emit(id)
	_update_resurrection_alert()
	return id

func resurrection_chance_now() -> float:
	# Rarer early, more frequent as the waves get tougher.
	var steps := maxi(0, wave - resurrection_first_wave)
	return clampf(resurrection_spawn_chance + resurrection_chance_step * steps, 0.0, maxf(resurrection_spawn_chance, resurrection_max_chance))

func resurrection_cooldown_now() -> float:
	var steps := maxi(0, wave - resurrection_first_wave)
	return maxf(minf(resurrection_cooldown_seconds, resurrection_min_cooldown), resurrection_cooldown_seconds - resurrection_cooldown_step * steps)

func resurrection_barrage_interval_now() -> float:
	return maxf(1.0, resurrection_barrage_interval) * wave_interval_multiplier() / attack_rate()

func _update_resurrection(ship: Dictionary, delta: float) -> void:
	# Crosses the scope, firing timed barrages, until destroyed or it reaches the far side.
	if safe_remaining > 0.0 or is_defeated():
		return
	var travel: float = ship.start.distance_to(ship.finish)
	ship.position = ship.position.move_toward(ship.finish, maxf(0.0, resurrection_speed) * movement_speed * delta)
	ship.progress = 1.0 if travel <= 0.0 else clampf(ship.start.distance_to(ship.position) / travel, 0.0, 1.0)
	if ship.position.distance_to(ship.finish) <= 0.002:
		_resurrection_escaped(ship)
		return
	ship.barrage_timer -= delta
	if ship.barrage_timer <= 0.0:
		ship.barrage_timer += resurrection_barrage_interval_now()
		ship.barrage_left = maxi(1, resurrection_barrage_missiles)
		ship.barrage_index = 0
		ship.barrage_gap = 0.0
		resurrection_barrages += 1
		_set_status("MISSILE BARRAGE x%d | RESURRECTION SHIP | FIRE DEFENSE BATTERY" % ship.barrage_left, 3.0)
	if ship.barrage_left <= 0:
		return
	ship.barrage_gap -= delta
	while ship.barrage_left > 0 and ship.barrage_gap <= 0.0:
		ship.barrage_left -= 1
		ship.barrage_gap += maxf(0.1, resurrection_barrage_spacing)
		var count := maxi(1, resurrection_barrage_missiles)
		var spread := 0.0
		if count > 1:
			spread = lerpf(-resurrection_missile_spread, resurrection_missile_spread, float(ship.barrage_index) / float(count - 1))
		ship.barrage_index += 1
		var missile_id := spawn_from_basestar("missile", ship.id)
		if not missile_id.is_empty():
			var missile := find_contact(missile_id)
			missile.spread = spread
			var path: Vector3 = own_ship_position - missile.position
			missile.side = Vector3(-path.y, path.x, 0.0).normalized() if Vector2(path.x, path.y).length() > 0.01 else Vector3.RIGHT
			missile.damage = resurrection_missile_damage
			resurrection_missiles_fired += 1

func _resurrection_escaped(ship: Dictionary) -> void:
	var id: String = ship.id
	_remove_contact(id)
	for index in range(contacts.size() - 1, -1, -1):
		if contacts[index].kind in ["own_missile", "raptor_missile"] and contacts[index].target_id == id:
			contacts[index].target_id = ""
	resurrections_escaped += 1
	resurrection_cooldown_remaining = resurrection_cooldown_now()
	resurrection_check_remaining = maxf(5.0, resurrection_check_seconds)
	resurrection_alert_pending = false
	_set_status("RESURRECTION SHIP LEFT THE SCOPE", 3.0)

func _hit_resurrection(ship: Dictionary, damage: float, source: String) -> void:
	if is_defeated() or ship.is_empty() or ship.kind != "resurrection_ship" or find_contact(ship.id).is_empty():
		return
	ship.hits_remaining -= maxf(0.0, damage)
	resurrection_hits_by[source] = resurrection_hits_by.get(source, 0) + 1
	impacts.append({"position": ship.position, "age": 0.0})
	if ship.hits_remaining > 0.0:
		return
	var id: String = ship.id
	_award_destroyed(ship)
	_remove_contact(id)
	for index in range(contacts.size() - 1, -1, -1):
		if contacts[index].kind in ["own_missile", "raptor_missile"] and contacts[index].target_id == id:
			contacts[index].target_id = ""
	resurrections_destroyed += 1
	resurrection_cooldown_remaining = resurrection_cooldown_now()
	resurrection_check_remaining = maxf(5.0, resurrection_check_seconds)
	resurrection_alert_pending = false
	_set_status("RESURRECTION SHIP DESTROYED | +%d POINTS" % resurrection_points, 4.0)
	resurrection_destroyed.emit(id)

func _update_resurrection_alert() -> void:
	if resurrection_alert_player == null:
		return
	resurrection_alert_player.volume_db = resurrection_alert_volume_db
	resurrection_alert_player.pitch_scale = resurrection_alert_speed
	# Nuclear warnings always take priority.
	if count_kind("nuke") > 0:
		if nuclear_player.playing or not nuclear_alert_queue.is_empty():
			resurrection_alert_player.stop()
		return
	if not resurrection_alert_pending:
		return
	if resurrection_ship().is_empty():
		resurrection_alert_pending = false
		return
	if klaxon_enabled and not klaxon_player.playing and not resurrection_alert_player.playing:
		resurrection_alert_pending = false
		resurrection_alert_player.play()
		resurrection_alert_count += 1

static func make_klaxon_sound() -> AudioStreamWAV:
	return make_alert_sequence(3)

static func make_alert_sequence(repetitions: int) -> AudioStreamWAV:
	# Read the approved PCM directly, independent of Godot's WAV importer.
	# Three exact copies in one finite stream avoid runaway loop/callback state.
	var path := "res://assets/audio/dradis_alert_loop.wav"
	if not FileAccess.file_exists(path):
		# Exported game: use Godot's uncompressed imported copy (same samples).
		return alert_sequence_from_pcm(exported_alert_pcm(path), repetitions)
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.size() < 44 or bytes.slice(0, 4).get_string_from_ascii() != "RIFF" or bytes.slice(8, 12).get_string_from_ascii() != "WAVE":
		push_error("Identification alert is missing or not a WAV file")
		return null
	var offset := 12
	var valid_format := false
	var pcm := PackedByteArray()
	while offset + 8 <= bytes.size():
		var tag := bytes.slice(offset, offset + 4).get_string_from_ascii()
		var length := int(bytes.decode_u32(offset + 4))
		var start := offset + 8
		if start + length > bytes.size():
			push_error("Identification alert contains a truncated WAV chunk")
			return null
		if tag == "fmt " and length >= 16:
			valid_format = bytes.decode_u16(start) == 1 and bytes.decode_u16(start + 2) == 1 and bytes.decode_u32(start + 4) == 48000 and bytes.decode_u16(start + 14) == 16
		elif tag == "data":
			pcm = bytes.slice(start, start + length)
		offset = start + length + (length & 1)
	if not valid_format or pcm.size() != 134400:
		push_error("Identification alert must be the approved 67200-frame mono 48kHz PCM loop")
		return null
	return alert_sequence_from_pcm(pcm, repetitions)

static func exported_alert_pcm(path: String) -> PackedByteArray:
	var imported := load(path) as AudioStreamWAV
	if imported == null or imported.format != AudioStreamWAV.FORMAT_16_BITS or imported.stereo or imported.mix_rate != 48000 or imported.data.size() != 134400:
		push_error("Identification alert export copy must be the approved 67200-frame mono 48kHz PCM loop")
		return PackedByteArray()
	return imported.data

static func alert_sequence_from_pcm(pcm: PackedByteArray, repetitions: int) -> AudioStreamWAV:
	if pcm.is_empty():
		return null
	var sequence := PackedByteArray()
	for repeat in range(repetitions):
		sequence.append_array(pcm)
	var stream := AudioStreamWAV.new()
	stream.mix_rate = 48000
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = sequence
	return stream

static func make_arrival_sound() -> AudioStreamWAV:
	# Original two-tone electronic beep pair. Generated as PCM, no external asset.
	var sample_rate := 48000
	var frame_total := 16800  # 0.35 seconds
	var data := PackedByteArray()
	data.resize(frame_total * 2)
	for index in range(frame_total):
		var time := float(index) / float(sample_rate)
		var value := 0.0
		for onset in [0.0, 0.19]:
			var local_time: float = time - onset
			if local_time >= 0.0 and local_time < 0.12:
				var envelope := minf(local_time / 0.007, (0.12 - local_time) / 0.018)
				envelope = clampf(envelope, 0.0, 1.0)
				value += envelope * (0.27 * sin(TAU * 1320.0 * local_time)
					+ 0.07 * sin(TAU * 1760.0 * local_time))
		data.encode_s16(index * 2, int(clampf(value, -1.0, 1.0) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = data
	return stream

static func make_launch_sound() -> AudioStreamWAV:
	# Original short filtered-noise whoosh, with soft attack and release.
	var noise := RandomNumberGenerator.new()
	noise.seed = 10472026
	var sample_rate := 48000
	var frame_total := 26400  # 0.55 seconds
	var data := PackedByteArray()
	data.resize(frame_total * 2)
	var filtered := 0.0
	var phase := 0.0
	for index in range(frame_total):
		var t := float(index) / float(frame_total)
		var filter_amount := lerpf(0.18, 0.035, t)
		filtered = lerpf(filtered, noise.randf_range(-1.0, 1.0), filter_amount)
		var envelope := pow(sin(PI * t), 1.6)
		phase += TAU * lerpf(310.0, 95.0, t) / float(sample_rate)
		var value := envelope * (filtered * 0.9 + sin(phase) * 0.055)
		data.encode_s16(index * 2, int(clampf(value, -0.8, 0.8) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = data
	return stream


# ------------------------------------------------------------------
# FIREWALL: an electronic countermeasure against Heavy Raider hacking.
# ------------------------------------------------------------------
func firewall_needed() -> bool:
	return hack_state() in ["hacking", "draining"]

func firewall_percent() -> float:
	return 100.0 * clampf(firewall_charge / maxf(0.1, firewall_seconds), 0.0, 1.0)

func can_deploy_firewall() -> bool:
	if not firewall_enabled or is_defeated() or safe_remaining > 0.0:
		return false
	if firewall_active:
		return true
	return firewall_needed() and firewall_percent() >= maxf(1.0, firewall_restart_percent)

func set_firewall(enabled: bool) -> void:
	if enabled and not firewall_active:
		if not can_deploy_firewall():
			return
		firewall_active = true
		firewall_idle = 0.0
		firewall_uses += 1
		firewall_player.volume_db = firewall_volume_db
		firewall_player.play()
		_set_status("FIREWALL UP | HEAVY RAIDER HACK SLOWED", 3.0)
	elif not enabled and firewall_active:
		_end_firewall()

func _end_firewall() -> void:
	firewall_active = false
	firewall_idle = 0.0
	firewall_player.stop()
	if firewall_charge <= 0.0:
		firewall_charge = 0.0
		_set_status("FIREWALL SPENT | RECHARGING", 2.0)
	else:
		_set_status("FIREWALL DOWN | RECHARGING FROM %d%%" % int(firewall_percent()), 2.0)

func _update_firewall(delta: float) -> void:
	var full := maxf(0.1, firewall_seconds)
	firewall_player.volume_db = firewall_volume_db
	if firewall_active:
		if not firewall_needed() and not auto_firewall_holding():
			# The hack is over: lower the firewall and keep the remaining charge.
			_end_firewall()
			return
		firewall_charge = maxf(0.0, firewall_charge - delta)
		if firewall_charge <= 0.0:
			_end_firewall()
		return
	if firewall_charge >= full:
		firewall_charge = full
		return
	var wait := maxf(0.0, firewall_recharge_delay - firewall_idle)
	firewall_idle += delta
	var charging := maxf(0.0, delta - wait)
	if charging > 0.0:
		firewall_charge = minf(full, firewall_charge + charging * full / maxf(1.0, firewall_recharge_seconds))

# ------------------------------------------------------------------
# Fighter losses: Vipers and Raptors can be shot down in battle.
# ------------------------------------------------------------------
func _damage_fighter(fighter: Dictionary, source: String) -> void:
	if fighter.is_empty() or find_contact(fighter.id).is_empty() or is_defeated():
		return
	fighter.health = int(fighter.get("health", 1)) - 1
	impacts.append({"position": fighter.position, "age": 0.0})
	var craft := "RAPTOR" if fighter.kind == "raptor" else "VIPER"
	if fighter.health <= 0:
		fighter_losses_by["flak" if source == "BASESTAR FIRE" else "raider"] += 1
		_lose_fighter(fighter, "%s LOST TO %s" % [craft, source])
	else:
		_set_status("%s HIT BY %s | %d%% LEFT" % [craft, source, fighter_health_percent(fighter)], 2.5)

func fighter_health_percent(fighter: Dictionary) -> int:
	return ceili(100.0 * float(fighter.get("health", 1)) / maxf(1.0, float(fighter.get("max_health", 1))))

func _lose_fighter(fighter: Dictionary, message: String) -> void:
	if fighter.is_empty() or find_contact(fighter.id).is_empty():
		return
	var penalty := raptor_loss_points if fighter.kind == "raptor" else viper_loss_points
	if fighter.kind == "raptor":
		raptors_lost += 1
	else:
		vipers_lost += 1
	impacts.append({"position": fighter.position, "age": 0.0})
	_explode(fighter.position, "own_craft")
	_remove_contact(fighter.id)
	var taken := mini(score, maxi(0, penalty))
	score -= taken
	fighter_points_lost += taken
	_set_status("%s | -%d POINTS" % [message, maxi(0, penalty)], 3.0)
