extends Node

var screen_size := 256.0
var target_x := 0.0
var speed_transition := 1800
@onready var game_view = $GameView

var MAX_MIX_SIZE := 3
var selected_colors := []
var combinations = {
	"orange": ["red", "yellow"],
	"purple": ["red", "blue"],
	"pink": ["red", "white"],
	"brown": ["red", "yellow", "blue"],
	"gray": ["white", "black"]
}
var correct_combination


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	correct_combination = combinations["orange"]
	print(correct_combination)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_view.position.x = move_toward(game_view.position.x, target_x, speed_transition * delta)
	
	

func add_to_cauldron(added :String):
	if selected_colors.size() >= MAX_MIX_SIZE:
		print("Cauldron Full!")
		return
	
	selected_colors.push_front(added)
	
	print(selected_colors)

func _on_right_switch_mouse_entered() -> void:
	target_x = -256
	



func _on_right_switch_mouse_exited() -> void:
	target_x = 0


func _on_left_switch_mouse_entered() -> void:
	target_x = 256


func _on_left_switch_mouse_exited() -> void:
	target_x = 0


func _on_slime_click_slime(color: String) -> void:
	add_to_cauldron(color)
