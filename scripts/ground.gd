extends StaticBody2D

@export var speed := 100.0;
var screen_size: Vector2;
var ground_size: Vector2;
var moving := true;

func _ready() -> void:
	self.screen_size = get_viewport_rect().size;
	self.ground_size = $CollisionShape2D.shape.get_rect().size;

func _process(delta: float) -> void:
	if moving:
		move_ground(delta);

func move_ground(delta: float):
	self.position.x -= delta * speed;
	var ground_end_position = self.position.x + self.ground_size.x / 2;
	if ground_end_position <= screen_size.x:
		reset_ground();
	
func reset_ground():
	self.position.x = ground_size.x / 2;
