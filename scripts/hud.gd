extends CanvasLayer

signal restart_clicked;
signal start_clicked;

func update_score(score: int):
	$Score.text = str(score); 

func show_restart_ui(highscore: int):
	$RestartButton.visible = true;
	$Highscore.visible = true;
	$Highscore.text = "Highscore: " + str(highscore);

func _on_restart_button_pressed() -> void:
	$RestartButton.visible = false;
	self.restart_clicked.emit();

func _on_start_pressed() -> void:
	$Start.visible = false;
	self.start_clicked.emit();
