## Smooth dialogue typing system.
## To use square brackets, place ~ characters in the spaces before them.
## To ignore a section of characters, place a ` to begin ignoring, and then another ` to stop.

@tool
extends Node

## Example string to test pausing for punctuation.
@export_multiline var example_text: String = "This is an example string. Awesome! Cool, yeah it's pretty cool."
## Base wait time between character prints.
@export var wait_time: float = 0.1
## Overrides to wait longer or shorter between prints.
@export var wait_time_overrides: Dictionary[String, float] = {
	'.': 0.4,
	'?': 0.4,
	'!': 0.4,
	',': 0.2,
}
@export_tool_button("Print Example Text")
var print_example_text = _print_example_text

var continue_print: bool = false
var ignore: bool = false


func _ready() -> void:
	_print_example_text()


func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and continue_print:
		continue_print = false

## Prints text.
func print_text(label: RichTextLabel, text: String, start_chars: int = 0) -> void:
	continue_print = true
	ignore = false
	label.visible_characters = start_chars
	label.text = text
	
	for i in range(text.length()):
		# Player click = skip text write out
		#if not continue_print:
		#	label.visible_ratio = 1.0
		#	break
		
		# Tilde before/after square bracket means that the bracket should not begin an ignore.
		if text[i] == '~':
			if text[i - 1] == ']':
				label.text[i] = " "
			elif text[i + 1] == '[':
				label.text[i] = " "
		
		# Bracket check used to avoid bbcode tags interfering with printing smoothly.
		elif text[i] == ']' and text[i + 1] != '~':
			ignore = false
			continue
		elif text[i] == '[' and text[i - 1] != '~':
			ignore = true
		
		if ignore:
			continue
		
		label.visible_characters += 1
		
		# Instantly print rest of words, player clicked to skip dialogue
		if not continue_print:
			continue
		
		if label.visible_ratio == 1.0:
			break
		
		if text[i] in wait_time_overrides:
			await get_tree().create_timer(wait_time_overrides[text[i]]).timeout
			continue
		else:
			await get_tree().create_timer(wait_time).timeout
			continue
	
	print("Finished printing text")

## Internal method. Used to test printing from the editor using a tool button.
func _print_example_text() -> void:
	print_text($RichTextLabel, example_text)
