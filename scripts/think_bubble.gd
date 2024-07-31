extends TextureRect

@onready var game = %GameManager
@onready var timer = $Timer
@onready var flash_timer = $FlashTimer
@onready var answer_timer = $AnswerTimer
@onready var start_timer = $StartTimer
@onready var pop = get_tree().get_first_node_in_group("pop")

@onready var potion = $Potion

@export var potions : Array[Texture2D] = []
@onready var num_potions := potions.size()
var pattern_length : int
var pattern_counter := 0

func _ready():
	start_timer.start()

func new_pattern(num : int, wait_time : float):
	game.active = false
	pattern_length = num
	game.pattern_length = num
	for i in num:
		game.current_pattern.append(randi_range(0, num_potions - 1))
	timer.wait_time = wait_time
	show_new_texture()
	timer.start()

func _on_timer_timeout():
	potion.texture = null
	if pattern_counter == pattern_length:
		game.active = true
		pattern_counter = 0
	else:
		flash_timer.start()

func _on_flash_timer_timeout():
	show_new_texture()
	timer.start()

func show_new_texture():
	pop.play()
	potion.texture = potions[game.current_pattern[pattern_counter]]
	pattern_counter += 1

func show_correct():
	modulate = Color8(30, 188, 115)
	answer_timer.start()

func show_incorrect():
	modulate = Color8(232, 59, 59)
	answer_timer.start()

func _on_answer_timer_timeout():
	modulate = Color.WHITE

func _on_start_timer_timeout():
	new_pattern(game.num_potions, game.wait_time)
