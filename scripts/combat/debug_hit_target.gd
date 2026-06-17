extends Node2D


@export var hurtbox_path: NodePath = ^"Hurtbox"
@export var label_path: NodePath = ^"HitCountLabel"
@export var visual_path: NodePath = ^"Visual"
@export var flash_duration: float = 0.12

var _hit_count: int = 0
var _flash_time_left: float = 0.0
var _base_color: Color = Color(0.84, 0.26, 0.24, 1.0)
var _hit_color: Color = Color(1.0, 0.85, 0.15, 1.0)
var _hurtbox: Hurtbox
var _label: Label
var _visual: Polygon2D


func _ready() -> void:
	_hurtbox = get_node_or_null(hurtbox_path) as Hurtbox
	_label = get_node_or_null(label_path) as Label
	_visual = get_node_or_null(visual_path) as Polygon2D

	if _visual != null:
		_base_color = _visual.color

	if _hurtbox != null:
		_hurtbox.hit_received.connect(_on_hit_received)

	_update_label()


func _process(delta: float) -> void:
	if _flash_time_left <= 0.0:
		return

	_flash_time_left -= delta
	if _flash_time_left <= 0.0 and _visual != null:
		_visual.color = _base_color


func _on_hit_received(_source: Hitbox, _damage_packet: DamagePacket) -> void:
	_hit_count += 1
	_flash_time_left = flash_duration

	if _visual != null:
		_visual.color = _hit_color

	_update_label()


func _update_label() -> void:
	if _label == null:
		return

	_label.text = "Hits: %d" % _hit_count
