extends CharacterBody3D

var predator := false
var speed := 3.2
var target_direction := Vector3.FORWARD
var change_timer := 0.0
var gravity := 22.0
var rng := RandomNumberGenerator.new()
var body_root: Node3D
var player: Node3D

func _ready() -> void:
    predator = bool(get_meta("predator", false))
    speed = 5.8 if predator else 3.0
    rng.seed = hash(name)
    _build_body()
    await get_tree().process_frame
    player = get_tree().get_first_node_in_group("player")

func _build_body() -> void:
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.75 if predator else 0.68
    shape.height = 1.6
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

    body_root = Node3D.new()
    add_child(body_root)
    var main_color := Color("#665845") if predator else Color("#687050")
    var accent := Color("#3b3329") if predator else Color("#43523a")

    var body_mesh := SphereMesh.new()
    body_mesh.radius = 0.82
    body_mesh.height = 1.7
    body_mesh.radial_segments = 8
    body_mesh.rings = 5
    var body := _part(body_mesh, Vector3(0, 1.08, 0), main_color)
    body.scale = Vector3(1.5, 0.85, 0.72)

    var neck_mesh := CapsuleMesh.new()
    neck_mesh.radius = 0.22 if predator else 0.18
    neck_mesh.height = 1.25 if predator else 1.8
    neck_mesh.radial_segments = 7
    var neck := _part(neck_mesh, Vector3(0, 1.58, -0.78), main_color)
    neck.rotation_degrees.x = -45.0 if predator else -27.0

    var head_mesh := SphereMesh.new()
    head_mesh.radius = 0.38 if predator else 0.3
    head_mesh.height = 0.8
    head_mesh.radial_segments = 8
    head_mesh.rings = 4
    var head := _part(head_mesh, Vector3(0, 1.92, -1.35), accent)
    head.scale = Vector3(1.0, 0.72, 1.45)

    var tail_mesh := CapsuleMesh.new()
    tail_mesh.radius = 0.16
    tail_mesh.height = 2.4
    tail_mesh.radial_segments = 7
    var tail := _part(tail_mesh, Vector3(0, 1.12, 1.28), main_color)
    tail.rotation_degrees.x = 73.0
    tail.scale = Vector3(1.0, 1.35, 1.0)

    var leg_mesh := CapsuleMesh.new()
    leg_mesh.radius = 0.15
    leg_mesh.height = 0.95
    leg_mesh.radial_segments = 7
    for x in [-0.48, 0.48]:
        for z in [-0.42, 0.42]:
            _part(leg_mesh, Vector3(x, 0.45, z), accent)

func _part(mesh: Mesh, pos: Vector3, color: Color) -> MeshInstance3D:
    var item := MeshInstance3D.new()
    item.mesh = mesh
    item.position = pos
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 0.93
    item.material_override = mat
    body_root.add_child(item)
    return item

func _physics_process(delta: float) -> void:
    change_timer -= delta
    var distance_to_player := 999.0
    if player != null:
        distance_to_player = global_position.distance_to(player.global_position)
    if predator and player != null and distance_to_player < 34.0 and player.global_position.y < global_position.y + 8.0:
        target_direction = (player.global_position - global_position)
        target_direction.y = 0.0
        target_direction = target_direction.normalized()
    elif not predator and player != null and distance_to_player < 18.0:
        target_direction = (global_position - player.global_position)
        target_direction.y = 0.0
        target_direction = target_direction.normalized()
    elif change_timer <= 0.0:
        change_timer = rng.randf_range(2.5, 7.0)
        var angle := rng.randf_range(0.0, TAU)
        target_direction = Vector3(cos(angle), 0, sin(angle))

    if global_position.length() > 455.0:
        target_direction = -Vector3(global_position.x, 0, global_position.z).normalized()
    var alert_distance := 34.0 if predator else 18.0
    var active_speed := speed * (1.65 if distance_to_player < alert_distance else 1.0)
    velocity.x = move_toward(velocity.x, target_direction.x * active_speed, 6.0 * delta)
    velocity.z = move_toward(velocity.z, target_direction.z * active_speed, 6.0 * delta)
    if not is_on_floor():
        velocity.y -= gravity * delta
    move_and_slide()
    if target_direction.length() > 0.1:
        body_root.rotation.y = lerp_angle(body_root.rotation.y, atan2(-target_direction.x, -target_direction.z), delta * 3.0)
    if global_position.y < -20.0:
        global_position = Vector3(global_position.x * 0.7, 80.0, global_position.z * 0.7)
        velocity = Vector3.ZERO
