extends AnimatedSprite

onready var tilemap = get_parent().get_node("TileMap")
onready var pacman = get_node("../Pacman")

export var posicaoInicialDiscreta = Vector2()
export var color = ""
export var points = 0

var level = 1

var posicaoDiscreta
var destinoDiscreto
var destinoContinuo

var speed

var state
enum {NORMAL, BLUE, DEAD}

var path

var bluedirecao

func _ready():
	spawn()
	
	set_process(true)
	
	
func spawn():
	posicaoDiscreta = posicaoInicialDiscreta
	destinoDiscreto = posicaoDiscreta
	
	set_position(posicaoDiscreta * 32 + Vector2(16, 16))
	destinoContinuo = get_position()
	if level == 1:
		speed = 100
	elif level == 2:
		speed = 110
	elif level == 3:
		speed = 120
	elif level == 4:
		speed = 140
	elif level == 5:
		speed = 150
	elif level == 6:
		speed = 160
	elif level == 7:
		speed = 170
	elif level > 8:
		speed = 180
	
	
	set_animation(color)
	
	state = NORMAL
	
	path = []
	
	bluedirecao = Vector2(0, -1)
	
	
	
func _process(delta):
	
	if state == DEAD: return 
	if get_node("../../Hud").score < points: return 
	
	
	var deltaContinuo = destinoContinuo - get_position()
	if deltaContinuo != Vector2(0, 0):
		if deltaContinuo.length() < 2:
			set_position(destinoDiscreto * 32 + Vector2(16, 16))
			posicaoDiscreta = destinoDiscreto
			
			calc_move()
		else:
			set_position(get_position() + delta * speed * deltaContinuo.normalized())
			
	else:
		go_to_next() 
	
func calc_move():
	if state == NORMAL:
		calc_move_normal()
	elif state == BLUE:
		calc_move_blue()
			

func go_to_next():
	if path == null or path.size() == 0:
		return 
	destinoDiscreto = path[0]
	destinoContinuo = destinoDiscreto * 32 + Vector2(16, 16)
	
	path.remove(0)
	
func calc_move_blue():
	path = []
	
	var aux = bluedirecao
	
	while(true):
		var calcdestino = destinoDiscreto + aux
		if aux + bluedirecao != Vector2(0, 0) and tilemap.get_cell(calcdestino.x, calcdestino.y) != 0:
			bluedirecao = aux
			path.append(calcdestino)
			return 
		else:
			randomize()
			var rand = int(rand_range(0, 4))
			if rand == 0:
				aux = Vector2(0, 1)
			elif rand == 1:
				aux = Vector2(0, -1)
			elif rand == 2:
				aux = Vector2(1, 0)
			elif rand == 3:
				aux = Vector2(-1, 0)
		
func respawn():
	get_node("SpecialTimer").stop()
	state = DEAD
	
	get_node("Anim").play("Respawn")
	
func _on_Pacman_pac(mode):
	if mode == "die":
		speed = 50
		get_node("SpecialTimer").stop()
		get_node("Anim").play("Hide")
	elif mode == "special":
		if get_node("../../Hud").score < points: return 
		
		if state == BLUE:
			get_node("SpecialTimer").stop()
			get_node("Anim").stop()
			set_modulate(Color(1, 1, 1, 1))
		
		state = BLUE
		speed = 90
		get_node("SpecialTimer").start()
		set_animation("special")
		
		
	elif mode == "move":
		if destinoContinuo - get_position() == Vector2(0, 0):
			calc_move()
	elif mode == "reset":
		get_node("Anim").stop()
		set_modulate(Color(1, 1, 1, 1))
		spawn()
	elif mode == "changeLevel":
		level += 1
		spawn()
	

func _on_SpecialTimer_timeout():
	get_node("Anim").play("GoToNormal")
	yield($Anim, "animation_finished")
	
	state = NORMAL
	speed = 100
	set_color()
	
func set_color():
	set_animation(color)
	
func calc_move_normal():
	var aux = destinoDiscreto - pacman.destinoDiscreto
	if aux.length() >= 5:
		var destino
		for i in range(4, -1, -1):
			destino = pacman.destinoDiscreto + pacman.direcao * i * -1
			if tilemap.get_cell(destino.x, destino.y) != 0 and destino.x >= 0 and destino.x <= 18 and destino.y >= 0 and destino.y <= 20:
				path = tilemap.find_path(destino, destinoDiscreto)
				break 
	else:
		path = tilemap.find_path(pacman.destinoDiscreto, destinoDiscreto)
