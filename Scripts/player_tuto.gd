extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stamina_bar: ProgressBar = $StaminaBar

var max_speed = 200
var SPEED = 200.0
const JUMP_VELOCITY = -400.0
@export var sprint_speed = 400

var can_sprint: bool = true
var is_sprinting: bool = false

@export var stamina_max: float = 5
var current_stamina: float = 0

func _ready() -> void:
	SPEED = max_speed
	
	stamina_bar.max_value = stamina_max
	stamina_bar.min_value = 0
	stamina_bar.value = current_stamina
	stamina_bar.visible = false
	
	current_stamina = stamina_max

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("sprint") and is_on_floor():
		if can_sprint == true:
			is_sprinting == true
			sprint(delta)
	else:
		is_sprinting == false
		current_stamina += delta
		SPEED = max_speed


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	stamina_ui()
	sprite_reverse()
	animation()
	move_and_slide()


func animation():
	if velocity.x != 0 and is_on_floor():
		animated_sprite.play("run")
	
	elif velocity.x == 0 and is_on_floor():
		animated_sprite.play("idle")
	
	elif velocity.y < 0:
		animated_sprite.play("jump")


func sprite_reverse():
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true


func sprint(_delta : float):
	current_stamina -= _delta
	current_stamina = clamp(current_stamina, 0, stamina_max)
	if current_stamina > 0:
		is_sprinting = true
		SPEED = sprint_speed
	else:
		SPEED = max_speed

func stamina_ui():
	stamina_bar.value = current_stamina
	if stamina_bar.value != stamina_max:
		stamina_bar.visible = true
		if stamina_bar.value == 0:
			stamina_bar.visible = false
	else:
		stamina_bar.visible = false
