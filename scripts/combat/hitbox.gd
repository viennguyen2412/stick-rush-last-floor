class_name Hitbox
extends Area2D


signal hit(target: Hurtbox, damage_packet: DamagePacket)


@export var damage_packet: DamagePacket = null
@export var team: int = 1

var _hit_targets: Array[Hurtbox] = []
var _was_monitoring: bool = false
var _is_hit_consumed: bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_was_monitoring = monitoring


func _physics_process(_delta: float) -> void:
	_update_activation_state()
	if not monitoring:
		return

	_check_current_overlaps()


func _on_area_entered(area: Area2D) -> void:
	_update_activation_state()
	var hurtbox: Hurtbox = area as Hurtbox
	if hurtbox == null:
		return

	_try_hit(hurtbox)


func _update_activation_state() -> void:
	if monitoring and not _was_monitoring:
		_hit_targets.clear()
		_is_hit_consumed = false

	_was_monitoring = monitoring


func _check_current_overlaps() -> void:
	for area: Area2D in get_overlapping_areas():
		var hurtbox: Hurtbox = area as Hurtbox
		if hurtbox == null:
			continue

		_try_hit(hurtbox)
		if _is_hit_consumed:
			return


func _try_hit(hurtbox: Hurtbox) -> void:
	if _is_hit_consumed:
		return

	if _hit_targets.has(hurtbox):
		return

	if team == hurtbox.team:
		return

	_is_hit_consumed = true
	_hit_targets.append(hurtbox)
	hurtbox.receive_hit(self, damage_packet)
	hit.emit(hurtbox, damage_packet)
	_disable_after_hit()


func _disable_after_hit() -> void:
	set_deferred("monitoring", false)
	visible = false

	for child: Node in get_children():
		var collision_shape: CollisionShape2D = child as CollisionShape2D
		if collision_shape != null:
			collision_shape.set_deferred("disabled", true)
