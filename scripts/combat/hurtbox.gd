class_name Hurtbox
extends Area2D


signal hit_received(source: Hitbox, damage_packet: DamagePacket)


@export var team: int = 2


func receive_hit(source: Hitbox, packet: DamagePacket) -> void:
	hit_received.emit(source, packet)
