extends Node

@export var pipe: PackedScene;

var score: int = 0;

func _ready() -> void:
	$Player.bird_died.connect(on_bird_died);
	self.start_game();
	
func start_game():
	$ScoreTimer.start();
	
func game_over():
	print_debug("Game over");
	$ScoreTimer.stop();
	
	# Wait a few seconds before stopping the ground
	await get_tree().create_timer(1.5).timeout;
	$Ground.moving = false;
	
	$Hud.show_restart_ui();
	
func on_bird_died():
	game_over();

func _on_score_timer_timeout() -> void:
	self.score += 1;
	$Hud.update_score(self.score);

func _on_hud_restart_clicked() -> void:
	get_tree().reload_current_scene();
