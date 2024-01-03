extends Node

func _on_TextureButton_pressed():
	get_node("SoundButtonBack").play()
	Transition.fade_to("res://Scene/mainMenu.tscn")
