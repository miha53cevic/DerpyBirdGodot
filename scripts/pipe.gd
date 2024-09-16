extends Node2D

@export var speed := 100.0;
@export var pipe_hole_height := 160;
@export var pipe_min_height := 64;
@export var offscreen_spawn_offset := 32;
@export var ground_size := 64;
var screen_size: Vector2;
var pipe_size: Vector2;
var moving = true;

func _ready() -> void:
	self.screen_size = get_viewport_rect().size;
	self.pipe_size = $Up/CollisionShape2D.shape.get_rect().size;
	self.setup_pipe();
	
func _process(delta: float) -> void:
	if self.moving:
		move_pipe(delta);
	destroy_on_screen_exit();
	
func move_pipe(delta: float):
	self.position.x -= delta * self.speed;
	
func stop_moving():
	self.moving = false;
	
func destroy_on_screen_exit():
	var pipe_right_edge = self.position.x + self.pipe_size.x / 2;
	if pipe_right_edge <= 0:
		self.queue_free();
		
func setup_pipe():
	# starting position is offscreen
	self.position.x = screen_size.x + pipe_size.x / 2 + offscreen_spawn_offset;
	
	var up_pipe := $Up;
	var down_pipe := $Down;
	var max_top_height := pipe_size.y / 2;
	
	var top_pipe_height := randi_range(self.pipe_min_height, max_top_height);
	var top_pipe_bottom := top_pipe_height + pipe_size.y / 2;
	var bottom_pipe_height := top_pipe_bottom + self.pipe_hole_height + pipe_size.y / 2;
	
	up_pipe.position.y = bottom_pipe_height;
	down_pipe.position.y = top_pipe_height;
