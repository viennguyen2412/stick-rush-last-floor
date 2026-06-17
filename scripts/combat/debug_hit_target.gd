extends Node2D


@export var hurtbox_path: NodePath = ^"Hurtbox"
@export var health_path: NodePath = ^"Health"
@export var label_path: NodePath = ^"HitCountLabel"
@export var visual_path: NodePath = ^"Visual"
@export var flash_duration: float = 0.12

var _hit_count: int = 0
var _current_health: float = 0.0
var _max_health: float = 0.0
var _flash_time_left: float = 0.0
var _base_color: Color = Color(0.84, 0.26, 0.24, 1.0)
var _hit_color: Color = Color(1.0, 0.85, 0.15, 1.0)
var _dead_color: Color = Color(0.2, 0.2, 0.2, 1.0)
var _hurtbox: Hurtbox
var _health: HealthComponent
var _label: Label
var _visual: Polygon2D


func _ready() -> void:
	_hurtbox = get_node_or_null(hurtbox_path) as Hurtbox
	_health = get_node_or_null(health_path) as HealthComponent
	_label = get_node_or_null(label_path) as Label
	_visual = get_node_or_null(visual_path) as Polygon2D

	if _visual != null:
		_base_color = _visual.color

	if _hurtbox != null:
		_hurtbox.hit_received.connect(_on_hit_received)

	if _health != null:
		_current_health = _health.current_health
		_max_health = _health.max_health
		_health.health_changed.connect(_on_health_changed)
		_health.died.connect(_on_died)

	_update_label()


func _process(delta: float) -> void:
	if _flash_time_left <= 0.0:
		return

	_flash_time_left -= delta
	if _flash_time_left <= 0.0 and _visual != null:
		_visual.color = _base_color


func _on_hit_received(_source: Hitbox, _damage_packet: DamagePacket) -> void:
	_hit_count += 1

	if _health != null and _health.is_dead():
		_update_label()
		return

	_flash_time_left = flash_duration

	if _visual != null:
		_visual.color = _hit_color

	_update_label()


func _on_health_changed(current_health: float, max_health: float) -> void:
	_current_health = current_health
	_max_health = max_health
	_update_label()


func _on_died() -> void:
	_disable_hurtbox()
	_flash_time_left = 0.0
	if _visual != null:
		_visual.color = _dead_color

	_update_label()


func _update_label() -> void:
	if _label == null:
		return

	if _health != null and _health.is_dead():
		_label.text = "KO\nHits: %d" % _hit_count
		return

	_label.text = "HP: %d / %d\nHits: %d" % [
		int(roundf(_current_health)),
		int(roundf(_max_health)),
		_hit_count,
	]


func _disable_hurtbox() -> void:
	if _hurtbox == null:
		return

	_hurtbox.set_deferred("monitorable", false)
	for child: Node in _hurtbox.get_children():
		var collision_shape: CollisionShape2D = child as CollisionShape2D
		if collision_shape != null:
			collision_shape.set_deferred("disabled", true)
