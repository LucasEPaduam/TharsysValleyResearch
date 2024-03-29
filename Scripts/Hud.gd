extends Control

onready var labScore = get_node("Score")
onready var labHigh = get_node("High")
onready var labLevel = get_node("Level")

var score = 0
var high = 0
var level = 1

var savegame = File.new()
var savepath = "user://savegame.save"
var savedata = {"highscore":0}

func _ready():
	if not savegame.file_exists(savepath):
		save()
		
	read()
	
	high = savedata["highscore"]
	labScore.set_text(str(score))
	labHigh.set_text(str(high))
	labLevel.set_text(str(level))
	
func save():
	savegame.open(savepath, File.WRITE)
	savegame.store_var(savedata)
	savegame.close()
	
func read():
	savegame.open(savepath, File.READ)
	savedata = savegame.get_var()
	savegame.close()
	
func add_level(Gamelevel):
	level = Gamelevel
	labLevel.set_text(str(level))
	
func add_score(add):
	score += add
	labScore.set_text(str(score))
	if score > high:
		high = score
		labHigh.set_text(str(high))
		
func save_high():
	savedata["highscore"] = high
	save()
		
	
	
