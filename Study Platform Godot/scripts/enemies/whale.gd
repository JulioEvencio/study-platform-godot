extends CharacterBody2D

@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var hp : int = 10
var immunity : bool = false
var damage : int = 1

func _ready() -> void:
	animation_player.play("idle")

func _physics_process(delta : float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	
	if hp <= 0:
		queue_free()

func take_damage(damage : int) -> void:
	if not immunity:
		hp -= damage
		immunity = true
		animation_player.play("hit")

func _on_area_2d_body_entered(body : CharacterBody2D) -> void:
	body.take_damage(damage)
