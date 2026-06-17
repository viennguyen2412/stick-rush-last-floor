class_name PlayerController
extends CharacterBody2D


@export var speed: float = 260.0
@export var acceleration: float = 1800.0
@export var jump_velocity: float = 420.0
@export var gravity: float = 1200.0
@export var visual_root_path: NodePath = ^"VisualRoot"
@export var health_path: NodePath = ^"Health"

var _visual_root: Node2D
var _health: HealthComponent
var _is_dead: bool = false


func _ready() -> void:
	_visual_root = get_node_or_null(visual_root_path) as Node2D
	_health = get_node_or_null(health_path) as HealthComponent
	if _health != null:
		_health.died.connect(_on_died)


func _physics_process(delta: float) -> void:
	if _is_dead:
		_apply_gravity(delta)
		velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
		move_and_slide()
		return

	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal_movement(delta)
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0


func _handle_jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump_dash"):
		velocity.y = -jump_velocity


func _handle_horizontal_movement(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	var target_velocity_x: float = direction * speed
	velocity.x = move_toward(velocity.x, target_velocity_x, acceleration * delta)

	if not is_zero_approx(direction):
		_set_facing(direction)


func _set_facing(direction: float) -> void:
	if _visual_root == null:
		return

	var visual_scale: Vector2 = _visual_root.scale
	var base_scale_x: float = absf(visual_scale.x)
	if is_zero_approx(base_scale_x):
		base_scale_x = 1.0

	visual_scale.x = base_scale_x if direction > 0.0 else -base_scale_x
	_visual_root.scale = visual_scale


func _on_died() -> void:
	_is_dead = true
	velocity = Vector2.ZERO
