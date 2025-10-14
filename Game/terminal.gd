extends TextEdit
class_name TerminalWindow

@onready var timer: Timer = $Timer
var is_open: bool = false

var program_list: Dictionary[StringName,Callable] = {
	"print": test_print
}

func open_terminal() -> void:
	if is_open: return
	show()
	grab_focus()
	timer.stop()
	modulate.a = 1


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_T):
		open_terminal()

	if Input.is_key_pressed(KEY_SLASH):
		open_terminal()
		var newline_index: int = get_last_full_visible_line()
		set_line(newline_index, "")
	
	if Input.is_key_pressed(KEY_ENTER):
		var last_visible_line_text: String = get_line(get_last_full_visible_line())
		
		if last_visible_line_text != "":
			var command_data: Array = get_data_from_command(last_visible_line_text)
			var command_args: Array = []
			for arg in command_data:
				if arg != command_data[0]:	command_args.append(arg)
			program_list.get(command_data[0]).callv(command_args)
		timer.start()
		#var newline_index: int = get_last_full_visible_line()
		
		#insert_line_at(newline_index, "")

func test_print(printable_text: String = "HI from terminal"):
	print(printable_text)

func get_data_from_command(command: String) -> Array:
	if command[0] != '/': printerr(["no / command", "invalid command error"]); return []
	var data_array: Array = []
	var recorded_data: StringName = ""
	
	for c in command:
		if c == command[-1]:
			recorded_data += c;
			data_array.append(recorded_data)
			recorded_data = "";
			break;
		
		if c == " ": 
			data_array.append(recorded_data)
			recorded_data = "";
			continue;
		
		if c == "/": continue;
		
		recorded_data += c;
	
	return data_array
	
func _process(_delta: float) -> void:
	if not timer.is_stopped():
		modulate.a = timer.time_left / timer.wait_time




func _on_timer_timeout() -> void:
	hide()
	modulate.a = 1
