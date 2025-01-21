extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_zone: Area2D = $HitZone

var direction = 1
var speed: int = 30

func setSpeed(newSpeed: int) -> void:
	speed = newSpeed

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	position.x += direction * speed * delta

func _on_hit_zone_body_entered(_body: Node2D) -> void:
	animation_player.play("die")
