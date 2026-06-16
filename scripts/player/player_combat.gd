class_name PlayerCombat
extends Node


signal parry_success


enum ComboPhase {
	IDLE,
	STARTUP,
	ACTIVE,
	RECOVERY,
}


enum ParryPhase {
	IDLE,
	WINDOW,
	RECOVERY,
}


@export var hitbox_path: NodePath = ^"../VisualRoot/Hitbox"
@export var combo_timeout: float = 0.5
@export var parry_window_duration: float = 0.15
@export var parry_recovery_duration: float = 0.3
@export var hit_1_startup_duration: float = 0.08
@export var hit_1_active_duration: float = 0.08
@export var hit_1_recovery_duration: float = 0.16
@export var hit_2_startup_duration: float = 0.1
@export var hit_2_active_duration: float = 0.08
@export var hit_2_recovery_duration: float = 0.18
@export var hit_3_startup_duration: float = 0.14
@export var hit_3_active_duration: float = 0.12
@export var hit_3_recovery_duration: float = 0.26
@export var hit_1_hitbox_size: Vector2 = Vector2(42.0, 26.0)
@export var hit_2_hitbox_size: Vector2 = Vector2(48.0, 28.0)
@export var hit_3_hitbox_size: Vector2 = Vector2(58.0, 34.0)
@export var hit_1_hitbox_offset: Vector2 = Vector2(34.0, -29.0)
@export var hit_2_hitbox_offset: Vector2 = Vector2(38.0, -29.0)
@export var hit_3_hitbox_offset: Vector2 = Vector2(44.0, -30.0)

var _hitbox: Area2D
var _hitbox_shape: CollisionShape2D
var _hitbox_rectangle: RectangleShape2D
var _debug_visual: Polygon2D
var _attack_hitbox_color: Color = Color(1.0, 0.22, 0.12, 0.48)
var _phase: ComboPhase = ComboPhase.IDLE
var _current_hit: int = 0
var _phase_time_left: float = 0.0
var _combo_time_left: float = 0.0
var _queued_next_hit: bool = false
var _parry_phase: ParryPhase = ParryPhase.IDLE
var _parry_time_left: float = 0.0


func _ready() -> void:
	_hitbox = get_node_or_null(hitbox_path) as Area2D
	if _hitbox == null:
		return

	_hitbox_shape = _hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D
	_debug_visual = _hitbox.get_node_or_null("DebugVisual") as Polygon2D
	if _debug_visual != null:
		_attack_hitbox_color = _debug_visual.color

	if _hitbox_shape != null:
		var rectangle_shape: RectangleShape2D = _hitbox_shape.shape as RectangleShape2D
		if rectangle_shape != null:
			_hitbox_rectangle = rectangle_shape.duplicate() as RectangleShape2D
			_hitbox_shape.shape = _hitbox_rectangle

	_set_hitbox_active(false)


func _process(delta: float) -> void:
	_handle_parry_input()
	_handle_attack_input()
	_update_combo(delta)
	_update_parry(delta)


func try_parry() -> bool:
	if _parry_phase != ParryPhase.WINDOW:
		return false

	_finish_successful_parry()
	return true


func is_parry_window_active() -> bool:
	return _parry_phase == ParryPhase.WINDOW


func is_parry_recovering() -> bool:
	return _parry_phase == ParryPhase.RECOVERY


func _handle_parry_input() -> void:
	if not Input.is_action_just_pressed("dodge_parry"):
		return

	if _parry_phase != ParryPhase.IDLE:
		return

	_start_parry()


func _handle_attack_input() -> void:
	if not Input.is_action_just_pressed("attack"):
		return

	if _parry_phase != ParryPhase.IDLE:
		return

	if _phase == ComboPhase.IDLE:
		if _current_hit > 0 and _combo_time_left > 0.0 and _current_hit < 3:
			_start_hit(_current_hit + 1)
		else:
			_start_hit(1)
		return

	if _current_hit < 3:
		_queued_next_hit = true


func _update_parry(delta: float) -> void:
	if _parry_phase == ParryPhase.IDLE:
		return

	_parry_time_left -= delta
	while _parry_time_left <= 0.0 and _parry_phase != ParryPhase.IDLE:
		var overflow: float = -_parry_time_left
		_advance_parry_phase()
		if _parry_phase != ParryPhase.IDLE:
			_parry_time_left -= overflow


func _update_combo(delta: float) -> void:
	if _phase == ComboPhase.IDLE:
		_update_combo_timeout(delta)
		return

	_phase_time_left -= delta
	while _phase_time_left <= 0.0 and _phase != ComboPhase.IDLE:
		var overflow: float = -_phase_time_left
		_advance_phase()
		if _phase != ComboPhase.IDLE:
			_phase_time_left -= overflow


func _update_combo_timeout(delta: float) -> void:
	if _current_hit == 0:
		return

	_combo_time_left -= delta
	if _combo_time_left <= 0.0:
		_reset_combo()


func _start_parry() -> void:
	_reset_combo()
	_parry_phase = ParryPhase.WINDOW
	_parry_time_left = maxf(parry_window_duration, 0.0)
	_configure_parry_feedback(false)
	_set_parry_feedback_visible(true)


