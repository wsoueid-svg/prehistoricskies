extends CanvasLayer

@export var player_path: NodePath
var player
var move_vector := Vector2.ZERO
var sprint_pressed := false
var ascend_pressed := false
var descend_pressed := false
var jump_queued := false
var joystick_touch := -1
var look_touch := -1
var joystick_center := Vector2.ZERO
var joystick_radius := 82.0
var joystick_knob: Control
var joystick_base: Control
var mode_label: Label
var altitude_label: Label
var objective_label: Label
var flight_button: Button
var fps_label: Label

func _ready() -> void:
    add_to_group("touch_controls")
    player = get_node_or_null(player_path)
    _build_ui()

func _build_ui() -> void:
    var root := Control.new()
    root.name = "HUDRoot"
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_PASS
    add_child(root)

    var vignette := ColorRect.new()
    vignette.color = Color(0.0, 0.0, 0.0, 0.08)
    vignette.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root.add_child(vignette)

    var title := Label.new()
    title.text = "PREHISTORIC SKIES"
    title.position = Vector2(24, 18)
    title.add_theme_font_size_override("font_size", 22)
    title.add_theme_color_override("font_color", Color("#f0e7c8"))
    root.add_child(title)

    mode_label = Label.new()
    mode_label.position = Vector2(26, 49)
    mode_label.add_theme_font_size_override("font_size", 16)
    root.add_child(mode_label)
    altitude_label = Label.new()
    altitude_label.position = Vector2(26, 72)
    altitude_label.add_theme_font_size_override("font_size", 15)
    root.add_child(altitude_label)
    fps_label = Label.new()
    fps_label.position = Vector2(26, 94)
    fps_label.add_theme_font_size_override("font_size", 13)
    fps_label.modulate = Color(1,1,1,0.7)
    root.add_child(fps_label)

    objective_label = Label.new()
    objective_label.text = "Explore the island • Observe the herds • Reach the summit"
    objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    objective_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
    objective_label.position = Vector2(-260, 20)
    objective_label.size = Vector2(520, 34)
    objective_label.add_theme_font_size_override("font_size", 15)
    objective_label.add_theme_color_override("font_color", Color("#f5eed5"))
    root.add_child(objective_label)

    joystick_base = Control.new()
    joystick_base.name = "JoystickBase"
    var initial_viewport_size := get_viewport().get_visible_rect().size
    joystick_base.position = Vector2(110, initial_viewport_size.y - 130)
    joystick_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
    joystick_base.set_script(preload("res://scripts/ui_circle.gd"))
    joystick_base.set("circle_radius", joystick_radius)
    joystick_base.set("circle_color", Color(0.08, 0.11, 0.09, 0.42))
    root.add_child(joystick_base)
    joystick_knob = Control.new()
    joystick_knob.position = joystick_base.position
    joystick_knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
    joystick_knob.set_script(preload("res://scripts/ui_circle.gd"))
    joystick_knob.set("circle_radius", 34.0)
    joystick_knob.set("circle_color", Color(0.88, 0.83, 0.65, 0.76))
    root.add_child(joystick_knob)
    joystick_center = joystick_base.position

    flight_button = _make_button(root, "FLY", Vector2(-112, -112), Vector2(86, 86), Control.PRESET_BOTTOM_RIGHT)
    var jump_button := _make_button(root, "JUMP", Vector2(-216, -96), Vector2(82, 64), Control.PRESET_BOTTOM_RIGHT)
    var up_button := _make_button(root, "UP", Vector2(-112, -212), Vector2(70, 58), Control.PRESET_BOTTOM_RIGHT)
    var down_button := _make_button(root, "DOWN", Vector2(-202, -188), Vector2(74, 58), Control.PRESET_BOTTOM_RIGHT)
    var sprint_button := _make_button(root, "BOOST", Vector2(28, -98), Vector2(88, 62), Control.PRESET_BOTTOM_LEFT)
    sprint_button.position.x = 218
    sprint_button.position.y = -92

    flight_button.pressed.connect(_on_flight_pressed)
    jump_button.pressed.connect(_on_jump_pressed)
    _bind_hold(up_button, "ascend")
    _bind_hold(down_button, "descend")
    _bind_hold(sprint_button, "sprint")

    root.gui_input.connect(_on_root_input)

    var help := Label.new()
    help.text = "Left thumb: move   •   Right drag: look   •   F: flight on desktop"
    help.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    help.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
    help.position = Vector2(-310, -42)
    help.size = Vector2(620, 28)
    help.add_theme_font_size_override("font_size", 13)
    help.modulate = Color(1,1,1,0.72)
    root.add_child(help)

func _make_button(parent: Control, text_value: String, offset: Vector2, size_value: Vector2, preset: int) -> Button:
    var button := Button.new()
    button.text = text_value
    button.size = size_value
    button.set_anchors_preset(preset)
    button.position = offset
    button.add_theme_font_size_override("font_size", 14)
    button.modulate = Color(0.96, 0.93, 0.82, 0.82)
    parent.add_child(button)
    return button

func _bind_hold(button: Button, kind: String) -> void:
    button.button_down.connect(_set_hold.bind(kind, true))
    button.button_up.connect(_set_hold.bind(kind, false))

func _set_hold(kind: String, value: bool) -> void:
    match kind:
        "ascend": ascend_pressed = value
        "descend": descend_pressed = value
        "sprint": sprint_pressed = value

func _on_jump_pressed() -> void:
    jump_queued = true

func _on_flight_pressed() -> void:
    if player != null and player.has_method("toggle_flight"):
        player.toggle_flight()

func consume_jump() -> bool:
    var value := jump_queued
    jump_queued = false
    return value

func _process(_delta: float) -> void:
    if player == null:
        player = get_tree().get_first_node_in_group("player")
    if player != null:
        mode_label.text = "MODE  •  " + ("FLIGHT" if player.flying else "GROUND")
        altitude_label.text = "ALTITUDE  •  %d m" % max(0, int(player.global_position.y - 5.0))
        flight_button.text = "LAND" if player.flying else "FLY"
    fps_label.text = "%d FPS" % Engine.get_frames_per_second()

func _on_root_input(event: InputEvent) -> void:
    var viewport_size := get_viewport().get_visible_rect().size
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.x < viewport_size.x * 0.43 and event.position.y > viewport_size.y * 0.45 and joystick_touch == -1:
                joystick_touch = event.index
                joystick_center = event.position
                joystick_base.position = joystick_center
                joystick_knob.position = joystick_center
            elif look_touch == -1:
                look_touch = event.index
        else:
            if event.index == joystick_touch:
                joystick_touch = -1
                move_vector = Vector2.ZERO
                joystick_base.position = Vector2(110, viewport_size.y - 130)
                joystick_knob.position = joystick_base.position
                joystick_center = joystick_base.position
            elif event.index == look_touch:
                look_touch = -1
    elif event is InputEventScreenDrag:
        if event.index == joystick_touch:
            var offset := event.position - joystick_center
            if offset.length() > joystick_radius:
                offset = offset.normalized() * joystick_radius
            joystick_knob.position = joystick_center + offset
            move_vector = Vector2(offset.x / joystick_radius, offset.y / joystick_radius)
        elif event.index == look_touch and player != null:
            player.set_touch_look(event.relative)
