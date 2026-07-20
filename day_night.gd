extends DirectionalLight3D

@export var cycle_duration_seconds := 420.0
var time_of_day := 0.19

func _process(delta: float) -> void:
    time_of_day = fmod(time_of_day + delta / cycle_duration_seconds, 1.0)
    rotation_degrees.x = -15.0 - sin(time_of_day * TAU) * 72.0
    rotation_degrees.y = time_of_day * 360.0 - 120.0
    var daylight := clamp(sin(time_of_day * TAU) * 1.9 + 0.25, 0.08, 1.0)
    light_energy = lerp(0.12, 1.45, daylight)
    light_color = Color("#8da8c7").lerp(Color("#ffe0a8"), daylight)
