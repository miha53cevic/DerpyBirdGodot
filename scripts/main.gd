extends Node

@export var pipe: PackedScene;
@export var max_pipes_on_screen := 2;

var score: int = 0;

func _ready() -> void:
	$Player.bird_died.connect(on_bird_died);
	$Player.process_mode = Node.PROCESS_MODE_DISABLED;
	
func _physics_process(delta: float) -> void:
	var pipes = get_tree().get_nodes_in_group("pipes");
	for pipe in pipes:
		if pipe.is_player_in_pipe($Player.position):
			self.increase_score();
			$ScoreUpSound.play();

func get_highscore() -> int:
	var config := ConfigFile.new();
	var err = config.load("user://scores.cfg");
	
	if err != Error.OK:
		return 0;
	
	var highscore = config.get_value("highscore", "value");
	return int(highscore);
	
func set_highscore(highscore: int):
	var config := ConfigFile.new();
	config.set_value("highscore", "value", highscore);
	config.save("user://scores.cfg");

func start_game():
	$PipeSpawnTimer.start();
	$Player.process_mode = Node.PROCESS_MODE_INHERIT;
	
func game_over():
	print_debug("Game over");
	$PipeSpawnTimer.stop();
	
	# Wait a few seconds before stopping the ground
	await get_tree().create_timer(1.5).timeout;
	$Ground.moving = false;
	self.get_tree().call_group("pipes", "stop_moving");
	
	var highscore := self.get_highscore() if self.get_highscore() > self.score else self.score;
	self.set_highscore(highscore);
	$Hud.show_restart_ui(highscore);
	
func spawn_pipe():
	var pipeScene := self.pipe.instantiate();
	self.add_child(pipeScene);
	
func increase_score():
	self.score += 1;
	$Hud.update_score(self.score);
	
func on_bird_died():
	game_over();

func _on_pipe_spawn_timer_timeout() -> void:
	var pipeCount = get_tree().get_nodes_in_group("pipes").size();
	if pipeCount < self.max_pipes_on_screen:
		self.spawn_pipe();

func _on_hud_restart_clicked() -> void:
	get_tree().reload_current_scene();

func _on_hud_start_clicked() -> void:
	self.start_game();
