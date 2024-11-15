extends Node

#VARIABLE ESCENAS
@export var mob_scene : PackedScene;

var score;

func _ready():
	#new_game();
	pass;
# FUNCIONAR CUANDO NOS COLISIONE ENEMIGO
func game_over():
	$ScoreTimer.stop(); # DETENER LA PUNTUACION
	$MobTimer.stop(); # DETENEMOS EL SPAWN DE ENEMIGO

func new_game():
	score = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();

func _on_start_timer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();

func _on_score_timer_timeout():
	score += 1;
	
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
	mob.rotation = direction;
	#                        ======= x =========== , == y ==
	var velocity = Vector2(randf_range(150.0, 250.0),0);
	mob.linear_velocity = velocity.rotated(direction);
	add_child(mob);
