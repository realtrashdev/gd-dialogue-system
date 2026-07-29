extends Control

@onready var text_box: Control = $PanelContainer/MarginContainer/BasicDialogueTextBox

func _ready() -> void:
	if is_global():
		pass


func is_global():
	for classes in ProjectSettings.get_global_class_list():
		if classes["class"] == "DialogueManager":
			return true
	return false
