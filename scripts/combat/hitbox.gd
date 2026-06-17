class_name Hitbox
extends Area2D


signal hit(target: Hurtbox, damage_packet: DamagePacket)


@export var damage_packet: DamagePacket = null
@export var team: int = 1
@export var clear_targets_when_no_overlaps: bool = false

var _hit_targets: Array[Hurtbox] = []
var _was_monitoring: bool = false


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

	_was_monitoring = monitoring


func _check_current_overlaps() -> void:
	var has_hurtbox_overlap: bool = false
	for area: Area2D in get_overlapping_areas():
		var hurtbox: Hurtbox = area as Hurtbox
		if hurtbox == null:
			continue

		has_hurtbox_overlap = true
		_try_hit(hurtbox)

	if clear_targets_when_no_overlaps and not has_hurtbox_overlap:
		_hit_targets.clear()


func _try_hit(hurtbox: Hurtbox) -> void:
	if _hit_targets.has(hurtbox):
		return

	if damage_packet == null:
		return

	if _get_attack_team(damage_packet) == hurtbox.team:
		return

	_hit_targets.append(hurtbox)
	hurtbox.receive_hit(self, damage_packet)
	hit.emit(hurtbox, damage_packet)


func _get_attack_team(packet: DamagePacket) -> int:
	if packet.team != 0:
		return packet.team

	return team
