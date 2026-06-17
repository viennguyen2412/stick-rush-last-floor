class_name RangedEnemyAI
extends Node


enum State {
	SPACING,
	WINDUP,
	RECOVERY,
	DEAD,
}


@export var body_path: NodePath = ^".."
@export var target_path: NodePath = ^"../../Player"
@export var visual_root_path: NodePath = ^"../VisualRoot"
@export var telegraph_path: NodePath = ^"../VisualRoot/WindupTelegraph"
@export var projectile_spawn_path: NodePath = ^"../VisualRoot/ProjectileSpawn"
@export var projectile_scene: PackedScene
@export var speed: float = 95.0
@export var acceleration: float = 760.0
@export var friction: float = 1200.0
@export var gravity: float = 1200.0
@export var desired_min_range: float = 150.0
@export var desired_max_range: float = 260.0
@export var minimum_fire_range: float = 150.0
@export var fire_range: float = 280.0
@export var windup_duration: float = 0.45
@export var recovery_duration: float = 0.75

var _body: EnemyBase
var _target: Node2D
var _target_health: HealthComponent
var _visual_root: Node2D
var _telegraph: Polygon2D
var _projectile_spawn: Node2D
var _state: State = State.SPACING
var _state_time_left: float = 0.0


func _ready() -> void:
	_body = get_node_or_null(body_path) as EnemyBase
	_target = get_node_or_null(target_path) as Node2D
	_visual_root = get_node_or_null(visual_root_path) as Node2D
	_telegraph = get_node_or_null(telegraph_path) as Polygon2D
	_projectile_spawn = get_node_or_null(projectile_spawn_path) as Node2D

	if _target != null:
		_target_health = _target.get_node_or_null("Health") as HealthComponent

	if _body != null:
		_body.died.connect(_on_died)

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
		State.SPACING:
			_update_spacing(delta)
		State.WINDUP:
			_update_windup(delta)
		State.RECOVERY:
			_update_recovery(delta)
		_:
			_stop_movement(delta)

	_body.move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not _body.is_on_floor():
		_body.velocity.y += gravity * delta
	elif _body.velocity.y > 0.0:
		_body.velocity.y = 0.0


func _update_spacing(delta: float) -> void:
	if _target == null:
		_stop_movement(delta)
		return

	var horizontal_distance: float = _target.global_position.x - _body.global_position.x
	var abs_distance: float = absf(horizontal_distance)
	var target_direction: float = signf(horizontal_distance)
	_face_direction(target_direction)

	if _can_start_windup(abs_distance):
		_start_windup()
		_stop_movement(delta)
		return

	var move_direction: float = 0.0
	if abs_distance < desired_min_range:
		move_direction = -target_direction
	elif abs_distance > desired_max_range:
		move_direction = target_direction

	if is_zero_approx(move_direction):
		_stop_movement(delta)
		return

	var target_velocity_x: float = move_direction * speed
	_body.velocity.x = move_toward(_body.velocity.x, target_velocity_x, acceleration * delta)


func _update_windup(delta: float) -> void:
	_state_time_left -= delta
	_stop_movement(delta)

	if _target != null:
		_face_direction(signf(_target.global_position.x - _body.global_position.x))

	if _state_time_left > 0.0:
		return

	_fire_projectile()
	_start_recovery()


func _update_recovery(delta: float) -> void:
	_state_time_left -= delta
	_stop_movement(delta)
	if _state_time_left <= 0.0:
		_start_spacing()


func _can_start_windup(abs_distance: float) -> bool:
	if projectile_scene == null:
		return false

	var fire_min_range: float = maxf(minimum_fire_range, desired_min_range)
	if abs_distance < fire_min_range:
		return false

	return abs_distance <= fire_range and abs_distance <= desired_max_range


func _start_spacing() -> void:
	_state = State.SPACING
	_state_time_left = 0.0
	_set_telegraph_visible(false)


func _start_windup() -> void:
	_state = State.WINDUP
	_state_time_left = maxf(windup_duration, 0.0)
	_set_telegraph_visible(true)


func _start_recovery() -> void:
	_state = State.RECOVERY
	_state_time_left = maxf(recovery_duration, 0.0)
	_set_telegraph_visible(false)


func _fire_projectile() -> void:
	if projectile_scene == null:
		return

	var parent: Node = _body.get_parent()
	if parent == null:
		return

	var projectile: Node2D = projectile_scene.instantiate() as Node2D
	if projectile == null:
		return

	parent.add_child(projectile)
	projectile.global_position = _get_projectile_spawn_position()

	var projectile_direction: Vector2 = Vector2(_get_fire_direction(projectile.global_position), 0.0)
	if projectile.has_method("launch"):
		projectile.call("launch", projectile_direction)
	else:
		projectile.set("direction", projectile_direction)


func _get_projectile_spawn_position() -> Vector2:
	if _projectile_spawn != null:
		return _projectile_spawn.global_position

	return _body.global_position + Vector2(_get_facing_direction() * 24.0, -28.0)


func _get_fire_direction(from_position: Vector2) -> float:
	if _target != null:
		var target_direction: float = signf(_target.global_position.x - from_position.x)
		if not is_zero_approx(target_direction):
			return target_direction

	return _get_facing_direction()


func _get_facing_direction() -> float:
	if _visual_root != null and _visual_root.scale.x < 0.0:
		return -1.0

	return 1.0


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


func _set_telegraph_visible(is_visible: bool) -> void:
	if _telegraph != null:
		_telegraph.visible = is_visible


func _is_target_dead() -> bool:
	return _target_health != null and _target_health.is_dead()


func _on_died() -> void:
	_state = State.DEAD
	_state_time_left = 0.0
	_set_telegraph_visible(false)
