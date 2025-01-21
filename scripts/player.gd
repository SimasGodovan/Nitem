extends CharacterBody2D

signal die

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var die_sound: AudioStreamPlayer2D = $DieSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var jump_count = 0
var max_jumps = 2
var is_dead = false

func _ready():
	die.connect(performDeath)
	
func performDeath() -> void:
	if is_dead:
		return
	
	is_dead = true
	animation_player.play("die")

func performJump(velocity: Vector2) -> Vector2:
	jump.play() 
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	return velocity

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
			velocity = performJump(velocity)
	
	if is_on_floor():
		jump_count = 0
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity = performJump(velocity)

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
