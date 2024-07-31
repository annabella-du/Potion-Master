extends Node2D

@onready var main_menu = %MainMenu
@onready var instructions = %Instructions
@onready var credits = %Credits

func _ready():
	main_menu.visible = true
	instructions.visible = false
	credits.visible = false

func _on_texture_button_pressed():
	main_menu.visible = false
	instructions.visible = true

func _input(event):
	if instructions.visible and event.is_action_pressed("continue"):
		instructions.visible = false
		credits.visible = true
	elif credits.visible and event.is_action_pressed("continue"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
