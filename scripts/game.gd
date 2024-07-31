extends Node2D

@onready var score_label = get_tree().get_first_node_in_group("score")
@onready var answer_box = get_tree().get_first_node_in_group("answer_box")
@onready var think_bubble = get_tree().get_first_node_in_group("think_bubble")
@onready var timer = %Timer

@onready var heart_background = %HeartBackground
@onready var heart1 = %Heart1
@onready var heart2 = %Heart2
@onready var heart3 = %Heart3
@onready var game_over = %GameOver


var preview_size = 80

var active := false

var potion_index = ["blue", "green", "pink", "purple", "yellow"]
var current_pattern = []
var pattern_length := 10000

var num_correct := 0
var score := 0

var num_potions := 3
var wait_time := 1.0

var lives = 3

func _ready():
	answer_box.connect("add_score", _on_add_score)
	answer_box.connect("incorrect", _on_incorrect)
	
	heart_background.visible = true
	heart1.visible = false
	heart2.visible = false
	heart3.visible = true
	
	game_over.visible = false

func _physics_process(_delta):
	score_label.text = "%02d" % [score]

func _on_add_score():
	score += 1
	if score % 5 == 0:
		num_potions += 1
		wait_time = 1.0
	elif score % 5 == 1:
		wait_time = 0.9
	elif score % 5 == 2:
		wait_time = 0.8
	elif score % 5 == 3:
		wait_time = 0.7
	elif score % 5 == 4:
		wait_time = 0.6
	
	timer.start()

func _on_timer_timeout():
	think_bubble.new_pattern(num_potions, wait_time)

func _on_incorrect():
	lives -= 1
	match lives:
		2:
			heart1.visible = false
			heart2.visible = true
			heart3.visible = false
			timer.start()
		1:
			heart1.visible = true
			heart2.visible = false
			heart3.visible = false
			timer.start()
		0:
			heart1.visible = false
			heart2.visible = false
			heart3.visible = false
			active = false
			game_over.visible = true
