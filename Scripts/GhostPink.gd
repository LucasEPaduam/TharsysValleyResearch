extends "Ghost.gd"

func calc_move_normal():
	var aux = destinoDiscreto - pacman.destinoDiscreto
	if aux.length() >= 5:
		var destino
		for i in range(4, -1, -1):
			destino = pacman.destinoDiscreto + pacman.direcao * i
			if tilemap.get_cell(destino.x, destino.y) != 0 and destino.x >= 0 and destino.x <= 18 and destino.y >= 0 and destino.y <= 20:
				path = tilemap.find_path(destino, destinoDiscreto)
				break 
	else:
		path = tilemap.find_path(pacman.destinoDiscreto, destinoDiscreto)



