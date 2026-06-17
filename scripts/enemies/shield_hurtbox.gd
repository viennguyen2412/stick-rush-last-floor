class_name ShieldHurtbox
extends Hurtbox


signal attack_blocked(source: Hitbox, damage_packet: DamagePacket)
signal guard_broken


@export var visual_root_path: NodePath = ^"../VisualRoot"
@export var ai_path: NodePath = ^"../AI"
@export var shield_visual_path: NodePath = ^"../VisualRoot/Shield"
@export var max_guard: float = 3.0
@export var stagger_duration: float = 0.85

var _visual_root: Node2D
var _ai: Node
var _shield_visual: Polygon2D
var _shield_base_color: Color = Color.WHITE
var _guard: float = 0.0
var _guard_recover_time_left: float = 0.0
var _is_guard_broken: bool = false


func _ready() -> void:
	_visual_root = get_node_or_null(visual_root_path) as Node2D
	_ai = get_node_or_null(ai_path)
	_shield_visual = get_node_or_null(shield_visual_path) as Polygon2D
	if _shield_visual != null:
		_shield_base_color = _shield_visual.color

	_guard = maxf(max_guard, 1.0)
	set_process(false)


func _process(delta: float) -> void:
	if not _is_guard_broken:
		set_process(false)
		return

	_guard_recover_time_left -= delta
	if _guard_recover_time_left <= 0.0:
		_reset_guard()


func receive_hit(source: Hitbox, packet: DamagePacket) -> void:
	if packet == null:
		return

	if _is_guard_broken or not _is_front_hit(source):
		hit_received.emit(source, packet)
		return

	if packet.is_heavy:
		_break_guard()
		hit_received.emit(source, packet)
		return

	_block_hit(source, packet)


func _block_hit(source: Hitbox, packet: DamagePacket) -> void:
	attack_blocked.emit(source, packet)
	_guard = maxf(_guard - maxf(packet.guard_damage, 0.0), 0.0)

	if _guard <= 0.0:
		_break_guard()
		return

	_flash_shield(Color(1.0, 0.94, 0.22, 1.0))


func _break_guard() -> void:
	if _is_guard_broken:
		return

	_is_guard_broken = true
	_guard = 0.0
	_guard_recover_time_left = maxf(stagger_duration, 0.05)
	guard_broken.emit()
	_set_shield_color(Color(1.0, 0.35, 0.18, 1.0))
	set_process(true)

	if _ai != null and _ai.has_method("stagger"):
		_ai.call("stagger", stagger_duration)


func _reset_guard() -> void:
	_is_guard_broken = false
	_guard = maxf(max_guard, 1.0)
	set_process(false)

	if _shield_visual != null:
		_shield_visual.color = _shield_base_color


func _is_front_hit(source: Hitbox) -> bool:
	if source == null:
		return true

	var hit_direction: float = signf(source.global_position.x - global_position.x)
	if is_zero_approx(hit_direction):
		return true

	return hit_direction == _get_facing_direction()


func _get_facing_direction() -> float:
	if _visual_root != null and _visual_root.scale.x < 0.0:
		return -1.0

	return 1.0


func _flash_shield(color: Color) -> void:
	if _shield_visual == null:
		return

	_set_shield_color(color)
	var tween: Tween = create_tween()
	tween.tween_property(_shield_visual, "color", _shield_base_color, 0.14)


func _set_shield_color(color: Color) -> void:
	if _shield_visual != null:
		_shield_visual.color = color
