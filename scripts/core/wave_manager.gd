class_name WaveManager
extends Node


signal wave_started(wave_index: int)
signal wave_cleared(wave_index: int)
signal room_cleared


@export var waves: Array[Resource] = []
@export var spawner_path: NodePath = ^"../EnemySpawner"
@export var enemy_parent_path: NodePath = ^".."
@export var autostart: bool = true
@export var clear_spawned_on_start: bool = true

var _spawner: EnemySpawner
var _enemy_parent: Node
var _alive_enemies: Array[Node] = []
var _spawned_enemies: Array[Node] = []
var _current_wave_index: int = -1
var _is_running: bool = false
var _is_room_cleared: bool = false


func _ready() -> void:
	_spawner = get_node_or_null(spawner_path) as EnemySpawner
	_enemy_parent = get_node_or_null(enemy_parent_path)

	if autostart:
		call_deferred("start")


func start() -> void:
	if _is_running:
		return

	if clear_spawned_on_start:
		clear_spawned_enemies()

	_is_running = true
	_is_room_cleared = false
	_current_wave_index = -1
	_start_next_wave()


func clear_spawned_enemies() -> void:
	for enemy: Node in _spawned_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()

	_spawned_enemies.clear()
	_alive_enemies.clear()


func _start_next_wave() -> void:
	_current_wave_index += 1
	if _current_wave_index >= waves.size():
		_finish_room()
		return

	var wave: WaveData = waves[_current_wave_index] as WaveData
	if wave == null:
		_complete_current_wave()
		return

	wave_started.emit(_current_wave_index)
	_spawn_wave(wave)

	if _alive_enemies.is_empty():
		_complete_current_wave()


func _spawn_wave(wave: WaveData) -> void:
	var spawn_count: int = maxi(wave.count, 0)
	for spawn_index: int in range(spawn_count):
		var spawn_point: Node2D = _get_spawn_point(wave, spawn_index)
		var enemy: Node2D = _spawn_enemy(wave.enemy_scene, spawn_point)
		_track_enemy(enemy)


func _spawn_enemy(enemy_scene: PackedScene, spawn_point: Node2D) -> Node2D:
	if _spawner != null:
		return _spawner.spawn_enemy(enemy_scene, spawn_point, _enemy_parent)

	if enemy_scene == null or _enemy_parent == null:
		return null

	var enemy: Node2D = enemy_scene.instantiate() as Node2D
	if enemy == null:
		return null

	_enemy_parent.add_child(enemy)
	if spawn_point != null:
		enemy.global_position = spawn_point.global_position
	return enemy


func _track_enemy(enemy: Node) -> void:
	if enemy == null:
		return

	_spawned_enemies.append(enemy)
	var enemy_base: EnemyBase = enemy as EnemyBase
	if enemy_base != null:
		_alive_enemies.append(enemy_base)
		enemy_base.died.connect(_on_enemy_died.bind(enemy_base))
		return

	var health: HealthComponent = enemy.get_node_or_null("Health") as HealthComponent
	if health != null:
		_alive_enemies.append(enemy)
		health.died.connect(_on_enemy_died.bind(enemy))


func _get_spawn_point(wave: WaveData, spawn_index: int) -> Node2D:
	if wave.spawn_points.is_empty():
		return null

	var spawn_path: NodePath = wave.spawn_points[spawn_index % wave.spawn_points.size()]
	return get_node_or_null(spawn_path) as Node2D


func _on_enemy_died(enemy: Node) -> void:
	if not _alive_enemies.has(enemy):
		return

	_alive_enemies.erase(enemy)
	if _alive_enemies.is_empty():
		_complete_current_wave()


func _complete_current_wave() -> void:
	wave_cleared.emit(_current_wave_index)
	_start_next_wave()


func _finish_room() -> void:
	if _is_room_cleared:
		return

	_is_room_cleared = true
	_is_running = false
	room_cleared.emit()
