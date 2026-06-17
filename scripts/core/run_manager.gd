class_name RunManager
extends Node


signal run_started
signal room_started(room_index: int, room_count: int)
signal room_cleared(room_index: int)
signal reward_started(room_index: int)
signal reward_completed(room_index: int)
signal run_won


@export var wave_manager_path: NodePath = ^"../WaveManager"
@export var player_path: NodePath = ^"../Player"
@export var player_spawn_path: NodePath = ^"../PlayerSpawn"
@export_range(1, 12, 1) var room_count: int = 5
@export_range(0, 11, 1) var mini_boss_room_index: int = 4
@export var autostart: bool = true
@export var auto_complete_reward: bool = true
@export var reward_delay: float = 0.65

var _wave_manager: WaveManager
var _player: Node2D
var _player_spawn: Node2D
var _current_room_index: int = -1
var _is_run_active: bool = false
var _is_reward_active: bool = false
var _reward_time_left: float = 0.0


func _ready() -> void:
	_wave_manager = get_node_or_null(wave_manager_path) as WaveManager
	_player = get_node_or_null(player_path) as Node2D
	_player_spawn = get_node_or_null(player_spawn_path) as Node2D

	if _wave_manager != null:
		_wave_manager.room_cleared.connect(_on_wave_room_cleared)

	if autostart:
		call_deferred("start_run")


func _process(delta: float) -> void:
	if not _is_reward_active or not auto_complete_reward:
		return

	_reward_time_left -= delta
	if _reward_time_left <= 0.0:
		complete_reward()


func start_run() -> void:
	if _wave_manager == null or _is_run_active:
		return

	_is_run_active = true
	_is_reward_active = false
	_current_room_index = -1
	run_started.emit()
	_start_next_room()


func complete_reward() -> void:
	if not _is_reward_active:
		return

	_is_reward_active = false
	_reward_time_left = 0.0
	reward_completed.emit(_current_room_index)
	_start_next_room()


func _start_next_room() -> void:
	_current_room_index += 1
	if _current_room_index >= room_count:
		_finish_run()
		return

	_move_player_to_room_start()
	room_started.emit(_current_room_index, room_count)
	_wave_manager.start()


func _on_wave_room_cleared() -> void:
	if not _is_run_active:
		return

	room_cleared.emit(_current_room_index)
	if _is_final_room():
		_finish_run()
		return

	_start_reward()


func _start_reward() -> void:
	_is_reward_active = true
	_reward_time_left = maxf(reward_delay, 0.0)
	reward_started.emit(_current_room_index)

	if is_zero_approx(_reward_time_left) and auto_complete_reward:
		complete_reward()


func _finish_run() -> void:
	if not _is_run_active:
		return

	_is_run_active = false
	_is_reward_active = false
	_reward_time_left = 0.0
	run_won.emit()


func _is_final_room() -> bool:
	var final_room_index: int = mini(room_count - 1, mini_boss_room_index)
	return _current_room_index >= final_room_index


func _move_player_to_room_start() -> void:
	if _player == null or _player_spawn == null:
		return

	_player.global_position = _player_spawn.global_position
	var character_body: CharacterBody2D = _player as CharacterBody2D
	if character_body != null:
		character_body.velocity = Vector2.ZERO
