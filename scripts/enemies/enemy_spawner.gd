class_name EnemySpawner
extends Node2D


@export var default_parent_path: NodePath = ^".."

var _default_parent: Node


func _ready() -> void:
	_default_parent = get_node_or_null(default_parent_path)


func spawn_enemy(enemy_scene: PackedScene, spawn_point: Node2D, parent: Node = null) -> Node2D:
	var spawn_position: Vector2 = global_position
	if spawn_point != null:
		spawn_position = spawn_point.global_position

	return spawn_enemy_at(enemy_scene, spawn_position, parent)


func spawn_enemy_at(enemy_scene: PackedScene, spawn_position: Vector2, parent: Node = null) -> Node2D:
	if enemy_scene == null:
		return null

	var enemy: Node2D = enemy_scene.instantiate() as Node2D
	if enemy == null:
		return null

	var spawn_parent: Node = parent
	if spawn_parent == null:
		spawn_parent = _default_parent
	if spawn_parent == null:
		spawn_parent = get_parent()
	if spawn_parent == null:
		return null

	spawn_parent.add_child(enemy)
	enemy.global_position = spawn_position
	return enemy
