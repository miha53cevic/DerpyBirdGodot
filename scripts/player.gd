extends RigidBody2D

enum STATE { Falling, Flapping, Dead };

signal bird_died;

@export var upward_speed := 25000;
@export var rotation_up_speed := 5000;
@export var rotation_down_speed := 100;
var screen_size: Vector2;
var state: STATE = STATE.Falling;

const MAX_FALLING_ROTATION = PI / 2; # 90 degrees
const MAX_FLAPPING_ROTATION = -PI / 4; # -45 degrees

func _ready() -> void:
	self.screen_size = get_viewport_rect().size;

func _physics_process(delta: float) -> void:
	if self.state == STATE.Dead:
		return;
	
	if Input.is_action_just_pressed("jump"):
		self.state = STATE.Flapping;
		var jump_velocity = -self.upward_speed * delta;
		self.linear_velocity.y = jump_velocity;
		self.angular_velocity = -rotation_up_speed * delta;
	else:
		self.state = STATE.Falling;
		self.angular_velocity = rotation_down_speed * delta;
		
	stop_out_of_screen();
	
	match self.state:
		STATE.Falling:
			if self.rotation >= MAX_FALLING_ROTATION:
				self.angular_velocity = 0;
		STATE.Flapping:
			if self.rotation <= MAX_FLAPPING_ROTATION:
				self.angular_velocity = 0;
		
func stop_out_of_screen():
	if self.position.y <= 0:
		self.linear_velocity.y = 0;

# Must set contactMonitor to On for rigidbody2d
# Also Collision:
# Layer -> the layer I'm in for someone to detect me
# Mask -> the layer I'm scanning to detect someone who is in it
func _on_body_entered(body: Node) -> void:
	if self.state == STATE.Dead:
		return;
	print_debug("Bird collision");
	if body.is_in_group("obstacle"):
		self.state = STATE.Dead;
		self.bird_died.emit();
