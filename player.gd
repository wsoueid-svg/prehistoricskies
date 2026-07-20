extends CharacterBody3D

@export var walk_speed := 8.0
@export var sprint_speed := 14.0
@export var flight_speed := 28.0
@export var flight_boost_speed := 48.0
@export var jump_velocity := 9.5
@export var mouse_sensitivity := 0.0024
@export var touch_sensitivity := 0.0042

var flying := false
var camera_yaw := 0.0
var camera_pitch := -0.18
var gravity := 22.0
var controls
var model_root: Node3D
var camera_pivot: Node3D
var camera_arm: SpringArm3D
var camera: Camera3D
var left_arm: MeshInstance3D
var right_arm: MeshInstance3D
var left_leg: MeshInstance3D
var right_leg: MeshInstance3D
var animation_time := 0.0
var last_safe_position := Vector3.ZERO

func _ready() -> void:
    add_to_group("player")
    _build_collision()
    _build_human_model()
    _build_camera()
    if not OS.has_feature("mobile"):
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    last_safe_position = global_position
    await get_tree().process_frame
    controls = get_tree().get_first_node_in_group("touch_controls")

func _build_collision() -> void:
    var collision := CollisionShape3D.new()
    var capsule := CapsuleShape3D.new()
    capsule.radius = 0.52
    capsule.height = 1.85
    collision.shape = capsule
    collision.position.y = 0.92
    add_child(collision)

func _make_part(mesh: Mesh, position_value: Vector3, color: Color) -> MeshInstance3D:
    var part := MeshInstance3D.new()
    part.mesh = mesh
    part.position = position_value
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 0.84
    part.material_override = mat
    model_root.add_child(part)
    return part

func _build_human_model() -> void:
    model_root = Node3D.new()
    model_root.name = "HumanModel"
    add_child(model_root)
    var skin := Color("#b58465")
    var cloth := Color("#554838")
    var dark := Color("#292722")

    var torso := CapsuleMesh.new()
    torso.radius = 0.38
    torso.height = 1.05
    torso.radial_segments = 10
    torso.rings = 4
    _make_part(torso, Vector3(0, 1.25, 0), cloth)

    var head := SphereMesh.new()
    head.radius = 0.29
    head.height = 0.58
    head.radial_segments = 10
    head.rings = 6
    _make_part(head, Vector3(0, 1.98, 0), skin)

    var limb := CapsuleMesh.new()
    limb.radius = 0.105
    limb.height = 0.83
    limb.radial_segments = 8
    limb.rings = 3
    left_arm = _make_part(limb, Vector3(-0.47, 1.27, 0), skin)
    left_arm.rotation_degrees.z = -8.0
    right_arm = _make_part(limb, Vector3(0.47, 1.27, 0), skin)
    right_arm.rotation_degrees.z = 8.0

    var leg := CapsuleMesh.new()
    leg.radius = 0.13
    leg.height = 0.94
    leg.radial_segments = 8
    leg.rings = 3
    left_leg = _make_part(leg, Vector3(-0.19, 0.48, 0), dark)
    right_leg = _make_part(leg, Vector3(0.19, 0.48, 0), dark)

func _build_camera() -> void:
    camera_pivot = Node3D.new()
    camera_pivot.name = "CameraPivot"
    camera_pivot.position = Vector3(0.0, 1.45, 0.0)
    add_child(camera_pivot)
    camera_arm = SpringArm3D.new()
    camera_arm.name = "CameraArm"
    camera_arm.spring_length = 6.8
    camera_arm.margin = 0.28
    camera_arm.collision_mask = 1
    camera_pivot.add_child(camera_arm)
    camera_arm.add_excluded_object(get_rid())
    camera = Camera3D.new()
    camera.name = "Camera"
    camera.position = Vector3(0.0, 0.45, 0.0)
    camera.fov = 72.0
    camera.near = 0.08
    camera.far = 1600.0
    camera.current = true
    camera_arm.add_child(camera)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        _rotate_camera(Vector2(event.relative.x, event.relative.y) * mouse_sensitivity)
    elif event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func _rotate_camera(delta: Vector2) -> void:
    camera_yaw -= delta.x
    camera_pitch = clamp(camera_pitch - delta.y, -1.15, 0.75)
    camera_pivot.rotation = Vector3(camera_pitch, camera_yaw, 0.0)

func set_touch_look(delta: Vector2) -> void:
    _rotate_camera(delta * touch_sensitivity)

func toggle_flight() -> void:
    flying = not flying
    if flying:
        velocity.y = max(velocity.y, 3.0)

