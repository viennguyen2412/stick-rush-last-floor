class_name EnemyAI
extends Node


enum State {
	CHASE,
	WINDUP,
	ATTACK,
	RECOVERY,
	DEAD,
}


@export var body_path: NodePath = ^".."
@export var target_path: NodePath = ^"../../Player"
@export var visual_root_path: NodePath = ^"../VisualRoot"
@export var attack_hitbox_path: NodePath = ^"../VisualRoot/Hitbox"
@export var speed: float = 120.0
@export var acceleration: float = 900.0
@export var friction: float = 1200.0
@export var gravity: float = 1200.0
@export var attack_range: float = 46.0
@export var chase_stop_range: float = 30.0
@export var windup_duration: float = 0.28
@export var active_duration: float = 0.12
@export var recovery_duration: float = 0.42

var _body: EnemyBase
var _target: Node2D
var _target_health: HealthComponent
var _visual_root: Node2D
var _attack_hitbox: Hitbox
var _attack_hitbox_shape: CollisionShape2D
var _telegraph: Polygon2D
var _state: State = State.CHASE
var _state_time_left: float = 0.0


func _ready() -> void:
	_body = get_node_or_null(body_path) as EnemyBase
	_target = get_node_or_null(target_path) as Node2D
	_visual_root = get_node_or_null(visual_root_path) as Node2D
	_attack_hitbox = get_node_or_null(attack_hitbox_path) as Hitbox
	if _attack_hitbox != null:
		_attack_hitbox_shape = _attack_hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D

	if _target != null:
		_target_health = _target.get_node_or_null("Health") as HealthComponent

	if _body != null:
		_body.died.connect(_on_died)

	_telegraph = get_node_or_null("../VisualRoot/WindupTelegraph") as Polygon2D
	_set_attack_hitbox_active(false)
	_set_telegraph_visible(false)


func _physics_process(delta: float) -> void:
	if _body == null:
		return

	if _state == State.DEAD or _body.is_dead() or _is_target_dead():
		_stop_movement(delta)
		_body.move_and_slide()
		return

	_apply_gravity(delta)
	match _state:
		State.CHASE:
			_update_chase(delta)
		State.WINDUP:
			_update_timed_state(delta)
			_stop_movement(delta)
		State.ATTACK:
			_update_timed_state(delta)
			_stop_movement(delta)
		State.RECOVERY:
			_update_timed_state(delta)
			_stop_movement(delta)
		_:
			_stop_movement(delta)

	_body.move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not _body.is_on_floor():
		_body.velocity.y += gravity * delta
	elif _body.velocity.y > 0.0:
		_body.velocity.y = 0.0


func _update_chase(delta: float) -> void:
	if _target == null:
		_stop_movement(delta)
		return

	var horizontal_distance: float = _target.global_position.x - _body.global_position.x
	var direction: float = signf(horizontal_distance)
	_face_direction(direction)

	if absf(horizontal_distance) <= attack_range:
		_start_windup()
		return

	if absf(horizontal_distance) <= chase_stop_range:
		_stop_movement(delta)
		return

	var target_velocity_x: float = direction * speed
	_body.velocity.x = move_toward(_body.velocity.x, target_velocity_x, acceleration * delta)


func _update_timed_state(delta: float) -> void:
	_state_time_left -= delta
	if _state_time_left > 0.0:
		return

	match _state:
		State.WINDUP:
			_start_attack()
		State.ATTACK:
			_start_recovery()
		State.RECOVERY:
			_start_chase()
		_:
			_start_chase()


func _start_chase() -> void:
	_state = State.CHASE
	_state_time_left = 0.0
	_set_attack_hitbox_active(false)
	_set_telegraph_visible(false)


func _start_windup() -> void:
	_state = State.WINDUP
	_state_time_left = maxf(windup_duration, 0.0)
	_set_attack_hitbox_active(false)
	_set_telegraph_visible(true)


func _start_attack() -> void:
	_state = State.ATTACK
	_state_time_left = maxf(active_duration, 0.0)
	_set_telegraph_visible(false)
	_set_attack_hitbox_active(true)


func _start_recovery() -> void:
	_state = State.RECOVERY
	_state_time_left = maxf(recovery_duration, 0.0)
	_set_attack_hitbox_active(false)
	_set_telegraph_visible(false)


func _stop_movement(delta: float) -> void:
	_body.velocity.x = move_toward(_body.velocity.x, 0.0, friction * delta)


func _face_direction(direction: float) -> void:
	if _visual_root == null or is_zero_approx(direction):
		return

	var visual_scale: Vector2 = _visual_root.scale
	var base_scale_x: float = absf(visual_scale.x)
	if is_zero_approx(base_scale_x):
		base_scale_x = 1.0

	visual_scale.x = base_scale_x if direction > 0.0 else -base_scale_x
	_visual_root.scale = visual_scale


func _set_attack_hitbox_active(is_active: bool) -> void:
	if _attack_hitbox != null:
		_attack_hitbox.visible = is_active
		_attack_hitbox.monitoring = is_active

	if _attack_hitbox_shape != null:
		_attack_hitbox_shape.disabled = not is_active


func _set_telegraph_visible(is_visible: bool) -> void:
	if _telegraph != null:
		_telegraph.visible = is_visible


func _is_target_dead() -> bool:
	return _target_health != null and _target_health.is_dead()


func _on_died() -> void:
	_state = State.DEAD
	_state_time_left = 0.0
	_set_attack_hitbox_active(false)
	_set_telegraph_visible(false)
