extends CanvasLayer

signal restart_clicked;

func update_score(score: int):
	$Score.text = str(score); 

func show_restart_ui():
	$RestartButton.visible = true;

func _on_restart_button_pressed() -> void:
	$RestartButton.visible = false;
	self.restart_clicked.emit();
