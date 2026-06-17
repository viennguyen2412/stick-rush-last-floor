class_name EnemyBase
extends CharacterBody2D


signal died


@export var health_path: NodePath = ^"Health"
@export var hurtbox_path: NodePath = ^"Hurtbox"
@export var collision_shape_path: NodePath = ^"CollisionShape2D"
@export var visual_root_path: NodePath = ^"VisualRoot"

var _health: HealthComponent
var _hurtbox: Hurtbox
var _collision_shape: CollisionShape2D
var _visual_root: Node2D
var _is_dead: bool = false


func _ready() -> void:
	_health = get_node_or_null(health_path) as HealthComponent
	if _health != null:
		_health.died.connect(_on_died)

	_hurtbox = get_node_or_null(hurtbox_path) as Hurtbox
	_collision_shape = get_node_or_null(collision_shape_path) as CollisionShape2D
	_visual_root = get_node_or_null(visual_root_path) as Node2D


func is_dead() -> bool:
	return _is_dead


func can_attack() -> bool:
	return not _is_dead


func _on_died() -> void:
	_is_dead = true
	velocity = Vector2.ZERO
	_disable_collisions()
	_dim_visuals()
	set_physics_process(false)
	died.emit()


func apply_external_impulse(impulse: Vector2) -> void:
	if _is_dead:
		return

	velocity += impulse


func _disable_collisions() -> void:
	if _collision_shape != null:
		_collision_shape.set_deferred("disabled", true)

	if _hurtbox == null:
		return

	_hurtbox.set_deferred("monitorable", false)
	for child: Node in _hurtbox.get_children():
		var collision_shape: CollisionShape2D = child as CollisionShape2D
		if collision_shape != null:
			collision_shape.set_deferred("disabled", true)


func _dim_visuals() -> void:
	if _visual_root == null:
		return

	for child: Node in _visual_root.get_children():
		var polygon: Polygon2D = child as Polygon2D
		if polygon != null:
			polygon.color = Color(0.22, 0.22, 0.22, polygon.color.a)
