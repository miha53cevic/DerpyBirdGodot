extends Node

@export var pipe: PackedScene;
@export var max_pipes_on_screen := 2;

var score: int = 0;

func _ready() -> void:
	$Player.bird_died.connect(on_bird_died);
	self.start_game();
	
func start_game():
	$PipeSpawnTimer.start();
	
func game_over():
	print_debug("Game over");
	$PipeSpawnTimer.stop();
	
	# Wait a few seconds before stopping the ground
	await get_tree().create_timer(1.5).timeout;
	$Ground.moving = false;
	self.get_tree().call_group("pipes", "stop_moving");
	
	$Hud.show_restart_ui();
	
func spawn_pipe():
	var pipeScene := self.pipe.instantiate();
	self.add_child(pipeScene);
	
func on_bird_died():
	game_over();

func _on_pipe_spawn_timer_timeout() -> void:
	var pipeCount = get_tree().get_nodes_in_group("pipes").size();
	if pipeCount < self.max_pipes_on_screen:
		self.spawn_pipe();

func _on_hud_restart_clicked() -> void:
	get_tree().reload_current_scene();
