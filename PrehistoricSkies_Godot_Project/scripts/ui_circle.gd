extends Control

@export var circle_radius := 64.0
@export var circle_color := Color(0.2, 0.2, 0.2, 0.5)

func _ready() -> void:
    custom_minimum_size = Vector2(circle_radius * 2.0, circle_radius * 2.0)
    queue_redraw()

func _draw() -> void:
    draw_circle(Vector2.ZERO, circle_radius, circle_color)
    draw_arc(Vector2.ZERO, circle_radius, 0.0, TAU, 64, Color(1,1,1,0.22), 2.0, true)
