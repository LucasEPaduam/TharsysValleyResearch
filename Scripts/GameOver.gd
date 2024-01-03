extends Node

func _on_TextureButton_pressed():
	get_node("SoundButton").play()
	Transition.fade_to("res://Scene/Game.tscn")


func _on_TextureButton2_pressed():
	get_tree().quit()
