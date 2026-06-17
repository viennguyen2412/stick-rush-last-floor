class_name RunResultOverlay
extends Control


@export var run_manager_path: NodePath = ^"../../RunManager"
@export var title_label_path: NodePath = ^"CenterContainer/PanelContainer/VBoxContainer/TitleLabel"
@export var subtitle_label_path: NodePath = ^"CenterContainer/PanelContainer/VBoxContainer/SubtitleLabel"
@export var restart_label_path: NodePath = ^"CenterContainer/PanelContainer/VBoxContainer/RestartLabel"

var _run_manager: RunManager
var _title_label: Label
var _subtitle_label: Label
var _restart_label: Label
var _is_showing_result: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_title_label = get_node_or_null(title_label_path) as Label
	_subtitle_label = get_node_or_null(subtitle_label_path) as Label
	_restart_label = get_node_or_null(restart_label_path) as Label
	_run_manager = get_node_or_null(run_manager_path) as RunManager

	if _run_manager != null:
		_run_manager.run_lost.connect(_on_run_lost)
		_run_manager.run_won.connect(_on_run_won)

	hide()


func _unhandled_input(event: InputEvent) -> void:
	if not _is_showing_result:
		return

	if event.is_action_pressed("restart"):
		get_viewport().set_input_as_handled()
		_restart_scene()


func _on_run_lost() -> void:
	_show_result("DEFEATED", "The office won this floor.")


func _on_run_won() -> void:
	_show_result("RUN COMPLETE", "Last floor cleared.")


func _show_result(title: String, subtitle: String) -> void:
	_is_showing_result = true

	if _title_label != null:
		_title_label.text = title
	if _subtitle_label != null:
		_subtitle_label.text = subtitle
	if _restart_label != null:
		_restart_label.text = "RESTART"

	show()
	get_tree().paused = true


func _restart_scene() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
