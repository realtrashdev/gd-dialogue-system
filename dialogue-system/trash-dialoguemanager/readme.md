(Open this file in Godot's script editor!)

Hi!

Assign dialogue_manager.tscn as a global scene to be able to use DialogueManager correctly.

DialogueManager supports most basic BBCode effects.
Images are an exception to this.

Due to often needing to ignore characters inside square brackets, you must place ~ characters outside of square brackets if you want them to print.
Example: "I'm correctly formatting my ~[square brackets]~ to be printed with DialogueManager!"
The ~ characters will be replaced by blank spaces.

DialogueManager.print_text() can be called from anywhere, passing in a RichTextLabel and a String, and will print the text in the RichTextLabel with:
- The classic typewriter text effect
- Longer pauses between characters (editable)

You can create input actions for instantly printing the current text and speeding up printing.
- Recommended names are already in the script, under the Input Actions group of the DialogueManager.
- If these action names aren't found in the InputMap, they will be disabled automatically.
