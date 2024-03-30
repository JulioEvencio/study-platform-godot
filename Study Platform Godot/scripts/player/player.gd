extends CharacterBody2D

@export var sprite : Sprite2D
@export var animation : AnimationPlayer
@export var collision_attack : CollisionShape2D
@export var ray_cast : RayCast2D
@export var timer : Timer

const SPEED : float = 100.0
const JUMP_VELOCITY : float = -300.0

var can_jump_wall : bool = false

var direction : float = 0.0
var is_attacking : bool = false
var damage : int = 1
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var immunity : bool = false
var hp_max : int = 3
var hp_current : int = hp_max

func _ready() -> void:
	animation.play("idle")

func _physics_process(delta : float) -> void:
	print(hp_current)
	
	if hp_current <= 0:
		return
	
	if ray_cast.is_colliding() and not is_on_floor():
		can_jump_wall = true
	
	to_attack()
	
	if not is_attacking:
		to_apply_gravity(delta)
		to_jump()
		to_move()
		move_and_slide()
	
	animate_sprites()

func to_apply_gravity(delta : float) -> void:
	if not is_on_floor():
		if ray_cast.is_colliding():
			velocity.y = 0
		else:
			velocity.y += gravity * delta

func to_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_jump_wall:
			var dist : int = 2
			velocity.y = JUMP_VELOCITY
			if sprite.flip_h:
				velocity.x -= JUMP_VELOCITY * dist
			else:
				velocity.x += JUMP_VELOCITY * dist
			sprite.flip_h = not sprite.flip_h
			ray_cast.target_position.x = 5.1 if not sprite.flip_h else -7.1
		
		can_jump_wall = false

func to_move() -> void:
	direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		sprite.flip_h = false if direction > 0 else true
		collision_attack.position.x = 9.5 if direction > 0 else -10.5
		if not can_jump_wall:
			ray_cast.target_position.x = 5.1 if direction > 0 else -7.1
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func to_attack() -> void:
	if not is_attacking and Input.is_action_just_pressed("attack") and is_on_floor():
		is_attacking = true

func animate_sprites() -> void:
	if is_attacking:
		animation.play("attack")
	elif ray_cast.is_colliding():
		animation.play("wall_slide")
	elif velocity.y > 0:
		animation.play("fall")
	elif velocity.y < 0:
		animation.play("jump")
	elif direction:
		animation.play("run")
	else:
		animation.play("idle")

func take_damage(damage : int) -> void:
	if not immunity:
		hp_current -= damage
		immunity = true
		sprite.modulate = Color.RED
		timer.start()
		if hp_current <= 0:
			animation.play("death")

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"attack":
			is_attacking = false
		"death":
			get_tree().reload_current_scene()

func _on_area_2d_body_entered(body : CharacterBody2D) -> void:
	body.take_damage(damage)

func _on_timer_timeout():
	immunity = false
	sprite.modulate = Color.WHITE
