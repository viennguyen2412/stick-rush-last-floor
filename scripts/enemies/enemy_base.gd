class_name EnemyBase
extends CharacterBody2D


signal died


@export var health_path: NodePath = ^"Health"

var _health: HealthComponent
var _is_dead: bool = false


func _ready() -> void:
	_health = get_node_or_null(health_path) as HealthComponent
	if _health != null:
		_health.died.connect(_on_died)


func is_dead() -> bool:
	return _is_dead


func can_attack() -> bool:
	return not _is_dead


func _on_died() -> void:
	_is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	died.emit()
