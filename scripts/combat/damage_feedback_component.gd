class_name DamageFeedbackComponent
extends Node


const HITSTOP_MANAGERS_GROUP: StringName = &"hitstop_managers"
const SCREEN_SHAKE_GROUP: StringName = &"screen_shake"
const DEFAULT_IMPACT_FX_SCENE: PackedScene = preload("res://scenes/combat/ImpactFlash.tscn")


@export var health_path: NodePath = ^"../Health"
@export var body_path: NodePath = ^".."
@export var impact_fx_scene: PackedScene = DEFAULT_IMPACT_FX_SCENE
@export var position_knockback_scale: float = 0.12
@export var screen_shake_multiplier: float = 1.0

var _health: HealthComponent
var _body: Node2D


func _ready() -> void:
	_health = get_node_or_null(health_path) as HealthComponent
	_body = get_node_or_null(body_path) as Node2D

	if _health != null:
		_health.damaged.connect(_on_damaged)


func _on_damaged(_amount: float, source: Hitbox, packet: DamagePacket) -> void:
	if packet == null:
		return

	_request_hitstop(packet.hitstop)
	_apply_knockback(source, packet.knockback)
	_request_screen_shake(packet)
	_spawn_impact_fx(source)


func _request_hitstop(duration: float) -> void:
	if duration <= 0.0:
		return

	var manager: Node = get_tree().get_first_node_in_group(HITSTOP_MANAGERS_GROUP)
	if manager != null and manager.has_method("request_hitstop"):
		manager.call("request_hitstop", duration)


func _apply_knockback(source: Hitbox, knockback: Vector2) -> void:
	if _body == null or knockback == Vector2.ZERO:
		return

	var resolved_knockback: Vector2 = _resolve_knockback(source, knockback)
	if _body.has_method("apply_external_impulse"):
		_body.call("apply_external_impulse", resolved_knockback)
		return

	var character_body: CharacterBody2D = _body as CharacterBody2D
	if character_body != null:
		character_body.velocity += resolved_knockback
		return

	_body.global_position += resolved_knockback * position_knockback_scale


func _resolve_knockback(source: Hitbox, knockback: Vector2) -> Vector2:
	var resolved_knockback: Vector2 = knockback
	if source == null or _body == null or is_zero_approx(knockback.x):
		return resolved_knockback

	var direction: float = signf(_body.global_position.x - source.global_position.x)
	if is_zero_approx(direction):
		direction = signf(knockback.x)

	if is_zero_approx(direction):
		direction = 1.0

	resolved_knockback.x = absf(knockback.x) * direction
	return resolved_knockback


func _request_screen_shake(packet: DamagePacket) -> void:
	var shake: Node = get_tree().get_first_node_in_group(SCREEN_SHAKE_GROUP)
	if shake == null or not shake.has_method("request_shake"):
		return

	var knockback_strength: float = absf(packet.knockback.x) / 900.0
	var hitstop_strength: float = packet.hitstop * 3.0
	var amount: float = clampf((knockback_strength + hitstop_strength) * screen_shake_multiplier, 0.05, 0.35)
	shake.call("request_shake", amount)


func _spawn_impact_fx(source: Hitbox) -> void:
	if impact_fx_scene == null or _body == null:
		return

	var fx: Node2D = impact_fx_scene.instantiate() as Node2D
	if fx == null:
		return

	var fx_parent: Node = get_tree().current_scene
	if fx_parent == null:
		fx_parent = get_tree().root

	fx_parent.add_child(fx)
	fx.global_position = _get_impact_position(source)


func _get_impact_position(source: Hitbox) -> Vector2:
	if source == null or _body == null:
		return _body.global_position

	return source.global_position.lerp(_body.global_position, 0.55)
