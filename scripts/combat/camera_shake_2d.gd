class_name CameraShake2D
extends Camera2D


@export var decay: float = 9.0
@export var max_offset: Vector2 = Vector2(7.0, 5.0)
@export var max_rotation: float = 0.012

var _trauma: float = 0.0
var _base_offset: Vector2 = Vector2.ZERO
var _base_rotation: float = 0.0


func _ready() -> void:
	add_to_group(&"screen_shake")
	_base_offset = offset
	_base_rotation = rotation


func _process(delta: float) -> void:
	if _trauma <= 0.0:
		offset = _base_offset
		rotation = _base_rotation
		return

	_trauma = maxf(_trauma - decay * delta, 0.0)
	var strength: float = _trauma * _trauma
	offset = _base_offset + Vector2(
		randf_range(-max_offset.x, max_offset.x),
		randf_range(-max_offset.y, max_offset.y)
	) * strength
	rotation = _base_rotation + randf_range(-max_rotation, max_rotation) * strength


func request_shake(amount: float) -> void:
	_trauma = clampf(_trauma + amount, 0.0, 1.0)
