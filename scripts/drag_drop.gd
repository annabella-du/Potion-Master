extends TextureRect

@onready var game = %GameManager
@onready var drag = get_tree().get_first_node_in_group("drag")

func _get_drag_data(_at_position):
	if game.active:
		drag.play()
		var preview_texture = TextureRect.new()
		preview_texture.texture = texture
		preview_texture.expand_mode = 1
		preview_texture.size = Vector2(game.preview_size, game.preview_size)
		preview_texture.position = Vector2(-game.preview_size/2, -game.preview_size/2)
		
		var preview = Control.new()
		preview.add_child(preview_texture)
		
		set_drag_preview(preview)
		return texture
	else:
		return null

func _can_drop_data(_at_position, data):
	return game.active and data is Texture2D
