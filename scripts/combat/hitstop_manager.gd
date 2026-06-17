class_name HitstopManager
extends Node


const HITSTOP_MANAGERS_GROUP: StringName = &"hitstop_managers"


@export var hitstop_time_scale: float = 0.08

var _end_time_msec: int = 0
var _is_active: bool = false


func _ready() -> void:
	add_to_group(HITSTOP_MANAGERS_GROUP)


func _process(_delta: float) -> void:
	if not _is_active:
		return

	if Time.get_ticks_msec() < _end_time_msec:
		return

	_finish_hitstop()


func _exit_tree() -> void:
	if _is_active:
		_finish_hitstop()


func request_hitstop(duration: float) -> void:
	if duration <= 0.0:
		return

	var duration_msec: int = int(roundf(duration * 1000.0))
	_end_time_msec = maxi(_end_time_msec, Time.get_ticks_msec() + duration_msec)

	if _is_active:
		return

	_is_active = true
	Engine.time_scale = clampf(hitstop_time_scale, 0.01, 1.0)


func _finish_hitstop() -> void:
	_is_active = false
	_end_time_msec = 0
	Engine.time_scale = 1.0
