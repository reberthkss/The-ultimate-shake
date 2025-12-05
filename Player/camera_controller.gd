extends Camera2D

# Esta variável vai guardar a posição Y mais alta que a câmera já alcançou.
# Começamos com um valor muito baixo para garantir que a primeira posição do jogador seja sempre maior.
var max_y_position = 10000.0

func _process(delta):
	# A cada frame, verificamos a posição Y atual da câmera.
	# A posição da câmera é a mesma do jogador, pois ela é um nó filho.
	var current_y = global_position.y
	
	## Comparamos a posição Y atual com a mais alta que já registramos.
	#if current_y < max_y_position:
		## Se a posição atual for mais alta (lembre-se que no Godot, valores Y menores são mais altos na tela),
		## nós atualizamos nossa variável de altura máxima.
		#max_y_position = current_y
	#else:
		## Se a posição atual for mais baixa que a altura máxima,
		## nós FORÇAMOS a câmera a ficar na altura máxima que ela já alcançou.
		## Isso impede que a câmera desça.
		#global_position.y = max_y_position
