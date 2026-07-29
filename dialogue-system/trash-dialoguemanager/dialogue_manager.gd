## Smooth dialogue typing system.
##
## To use square brackets, place ~ characters in the spaces before them. The ~ characters will be deleted.

@tool
class_name DialogueManager extends Node

@export_group("Timing")
## Base wait time between character prints.
@export var wait_time: float = 0.04
## Multiplier for if the player is making the text go fast.
@export var fast_wait_time_mult: float = 3.0
## Overrides to wait longer or shorter between prints.
@export var wait_time_overrides: Dictionary[String, float] = {
	'.': 0.4,
	'?': 0.4,
	'!': 0.4,
	',': 0.2,
}

@export_group("Input Actions")
## Input action that causes the text being printed to instantly skip to the end.
@export var skip_print_action: String = "dialogue_skip_print"
## Input action that causes the text being printed to speed up.
@export var fast_print_action: String = "dialogue_fast_print"

var continue_print: bool = false
var print_fast: bool = false
var ignore: bool = false


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and continue_print:
			continue_print = false
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			print_fast = true
		elif print_fast:
			print_fast = false
		return
	_check_player_input()

## Prints text on a specified RichTextLabel.
func print_text(label: RichTextLabel, base_text: String, start_chars: int = 0) -> void:
	var sub: int = 0 # incremented when text is removed from the label but not the original string, use when accessing text[i].
	
	continue_print = true
	ignore = false
	label.visible_characters = start_chars
	
	var text = base_text
	label.text = text
	
	for i in range(text.length()):
		# Tilde before/after square bracket means that the bracket should not begin an ignore.
		if text[i] == '~':
			if text[i - 1] == ']':
				label.text[i - sub] = ""
				label.visible_characters -= 1
				sub += 1
			elif text[i + 1] == '[':
				label.text[i - sub] = ""
				label.visible_characters -= 1
				sub += 1
		
		# Bracket check used to avoid bbcode tags interfering with printing smoothly.
		elif text[i] == ']' and text[i + 1] != '~':
			ignore = false
			continue
		elif text[i] == '[' and text[i - 1] != '~':
			ignore = true
		elif text[i] == '[' and i == 0:
			ignore = true
		
		# Ignore character, skip to next one.
		if ignore:
			continue
		
		label.visible_characters += 1
		
		# Instantly print rest of words, player clicked to skip dialogue.
		if not continue_print:
			continue
		
		if label.visible_ratio == 1.0:
			break
		
		# Wait for a period of time before next character is revealed for typewriter effect.
		var time: float
		if text[i] in wait_time_overrides:
			time = wait_time_overrides[text[i]] / fast_wait_time_mult if print_fast else wait_time_overrides[text[i]]
			await get_tree().create_timer(time).timeout
			continue
		else:
			time = wait_time / fast_wait_time_mult if print_fast else wait_time
			await get_tree().create_timer(time).timeout
			continue

## Check for player inputs regarding dialogue actions.
func _check_player_input():
	if InputMap.has_action(skip_print_action) and Input.is_action_just_pressed(skip_print_action) and continue_print:
		continue_print = false
	if InputMap.has_action(fast_print_action) and Input.is_action_pressed(fast_print_action):
		print_fast = true
	elif print_fast:
		print_fast = false