func _advance_parry_phase() -> void:
	match _parry_phase:
		ParryPhase.WINDOW:
			_parry_phase = ParryPhase.RECOVERY
			_parry_time_left = maxf(parry_recovery_duration, 0.0)
			_configure_parry_feedback(true)
		ParryPhase.RECOVERY:
			_finish_failed_parry()
		_:
			_finish_failed_parry()


func _finish_successful_parry() -> void:
	_parry_phase = ParryPhase.IDLE
	_parry_time_left = 0.0
	_set_parry_feedback_visible(false)
	parry_success.emit()


func _finish_failed_parry() -> void:
	_parry_phase = ParryPhase.IDLE
	_parry_time_left = 0.0
	_set_parry_feedback_visible(false)


func _start_hit(hit_number: int) -> void:
	_current_hit = clampi(hit_number, 1, 3)
	_queued_next_hit = false
	_combo_time_left = 0.0
	_phase = ComboPhase.STARTUP
	_phase_time_left = _get_startup_duration(_current_hit)
	_configure_hitbox(_current_hit)
	_set_hitbox_active(false)


func _advance_phase() -> void:
	match _phase:
		ComboPhase.STARTUP:
			_phase = ComboPhase.ACTIVE
			_phase_time_left = _get_active_duration(_current_hit)
			_set_hitbox_active(true)
		ComboPhase.ACTIVE:
			_phase = ComboPhase.RECOVERY
			_phase_time_left = _get_recovery_duration(_current_hit)
			_set_hitbox_active(false)
		ComboPhase.RECOVERY:
			_finish_recovery()
		_:
			_reset_combo()


func _finish_recovery() -> void:
	if _current_hit >= 3:
		_reset_combo()
		return

	if _queued_next_hit:
		_start_hit(_current_hit + 1)
		return

	_phase = ComboPhase.IDLE
	_phase_time_left = 0.0
	_combo_time_left = combo_timeout


func _reset_combo() -> void:
	_phase = ComboPhase.IDLE
	_current_hit = 0
	_phase_time_left = 0.0
	_combo_time_left = 0.0
	_queued_next_hit = false
	_set_hitbox_active(false)


func _configure_hitbox(hit_number: int) -> void:
	if _hitbox == null:
		return

	var hitbox_size: Vector2 = _get_hitbox_size(hit_number)
	_hitbox.position = _get_hitbox_offset(hit_number)

	if _hitbox_rectangle != null:
		_hitbox_rectangle.size = hitbox_size

	if _debug_visual != null:
		_debug_visual.color = _attack_hitbox_color
		_set_debug_visual_size(hitbox_size)


func _configure_parry_feedback(is_recovery: bool) -> void:
	if _hitbox == null:
		return

	var feedback_size: Vector2 = Vector2(54.0, 46.0)
	_hitbox.position = Vector2(24.0, -30.0)

	if _hitbox_rectangle != null:
		_hitbox_rectangle.size = feedback_size

	if _debug_visual != null:
		_debug_visual.color = Color(0.95, 0.95, 1.0, 0.28) if is_recovery else Color(0.25, 0.82, 1.0, 0.62)
		_set_debug_visual_size(feedback_size)


func _set_debug_visual_size(size: Vector2) -> void:
	if _debug_visual == null:
		return

	var half_size: Vector2 = size * 0.5
	_debug_visual.polygon = PackedVector2Array([
		Vector2(-half_size.x, -half_size.y),
		Vector2(half_size.x, -half_size.y),
		Vector2(half_size.x, half_size.y),
		Vector2(-half_size.x, half_size.y),
	])


func _set_parry_feedback_visible(is_visible: bool) -> void:
	if _hitbox != null:
		_hitbox.visible = is_visible
		_hitbox.monitoring = false

	if _hitbox_shape != null:
		_hitbox_shape.disabled = true


func _set_hitbox_active(is_active: bool) -> void:
	if _hitbox != null:
		_hitbox.visible = is_active
		_hitbox.monitoring = is_active

	if _hitbox_shape != null:
		_hitbox_shape.disabled = not is_active


func _get_startup_duration(hit_number: int) -> float:
	match hit_number:
		1:
			return hit_1_startup_duration
		2:
			return hit_2_startup_duration
		3:
			return hit_3_startup_duration
		_:
			return 0.0


func _get_active_duration(hit_number: int) -> float:
	match hit_number:
		1:
			return hit_1_active_duration
		2:
			return hit_2_active_duration
		3:
			return hit_3_active_duration
		_:
			return 0.0


func _get_recovery_duration(hit_number: int) -> float:
	match hit_number:
		1:
			return hit_1_recovery_duration
		2:
			return hit_2_recovery_duration
		3:
			return hit_3_recovery_duration
		_:
			return 0.0


func _get_hitbox_size(hit_number: int) -> Vector2:
	match hit_number:
		1:
			return hit_1_hitbox_size
		2:
			return hit_2_hitbox_size
		3:
			return hit_3_hitbox_size
		_:
			return hit_1_hitbox_size


func _get_hitbox_offset(hit_number: int) -> Vector2:
	match hit_number:
		1:
			return hit_1_hitbox_offset
		2:
			return hit_2_hitbox_offset
		3:
			return hit_3_hitbox_offset
		_:
			return hit_1_hitbox_offset
