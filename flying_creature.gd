extends Node3D

var orbit_radius := 180.0
var orbit_speed := 0.05
var altitude := 110.0
var angle := 0.0
var wing_phase := 0.0
var left_wing: MeshInstance3D
var right_wing: MeshInstance3D

func _ready() -> void:
    orbit_radius = float(get_meta("orbit_radius", orbit_radius))
    orbit_speed = float(get_meta("orbit_speed", orbit_speed))
    altitude = float(get_meta("altitude", altitude))
    angle = float(get_meta("start_angle", 0.0))
    wing_phase = angle * 3.0
    _build_pterosaur()
    _update_transform(0.0)

func _build_pterosaur() -> void:
    var skin := Color("#665f4f")
    var membrane := Color("#766e59")

    var body_mesh := CapsuleMesh.new()
    body_mesh.radius = 0.22
    body_mesh.height = 1.35
    body_mesh.radial_segments = 7
    var body := _part(body_mesh, Vector3.ZERO, skin)
    body.rotation_degrees.x = 90.0

    var head_mesh := SphereMesh.new()
    head_mesh.radius = 0.19
    head_mesh.height = 0.4
    head_mesh.radial_segments = 7
    head_mesh.rings = 4
    var head := _part(head_mesh, Vector3(0.0, 0.0, -0.78), skin)
    head.scale = Vector3(0.8, 0.75, 1.35)

    var beak_mesh := BoxMesh.new()
    beak_mesh.size = Vector3(0.12, 0.09, 0.65)
    _part(beak_mesh, Vector3(0.0, -0.02, -1.23), Color("#4a4234"))

    var wing_mesh := BoxMesh.new()
    wing_mesh.size = Vector3(2.35, 0.055, 0.72)
    left_wing = _part(wing_mesh, Vector3(-1.25, 0.0, 0.0), membrane)
    right_wing = _part(wing_mesh, Vector3(1.25, 0.0, 0.0), membrane)
    left_wing.rotation_degrees.y = -8.0
    right_wing.rotation_degrees.y = 8.0

func _part(mesh: Mesh, position_value: Vector3, color: Color) -> MeshInstance3D:
    var item := MeshInstance3D.new()
    item.mesh = mesh
    item.position = position_value
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.88
    item.material_override = material
    add_child(item)
    return item

func _process(delta: float) -> void:
    angle = fmod(angle + orbit_speed * delta, TAU)
    wing_phase += delta * 5.5
    _update_transform(delta)
    var flap := sin(wing_phase) * 0.38
    left_wing.rotation.z = flap
    right_wing.rotation.z = -flap

func _update_transform(_delta: float) -> void:
    var position_now := Vector3(cos(angle) * orbit_radius, altitude + sin(angle * 2.1) * 8.0, sin(angle) * orbit_radius)
    var look_ahead_angle := angle + 0.03
    var target := Vector3(cos(look_ahead_angle) * orbit_radius, altitude + sin(look_ahead_angle * 2.1) * 8.0, sin(look_ahead_angle) * orbit_radius)
    global_position = position_now
    look_at(target, Vector3.UP, false)
