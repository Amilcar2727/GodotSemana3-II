extends CanvasLayer
# Declaramos la variable que iniciará 
# el juego al presionar el boton start.
signal start_game;

func show_message(text):
	#Asignamos a la propiedad text del nodo Message el parámetro
	$Message.text = text;
	#Mostramos el nodo en caso esté oculto
	$Message.show();
	#Iniciamos el timer (2s)
	$MessageTimer.start();
func update_score(score):
	#Asignamos a la propiedad text del nodo ScoreLabel el parametro
	#convertido en string (str)
	$ScoreLabel.text = str(score);

func show_game_over():
	#Si perdemos, cambiamos el nodo Mensaje
	show_message("Game Over");
	#Esperamos a que se envie la señal timeout del nodo MessageTimer
	#Inicializado en el metodo show_message(text) 2s.
	await $MessageTimer.timeout;
	#Cambiamos el mensaje del nodo Message
	$Message.text = "Dodge the Creeps!";
	#Mostramos en caso este oculto
	$Message.show();
	#Creamos un timer adicional de 1 segundo, y esperaremos que envie su
	#señal timeout. 
	await get_tree().create_timer(1.0).timeout;
	#Mostramos el boton caso este oculto
	$StartButton.show();

# Cuando se presione el boton
func _on_start_button_pressed():
	# Lo ocultamos
	$StartButton.hide();
	# Emitimos la señal start_game
	start_game.emit();

func _on_message_timer_timeout():
	# Despues de 2 segundos, ocultamos el nodo Message
	$Message.hide();
