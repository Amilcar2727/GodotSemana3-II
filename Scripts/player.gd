extends Area2D

#Definimos Variables
@export var speed : int = 400; #Pixel/segundos
var screen_size;	 #~Que almacenara la resolucion 480x720
signal hit; #Que servira para enviar una señal en un futuro cuando el enemigo nos impacte
func _ready():
	# Almacenamos dentro de la variable el 480x720
	screen_size = get_viewport_rect().size;
	# Ocultaremos al jugador al iniciar el juego, comentado por ahora
	#hide()


func _process(delta):
	# Ahora hacemos el mapeo de las teclas
	# Una vez bindeadas las teclas empezamos con la logica
	var velocity : Vector2 = Vector2.ZERO; #Definimos una variable local llamada velocity que pos dara movimiento a nuestro jugador
	# Logica de teclas
	if Input.is_action_pressed("move_right"):
		velocity.x += 1; # Si presionamos la tecla ->, nos movemos en el eje x, por ende aumentamos 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1; # Si presionamos <- nos vamos izq
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1; # Si presionamos "Arriba" disminuimos en el eje Y (Mirar video subido en el material)
	if Input.is_action_pressed("move_down"):
		velocity.y += 1; # Si presionamos "abajo" Aumentamos eje Y
	
	# ================ Movimiento por velocidad
	if velocity.length() > 0: #Si la longitud (Resultante) del vector velocidad es mayor a 0, nos movemos :0
		velocity = velocity.normalized() * speed;
		# - Normalizamos (Video Youtube) y le aplicamos la velocidad de 400 designada
		#print(velocity) -> (400,-400) por ejm
		#Empezamos animacion de movimiento, porque nos movemos xd
		$AnimatedSprite2D.play();
	else:
		#Si no nos movemos, pos no hay animacion
		$AnimatedSprite2D.stop();
		
	# ============== Agregando este vector velocity a la posicion del nodo Jugador (Osea darle el movimiento y ya)
	position += velocity * delta;
	#Posicion del nodo le aumentamos el (400,-400) por delta para evitar problemas de framerate
	position = position.clamp(Vector2.ZERO, screen_size);
	# Lo que hemos hecho es restringir la posicion del nodo Jugador usando el metodo clamp para que solo se mueva dentro de la ventana (480x720), definida por screen_size
	"""ANIMACIONES"""
	if velocity.x != 0: #Si hay movimiento en X, mov en <->
		$AnimatedSprite2D.animation = "walk"; #Escogemos la animacion walk
		$AnimatedSprite2D.flip_v = false; #Como nos movemos en el eje x, no necesitamos flip de "cabeza"
		$AnimatedSprite2D.flip_h = velocity.x < 0; #Si nos movemos a la izquierda, flip_h = true, caso contrario, false
	elif velocity.y != 0: #Si hay movimiento en Y, nos movemos para arriba o abajo
		$AnimatedSprite2D.animation = "up"; #Escogemos animacion
		$AnimatedSprite2D.flip_v = velocity.y > 0; #Si nos movemos para ABAJO, flip verdadero (Por el eje Y invertido)

# Cuando un cuerpo nos impacte
func _on_body_entered(body):
	hide(); #Ocultamos al nodo jugador
	hit.emit(); #Emitimos una señal adicional q usaremos despues
	$CollisionShape2D.set_deferred("disabled",true);
	#Simplemente estamos llamando a la propiedad disabled, para que lo ponga en true, el deferred hace que godot decida cuando es mejor desactivarlo
	#$CollisionShape2D.disabled = true; #Lo mismo de arriba pero pues sin que godot decida cuando es seguro desactivarlo
	
#Metodo Adicional para llamar a un nuevo juego
func start(pos):
	#Asignamos la posicion del nodo a la posicion dada (pos)
	position = pos;
	show(); #Mostramos al jugador, si es q lo hemos ocultado
	$CollisionShape2D.disabled = false; #Enabled, activamos el collision shape para empezar una nueva ronda, porque la desactivamos
