extends Node

#VARIABLE ESCENAS
@export var mob_scene : PackedScene;

var score;

# FUNCIONA CUANDO NOS COLISIONE ENEMIGO
func game_over():
	$ScoreTimer.stop(); # DETENER LA PUNTUACION
	$MobTimer.stop(); # DETENEMOS EL SPAWN DE ENEMIGO
	$HUD.show_game_over(); #MOSTRAR GAME OVER
	$Music.stop(); 
	$DeathSound.play();

func new_game():
	# Llamamos al grupo del arbol de nodos, y los hacemos eliminar
	get_tree().call_group("mobs","queue_free");
	# Inicializamos la puntuación
	score = 0;
	# La mostramos haciendo uso del HUD
	$HUD.update_score(score);
	# Mostramos el mensaje de preparación con el HUD
	$HUD.show_message("Get Ready!");
	# Hacemos aparecer al jugador en una posicion dada
	$Player.start($StartPosition.position);
	# Inicializamos el timer que empieza el juego.
	$StartTimer.start();
	# Inicializamos la musica de fondo.
	$Music.play();

func _on_start_timer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();

# Se ejecuta cada 1 Segundo
func _on_score_timer_timeout():
	# Aumenta la puntuacion c/segundo
	score += 1;
	# Lo muestra en pantalla con el HUD
	$HUD.update_score(score);
	
func _on_mob_timer_timeout(): #0.5 segundos
	#Mob -> Clase, Instanciarlo -> Nuevo objeto; (COPIA)
	var mob = mob_scene.instantiate();
	
	var mob_spawn_location = $MobPath/MobSpawnLocation;
	mob_spawn_location.progress_ratio = randf();

	# PARA QUE APUNTE AL CENTRO DE LA PANTALLA	
	var direction = mob_spawn_location.rotation + PI/2; #90º
	
	# ASIGNAR LA POSICION ALEATORIA
	mob.position = mob_spawn_location.position;
	
	# DANDO LA DIRECCION A NUESTRO ENEMIGO PARA QUE APUNTE PANTALLA
	direction += randf_range(-PI / 4, PI / 4);
	mob.rotation = direction;
	#                        ======= x =========== , == y ==
	var velocity = Vector2(randf_range(150.0, 250.0),0);
	mob.linear_velocity = velocity.rotated(direction);
	add_child(mob);
