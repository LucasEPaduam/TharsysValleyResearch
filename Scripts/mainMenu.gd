extends Node

func _ready():
	get_node("SoundInit").play()

func _on_Play_pressed():
	
	get_node("SoundInit").stop()
	get_node("SoundButton").play()
	Transition.fade_to("res://Scene/Game.tscn")


func _on_Credits_pressed():
	get_node("SoundInit").stop()
	get_node("SoundButton").play()
	Transition.fade_to("res://Scene/Credits.tscn")
