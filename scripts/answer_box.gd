extends TextureRect

@onready var game = %GameManager
@onready var think_bubble = get_tree().get_first_node_in_group("think_bubble")
@onready var timer = $Timer
@onready var cor = get_tree().get_first_node_in_group("correct")
@onready var incor = get_tree().get_first_node_in_group("incorrect")

signal add_score
signal incorrect

func _get_drag_data(_at_position):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(game.preview_size, game.preview_size)
	preview_texture.position = Vector2(-game.preview_size/2, -game.preview_size/2)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	texture = null
	
	return preview_texture.texture

func _can_drop_data(_at_position, data):
	return data is Texture2D

func _drop_data(_at_position, data):
	texture = data
	var texture_name = data.get_path().get_file()
	if game.current_pattern.size() == 0:
		return
	elif texture_name == "blue.png" and game.current_pattern[0] == 0:
		correct()
	elif texture_name == "green.png" and game.current_pattern[0] == 1:
		correct()
	elif texture_name == "pink.png" and game.current_pattern[0] == 2:
		correct()
	elif texture_name == "purple.png" and game.current_pattern[0] == 3:
		correct()
	elif texture_name == "yellow.png" and game.current_pattern[0] == 4:
		correct()
	else:
		think_bubble.show_incorrect()
		incor.play()
		game.current_pattern.clear()
		game.num_correct = 0
		game.pattern_length = 10000
		texture = null
		emit_signal("incorrect")
	
	if game.num_correct == game.pattern_length:
		game.num_correct = 0
		game.pattern_length = 10000
		cor.play()
		emit_signal("add_score")

func correct():
	think_bubble.show_correct()
	game.current_pattern.pop_front()
	game.num_correct += 1
	game.active = false
	timer.start()

func _on_timer_timeout():
	texture = null
	game.active = true
