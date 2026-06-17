class_name ImpactFX
extends Node2D


@export var lifetime: float = 0.18
@export var start_scale: Vector2 = Vector2(0.35, 0.35)
@export var end_scale: Vector2 = Vector2(1.25, 1.25)

var _time_left: float = 0.0
var _visual: Polygon2D


func _ready() -> void:
	_time_left = maxf(lifetime, 0.01)
	scale = start_scale
	_visual = get_node_or_null("Visual") as Polygon2D


func _process(delta: float) -> void:
	_time_left -= delta
	var progress: float = 1.0 - clampf(_time_left / maxf(lifetime, 0.01), 0.0, 1.0)
	scale = start_scale.lerp(end_scale, progress)

	if _visual != null:
		var color: Color = _visual.color
		color.a = 1.0 - progress
		_visual.color = color

	if _time_left <= 0.0:
		queue_free()