func _physics_process(delta: float) -> void:
    if controls == null:
        controls = get_tree().get_first_node_in_group("touch_controls")
    if Input.is_action_just_pressed("toggle_flight"):
        toggle_flight()

    var keyboard_input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var touch_input := Vector2.ZERO
    var touch_sprint := false
    var touch_ascend := false
    var touch_descend := false
    var touch_jump := false
    if controls != null:
        touch_input = controls.move_vector
        touch_sprint = controls.sprint_pressed
        touch_ascend = controls.ascend_pressed
        touch_descend = controls.descend_pressed
        touch_jump = controls.consume_jump()
    var input_vec := keyboard_input if keyboard_input.length() >= touch_input.length() else touch_input

    var flat_forward := -camera_pivot.global_transform.basis.z
    flat_forward.y = 0.0
    flat_forward = flat_forward.normalized()
    var flat_right := camera_pivot.global_transform.basis.x
    flat_right.y = 0.0
    flat_right = flat_right.normalized()
    var desired_dir := (flat_right * input_vec.x + flat_forward * -input_vec.y).normalized()
    var sprinting := Input.is_action_pressed("sprint") or touch_sprint

    if flying:
        var speed := flight_boost_speed if sprinting else flight_speed
        var vertical := 0.0
        if Input.is_action_pressed("ascend") or touch_ascend:
            vertical += 1.0
        if Input.is_action_pressed("descend") or touch_descend:
            vertical -= 1.0
        var camera_forward := -camera.global_transform.basis.z
        var flight_dir := desired_dir
        if input_vec.length() > 0.05:
            flight_dir = (flat_right * input_vec.x + camera_forward * -input_vec.y).normalized()
        var target := flight_dir * speed
        target.y += vertical * speed
        velocity = velocity.lerp(target, clamp(delta * 3.4, 0.0, 1.0))
        if input_vec.length() > 0.05:
            model_root.rotation.y = lerp_angle(model_root.rotation.y, atan2(-desired_dir.x, -desired_dir.z), delta * 6.0)
            model_root.rotation.z = lerp(model_root.rotation.z, -input_vec.x * 0.28, delta * 4.0)
        else:
            model_root.rotation.z = lerp(model_root.rotation.z, 0.0, delta * 3.0)
    else:
        var speed := sprint_speed if sprinting else walk_speed
        velocity.x = move_toward(velocity.x, desired_dir.x * speed, 28.0 * delta)
        velocity.z = move_toward(velocity.z, desired_dir.z * speed, 28.0 * delta)
        if not is_on_floor():
            velocity.y -= gravity * delta
        if (Input.is_action_just_pressed("jump") or touch_jump) and is_on_floor():
            velocity.y = jump_velocity
        if input_vec.length() > 0.05:
            model_root.rotation.y = lerp_angle(model_root.rotation.y, atan2(-desired_dir.x, -desired_dir.z), delta * 8.0)

    _animate_model(delta, input_vec.length(), sprinting)
    move_and_slide()
    if is_on_floor() and global_position.y > 4.0:
        last_safe_position = global_position
    if global_position.y < -32.0:
        global_position = last_safe_position + Vector3.UP * 4.0
        velocity = Vector3.ZERO

func _animate_model(delta: float, input_amount: float, sprinting: bool) -> void:
    if left_arm == null or right_arm == null or left_leg == null or right_leg == null:
        return
    if flying:
        left_arm.rotation.x = lerp(left_arm.rotation.x, -1.18, delta * 5.0)
        right_arm.rotation.x = lerp(right_arm.rotation.x, -1.18, delta * 5.0)
        left_leg.rotation.x = lerp(left_leg.rotation.x, 0.16, delta * 4.0)
        right_leg.rotation.x = lerp(right_leg.rotation.x, -0.16, delta * 4.0)
        model_root.position.y = lerp(model_root.position.y, sin(Time.get_ticks_msec() * 0.004) * 0.05, delta * 3.0)
        return
    model_root.position.y = lerp(model_root.position.y, 0.0, delta * 7.0)
    if input_amount > 0.05 and is_on_floor():
        animation_time += delta * (10.0 if sprinting else 7.0)
        var swing := sin(animation_time) * (0.78 if sprinting else 0.52)
        left_arm.rotation.x = lerp(left_arm.rotation.x, swing, delta * 12.0)
        right_arm.rotation.x = lerp(right_arm.rotation.x, -swing, delta * 12.0)
        left_leg.rotation.x = lerp(left_leg.rotation.x, -swing, delta * 12.0)
        right_leg.rotation.x = lerp(right_leg.rotation.x, swing, delta * 12.0)
    else:
        left_arm.rotation.x = lerp(left_arm.rotation.x, 0.0, delta * 8.0)
        right_arm.rotation.x = lerp(right_arm.rotation.x, 0.0, delta * 8.0)
        left_leg.rotation.x = lerp(left_leg.rotation.x, 0.0, delta * 8.0)
        right_leg.rotation.x = lerp(right_leg.rotation.x, 0.0, delta * 8.0)
