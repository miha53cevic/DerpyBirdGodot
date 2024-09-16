extends Node2D

@export var speed := 100.0;
@export var pipe_hole_height := 160;
@export var pipe_min_height := 64;
@export var offscreen_spawn_offset := 32;
@export var ground_height := 128;
var screen_size: Vector2;
var pipe_size: Vector2;
var moving = true;
var player_passed = false;

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
	var max_top_height := mini(pipe_size.y / 2, screen_size.y - self.ground_height - self.pipe_hole_height - self.pipe_min_height - pipe_size.y / 2);
	
	var top_pipe_height := randi_range(self.pipe_min_height - pipe_size.y / 2, max_top_height);
	var top_pipe_bottom := top_pipe_height + pipe_size.y / 2;
	var bottom_pipe_height := top_pipe_bottom + self.pipe_hole_height + pipe_size.y / 2;
	
	up_pipe.position.y = bottom_pipe_height;
	down_pipe.position.y = top_pipe_height;
	
func is_player_in_pipe(player_pos: Vector2) -> bool:
	var pipe_top_left = self.position - self.pipe_size / 2;
	var full_pipe_size = Vector2(pipe_size.x, screen_size.y);
	var pipe_rect = Rect2i(pipe_top_left, full_pipe_size);
	
	if pipe_rect.has_point(player_pos) and not player_passed:
		player_passed = true;
		return true;
	else:
		return false;
