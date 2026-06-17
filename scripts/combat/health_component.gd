class_name HealthComponent
extends Node


signal health_changed(current_health: float, max_health: float)
signal damaged(amount: float, source: Hitbox, damage_packet: DamagePacket)
signal died


@export var max_health: float = 100.0
@export var start_full: bool = true
@export var current_health: float = 100.0
@export var hurtbox_path: NodePath = ^"../Hurtbox"

var _hurtbox: Hurtbox
var _is_dead: bool = false


func _ready() -> void:
	max_health = maxf(max_health, 1.0)
	if start_full:
		current_health = max_health
	else:
		current_health = clampf(current_health, 0.0, max_health)

	_hurtbox = get_node_or_null(hurtbox_path) as Hurtbox
	if _hurtbox != null:
		_hurtbox.hit_received.connect(_on_hit_received)

	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		_die()


func take_damage(amount: float, source: Hitbox = null, packet: DamagePacket = null) -> void:
	if _is_dead:
		return

	var damage_amount: float = maxf(amount, 0.0)
	if is_zero_approx(damage_amount):
		return

	current_health = maxf(current_health - damage_amount, 0.0)
	damaged.emit(damage_amount, source, packet)
	health_changed.emit(current_health, max_health)

	if current_health <= 0.0:
		_die()


func heal(amount: float) -> void:
	if _is_dead:
		return

	var heal_amount: float = maxf(amount, 0.0)
	if is_zero_approx(heal_amount):
		return

	current_health = minf(current_health + heal_amount, max_health)
	health_changed.emit(current_health, max_health)


func reset_health() -> void:
	_is_dead = false
	current_health = max_health
	health_changed.emit(current_health, max_health)


func is_dead() -> bool:
	return _is_dead


func _on_hit_received(source: Hitbox, packet: DamagePacket) -> void:
	if packet == null:
		return

	take_damage(packet.damage, source, packet)


func _die() -> void:
	if _is_dead:
		return

	_is_dead = true
	died.emit()
