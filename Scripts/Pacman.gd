extends AnimatedSprite

onready var tiles = get_parent().get_node("TileMap")

var posicaoDiscreta
var direcao
var destinoDiscreto
var destinoContinuo
var speed

var dead
var vidas = 3
var bolinhasColetadas = 0
var level = 1

signal pac

func _ready():
	spawn()
	
	set_process(true)
	
func spawn():
	posicaoDiscreta = Vector2(9, 15)
	set_position(posicaoDiscreta * 32 + Vector2(16, 16))
	
		
	direcao = Vector2(0, 0)
	destinoDiscreto = posicaoDiscreta
		
	destinoContinuo = get_position()
	if level == 1:
		speed = 150
	elif level == 4:
		speed = 170
	elif level == 4:
		speed = 160
	elif level == 6:
		speed = 180
		
	
	dead = false
	
	get_node("../../SoundGame").play()
	
	#set_scale(Vector2(0.4, 0.4))
	set_flip_h(false)
	set_rotation(0)
	
func _process(delta):
	if dead: return
	var deltaContinuo = destinoContinuo - get_position()
	if deltaContinuo != Vector2(0, 0):
		if deltaContinuo.length() < 2:
			set_position(destinoDiscreto * 32 + Vector2(16, 16))
			posicaoDiscreta = destinoDiscreto
			
			if tiles.get_cell(posicaoDiscreta.x, posicaoDiscreta.y) == 1:
				tiles.set_cell(posicaoDiscreta.x, posicaoDiscreta.y, -1)
				bolinhasColetadas += 1
				get_node("../../Hud").add_score(10)
				get_node("../../SoundPoints").play()
				if bolinhasColetadas == 179:
					tiles.repopular_bolinhas()
					level += 1
					get_node("../../Hud").add_level(level)
					bolinhasColetadas = 0
					spawn()
					emit_signal("pac", "changeLevel")
					
				
			else:
				get_node("../../SoundPoints").stop()
			if tiles.get_cell(posicaoDiscreta.x, posicaoDiscreta.y) == 2:
				tiles.set_cell(posicaoDiscreta.x, posicaoDiscreta.y, -1)
				get_node("../../Hud").add_score(50)
				get_node("../../SoundSpecial").play()
				emit_signal("pac", "special")
			
		else:
			set_position(get_position() + delta * speed * deltaContinuo.normalized())
	else:
		if direcao != Vector2(0, 0):
			var destinoDiscretoAux = posicaoDiscreta + direcao
			if destinoDiscretoAux == Vector2(19, 9):
				destinoDiscretoAux = Vector2(0, 9)
				set_position(Vector2(-1, 9) * 32 + Vector2(16, 16))
			elif destinoDiscretoAux == Vector2(-1, 9):
				destinoDiscretoAux = Vector2(18, 9)
				set_position(Vector2(19, 9) * 32 + Vector2(16, 16))
			if tiles.get_cell(destinoDiscretoAux.x, destinoDiscretoAux.y) != 0 and destinoDiscretoAux != Vector2(9, 8):
				destinoDiscreto = destinoDiscretoAux
				destinoContinuo = get_position() + 32 * direcao
				emit_signal("pac", "move")
	
	direcao = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		direcao = Vector2(-1, 0)
		set_flip_h(false)
		set_rotation(0)
		
	elif Input.is_action_pressed("right"):
		direcao = Vector2(1, 0)
		set_flip_h(true)
		set_rotation(0)
		
	elif Input.is_action_pressed("up"):
		direcao = Vector2(0, -1)
		set_flip_h(true)
		set_rotation(-90)
		
	elif Input.is_action_pressed("down"):
		direcao = Vector2(0, 1)
		set_flip_h(true)
		set_rotation(90)
		
	

func _on_Area_area_entered(area):
	if dead: return 
	if area.get_parent().state == area.get_parent().NORMAL:
		dead = true
		vidas -= 1
		get_node("../../Hud/Label2").set_text(str(vidas) + "UP")
		get_node("../../SoundGame").stop()
		get_node("../../SoundPoints").stop()
		get_node("../../SoundDead").play()
		get_node("Anim").play("Die")
		emit_signal("pac", "die")
		get_node("../../Hud").save_high()
		yield($Anim, "animation_finished")
		if vidas > 0:
			spawn()
			emit_signal("pac", "reset")
		else:
			set_modulate(Color(1, 1, 1, 0))
			Transition.fade_to("res://Scene/GameOver.tscn")
	else:
		area.get_parent().respawn()
		get_node("../../SoundRobotDead").play()
		get_node("../../Hud").add_score(200)
