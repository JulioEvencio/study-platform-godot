extends CharacterBody2D

@export var cure_potion : PackedScene

@export var level : Level

@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
@export var ray_cast : RayCast2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var hp : int = 10
var immunity : bool = false
var damage : int = 1

var update_move : bool = true
var vel : int = 20

func _ready() -> void:
	animation_player.play("idle")
	sprite.flip_h = true
	
	if sprite.flip_h:
		ray_cast.position.x = 30
	else:
		ray_cast.position.x = -30

func _physics_process(delta : float) -> void:
	if not immunity:
		if update_move:
			if not ray_cast.is_colliding() and is_on_floor():
				vel *= -1
				sprite.flip_h = not sprite.flip_h
				if sprite.flip_h:
					ray_cast.position.x = 30
				else:
					ray_cast.position.x = -30
			velocity.x = vel
			animation_player.play("run")
			pass
		else:
			velocity.x = 0
			animation_player.play("idle")
	else:
		velocity.x = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if hp <= 0:
		immunity = true
		animation_player.play("dead")

func take_damage(e_damage : int) -> void:
	if not immunity:
		hp -= e_damage
		immunity = true
		animation_player.play("hit")

func _on_area_2d_body_entered(body : CharacterBody2D) -> void:
	body.take_damage(damage)

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"hit":
			immunity = false
			animation_player.play("idle")
		"dead":
			var cure = cure_potion.instantiate()
			cure.position = position
			level.add_item(cure)
			queue_free()

func _on_timer_timeout():
	update_move = not update_move
