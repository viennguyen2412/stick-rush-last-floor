class_name Projectile
extends Node2D


@export var hitbox_path: NodePath = ^"Hitbox"
@export var speed: float = 280.0
@export var lifetime: float = 2.2
@export var direction: Vector2 = Vector2.RIGHT

var _hitbox: Hitbox
var _hitbox_shape: CollisionShape2D
var _time_left: float = 0.0


func _ready() -> void:
	_hitbox = get_node_or_null(hitbox_path) as Hitbox
	if _hitbox != null:
		_hitbox.hit.connect(_on_hitbox_hit)
		_hitbox_shape = _hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D

	_time_left = maxf(lifetime, 0.01)
	direction = _normalized_direction(direction)
	_face_direction(direction.x)
	_set_hitbox_active(true)


func _physics_process(delta: float) -> void:
	_time_left -= delta
	if _time_left <= 0.0:
		queue_free()
		return

	global_position += direction * speed * delta


func launch(new_direction: Vector2) -> void:
	direction = _normalized_direction(new_direction)
	_face_direction(direction.x)


func _normalized_direction(raw_direction: Vector2) -> Vector2:
	if raw_direction == Vector2.ZERO:
		return Vector2.RIGHT

	return raw_direction.normalized()


func _face_direction(x_direction: float) -> void:
	if is_zero_approx(x_direction):
		return

	var projectile_scale: Vector2 = scale
	var base_scale_x: float = absf(projectile_scale.x)
	if is_zero_approx(base_scale_x):
		base_scale_x = 1.0

	projectile_scale.x = base_scale_x if x_direction > 0.0 else -base_scale_x
	scale = projectile_scale


func _set_hitbox_active(is_active: bool) -> void:
	if _hitbox != null:
		_hitbox.visible = is_active
		_hitbox.monitoring = is_active

	if _hitbox_shape != null:
		_hitbox_shape.disabled = not is_active


func _on_hitbox_hit(_target: Hurtbox, _damage_packet: DamagePacket) -> void:
	_set_hitbox_active(false)
	queue_free()
