extends Node3D

const TerrainScript = preload("res://scripts/terrain.gd")
const PlayerScript = preload("res://scripts/player.gd")
const TouchControlsScript = preload("res://scripts/touch_controls.gd")
const CreatureScript = preload("res://scripts/creature.gd")
const FlyingCreatureScript = preload("res://scripts/flying_creature.gd")
const DayNightScript = preload("res://scripts/day_night.gd")

var player: CharacterBody3D
var terrain
var hud: CanvasLayer

func _ready() -> void:
    _setup_input_map()
    _create_environment()
    _create_world()
    _create_player()
    _create_creatures()
    _create_flying_creatures()
    _create_ui()

func _setup_input_map() -> void:
    _add_key_action("move_forward", [KEY_W, KEY_UP])
    _add_key_action("move_back", [KEY_S, KEY_DOWN])
    _add_key_action("move_left", [KEY_A, KEY_LEFT])
    _add_key_action("move_right", [KEY_D, KEY_RIGHT])
    _add_key_action("jump", [KEY_SPACE])
    _add_key_action("sprint", [KEY_SHIFT])
    _add_key_action("toggle_flight", [KEY_F])
    _add_key_action("ascend", [KEY_E])
    _add_key_action("descend", [KEY_Q])

func _add_key_action(action_name: StringName, keys: Array) -> void:
    if not InputMap.has_action(action_name):
        InputMap.add_action(action_name, 0.2)
    for keycode in keys:
        var exists := false
        for existing in InputMap.action_get_events(action_name):
            if existing is InputEventKey and existing.physical_keycode == keycode:
                exists = true
                break
        if not exists:
            var event := InputEventKey.new()
            event.physical_keycode = keycode
            InputMap.action_add_event(action_name, event)

func _create_environment() -> void:
    var world_env := WorldEnvironment.new()
    world_env.name = "WorldEnvironment"
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_material := PhysicalSkyMaterial.new()
    sky_material.turbidity = 6.2
    sky_material.rayleigh_coefficient = 2.45
    sky_material.rayleigh_color = Color("#718baa")
    sky_material.mie_coefficient = 0.0065
    sky_material.mie_eccentricity = 0.82
    sky_material.mie_color = Color("#d8c8aa")
    sky_material.ground_color = Color("#18271f")
    sky_material.sun_disk_scale = 2.2
    sky.sky_material = sky_material
    env.sky = sky
    env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    env.ambient_light_energy = 0.72
    env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
    env.tonemap_mode = Environment.TONE_MAPPER_ACES
    env.glow_enabled = true
    env.glow_intensity = 0.65
    env.fog_enabled = true
    env.fog_light_color = Color("#aabca9")
    env.fog_light_energy = 0.62
    env.fog_density = 0.0018
    env.fog_height = 4.0
    env.fog_height_density = 0.025
    world_env.environment = env
    add_child(world_env)

    var sun := DirectionalLight3D.new()
    sun.name = "Sun"
    sun.light_color = Color("#ffe3b0")
    sun.light_energy = 1.35
    sun.shadow_enabled = true
    sun.directional_shadow_max_distance = 220.0
    sun.rotation_degrees = Vector3(-43.0, -28.0, 0.0)
    sun.set_script(DayNightScript)
    add_child(sun)

func _create_world() -> void:
    terrain = Node3D.new()
    terrain.name = "ProceduralIsland"
    terrain.set_script(TerrainScript)
    add_child(terrain)

func _create_player() -> void:
    player = CharacterBody3D.new()
    player.name = "Player"
    player.set_script(PlayerScript)
    var spawn_height := 42.0
    if terrain != null and terrain.has_method("sample_height"):
        spawn_height = float(terrain.call("sample_height", 0.0, 0.0)) + 3.5
    player.position = Vector3(0.0, spawn_height, 0.0)
    add_child(player)

func _create_creatures() -> void:
    var creatures := Node3D.new()
    creatures.name = "Wildlife"
    add_child(creatures)
    var rng := RandomNumberGenerator.new()
    rng.seed = 12842
    for herb_index in range(18):
        var creature := CharacterBody3D.new()
        creature.name = "Herbivore_%02d" % herb_index
        creature.set_meta("predator", false)
        creature.set_script(CreatureScript)
        var herb_angle := rng.randf_range(0.0, TAU)
        var herb_radius := rng.randf_range(70.0, 380.0)
        var creature_x := cos(herb_angle) * herb_radius
        var creature_z := sin(herb_angle) * herb_radius
        var creature_y: float = float(terrain.call("sample_height", creature_x, creature_z)) + 2.5
        creature.position = Vector3(creature_x, creature_y, creature_z)
        creatures.add_child(creature)
    for predator_index in range(5):
        var predator := CharacterBody3D.new()
        predator.name = "Predator_%02d" % predator_index
        predator.set_meta("predator", true)
        predator.set_script(CreatureScript)
        var predator_angle := rng.randf_range(0.0, TAU)
        var predator_radius := rng.randf_range(140.0, 340.0)
        var predator_x := cos(predator_angle) * predator_radius
        var predator_z := sin(predator_angle) * predator_radius
        var predator_y: float = float(terrain.call("sample_height", predator_x, predator_z)) + 2.5
        predator.position = Vector3(predator_x, predator_y, predator_z)
        creatures.add_child(predator)

func _create_flying_creatures() -> void:
    var flock := Node3D.new()
    flock.name = "Pterosaurs"
    add_child(flock)
    var rng := RandomNumberGenerator.new()
    rng.seed = 77821
    for flyer_index in range(9):
        var flyer := Node3D.new()
        flyer.name = "Pterosaur_%02d" % flyer_index
        flyer.set_meta("orbit_radius", rng.randf_range(90.0, 310.0))
        flyer.set_meta("orbit_speed", rng.randf_range(0.035, 0.085))
        flyer.set_meta("altitude", rng.randf_range(78.0, 155.0))
        flyer.set_meta("start_angle", rng.randf_range(0.0, TAU))
        flyer.set_script(FlyingCreatureScript)
        flock.add_child(flyer)

func _create_ui() -> void:
    hud = CanvasLayer.new()
    hud.name = "MobileHUD"
    hud.set_script(TouchControlsScript)
    hud.set("player_path", player.get_path())
    add_child(hud)
