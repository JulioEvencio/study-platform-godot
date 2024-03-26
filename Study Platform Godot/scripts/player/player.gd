extends CharacterBody2D

@export var sprite : Sprite2D
@export var animation : AnimationPlayer

const SPEED : float = 100.0
const JUMP_VELOCITY : float = -300.0

var direction : float
var landing : bool
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	animation.play("idle")

func _physics_process(delta : float) -> void:
	to_apply_gravity(delta)
	to_jump()
	to_move()
	animate_sprites()

func to_apply_gravity(delta : float) -> void:
	if not is_on_floor():
		landing = true
		
		velocity.y += gravity * delta

func to_jump() -> void:
	if not landing and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func to_move() -> void:
	if is_on_floor() and landing:
		return
	
	direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		sprite.flip_h = false if direction > 0 else true
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func animate_sprites() -> void:
	if velocity.y > 0:
		animation.play("fall")
	elif velocity.y < 0:
		animation.play("jump")
	elif landing:
		animation.play("landing")
	elif direction:
		animation.play("run")
	else:
		animation.play("idle")

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"landing":
			landing = false
