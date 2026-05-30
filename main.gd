extends Node

var screen_size := 512
var target_x := 0.0
var speed_transition := 3200
var score := 0
var danger := 0.0
var danger_inc := 3
var game_on = false
var max_danger := 100.0
@onready var game_view = $GameView
var game_over = false

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
	first_start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_view.position.x = move_toward(game_view.position.x, target_x, speed_transition * delta)
	
	if game_over:
		return
	
	if game_on:
		danger += danger_inc * delta
		danger = clamp(danger, 0.0, max_danger)

	
	if danger >= max_danger:
		game_over = true
	
	

func add_to_cauldron(added :String):
	if selected_colors.size() >= MAX_MIX_SIZE:
		print("Cauldron Full!")
		return
	if selected_colors.has(added):
		print("Already added!")
		return
	
	
	selected_colors.append(added)
	
	print(selected_colors)

func _on_right_switch_mouse_entered() -> void:
	target_x = -512
	



func _on_right_switch_mouse_exited() -> void:
	target_x = 0


func _on_left_switch_mouse_entered() -> void:
	target_x = 512


func _on_left_switch_mouse_exited() -> void:
	target_x = 0
	
func clear_mix():
	selected_colors = []
	print("Cleared!")
	
func feed_the_beast():
	game_on = false
	selected_colors.sort()
	combinations[correct_combination].sort()
	target_x = -512
	
	await get_tree().create_timer(2).timeout
	
	if selected_colors == combinations[correct_combination]:
		$GameView/Right/Beast/AnimatedSprite2D.play("attack")
		$GameView/Right/Beast/success.emitting = true
		choose_new()
	else:
		print("Dead!")
	
func check_mix():
	var right_comb = []
	var corrects = 0
	for comb in combinations:
		right_comb = combinations[comb].duplicate()
		right_comb.sort()
		if selected_colors == right_comb:
			corrects += 1
			print(comb)
	if corrects == 1:
		print("Good Mix")
	else:
		print("Bad Mix")
	
	#if correct_combination == selected_colors:
		#print("success")
	#else:
		#print("Dead")

func choose_new():
	var keys = combinations.keys()
	correct_combination = keys.pick_random()
	print(correct_combination)

func _on_slime_click_slime(color: String) -> void:
	add_to_cauldron(color)


func _on_cauldron_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$GameView/Center/Buttons.show()


func _on_mix_button_pressed() -> void:
	check_mix()
	$GameView/Center/Buttons.hide()


func _on_clear_button_pressed() -> void:
	clear_mix()
	$GameView/Center/Buttons.hide()


func _on_feed_button_pressed() -> void:
	feed_the_beast()
	$GameView/Center/Buttons.hide()
	
func first_start():
	target_x = -512
	await get_tree().create_timer(2.0).timeout
	choose_new()
	$GameView/Right/Beast/AnimatedSprite2D.play(correct_combination)
	await get_tree().create_timer(2.0).timeout
	target_x = 0
	$LeftSwitch.show()
	$RightSwitch.show()
