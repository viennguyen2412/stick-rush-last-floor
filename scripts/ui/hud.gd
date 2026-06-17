class_name HUD
extends Control


@export var player_health_path: NodePath = ^"../Player/Health"
@export var health_label_path: NodePath = ^"HealthLabel"

var _player_health: HealthComponent
var _health_label: Label


func _ready() -> void:
	_health_label = get_node_or_null(health_label_path) as Label
	_player_health = get_node_or_null(player_health_path) as HealthComponent

	if _player_health == null:
		_update_health_label(0.0, 0.0)
		return

	_player_health.health_changed.connect(_on_player_health_changed)
	_player_health.died.connect(_on_player_died)
	_update_health_label(_player_health.current_health, _player_health.max_health)


func _on_player_health_changed(current_health: float, max_health: float) -> void:
	_update_health_label(current_health, max_health)


func _on_player_died() -> void:
	if _health_label != null:
		_health_label.text = "HP: 0 / %d  KO" % int(roundf(_player_health.max_health))


func _update_health_label(current_health: float, max_health: float) -> void:
	if _health_label == null:
		return

	if max_health <= 0.0:
		_health_label.text = "HP: -- / --"
		return

	_health_label.text = "HP: %d / %d" % [int(roundf(current_health)), int(roundf(max_health))]
