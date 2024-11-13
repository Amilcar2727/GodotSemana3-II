extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#Vamos a obtener las 3 animacione definidas
	var mob_types : Array = $AnimatedSprite2D.sprite_frames.get_animation_names();
	#Ahora mediante el siguiente codigo obtenemos un numero aleatorio usando la longitud del arreglo po
	# [fly, swim, walk]
	#   0    1     2
	var random = randi() % mob_types.size(); # Escoge entre 0 a 2
	$AnimatedSprite2D.play(mob_types[random]); #Con esto llamamos a que se inicie la animacion, pasando como parametro a la animacion que deseamos que se vea, aleatoriamente.
	

# Esta señal ejecuta este metodo que pos funciona cuando el objeto en cuestion, o nodo, sale de la pantalla visible (480x720)
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free(); #Metodo para eliminarse el enemigo cuando sale de la pantalla
