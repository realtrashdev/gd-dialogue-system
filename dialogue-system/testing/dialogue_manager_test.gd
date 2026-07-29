@tool
extends Control

@export_multiline var sample_text: String

@export_tool_button("Print Sample Text")
var test_print = _test_print

@onready var text_box: Control = $PanelContainer/MarginContainer/BasicDialogueTextBox

func _ready() -> void:
	_test_print()


func _test_print() -> void:
	DialogueManager.print_text(text_box.get_node("BaseText"), sample_text)
	DialogueManager.print_text(text_box.get_node("TextShadow"), sample_text)
