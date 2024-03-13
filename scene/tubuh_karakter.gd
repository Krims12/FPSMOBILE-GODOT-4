extends CharacterBody3D

@onready var Kepala =$Kepala
@onready var Lompat_BTN =$"../Tombol/Lompat"
@onready var Lari_BTN =$"../Tombol/Lari"
@onready var Jongkok_BTN =$"../Tombol/Jongkok"
@export var Animationplayer = AnimationPlayer


const SENSISTIVITY = 0.20
var SPEED = 5.0
const JUMP_VELOCITY = 5

const lerp_time = 10
var direction = Vector3.ZERO
var is_crouching : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass
	
func _input(event):
	if event is InputEventScreenDrag:
	#pengaturan layar. berapa layar tidak tergeser
		if event.position.x > 500:
			rotate_y(deg_to_rad(-event.relative.x * SENSISTIVITY))
			Kepala.rotate_x(deg_to_rad(-event.relative.y * SENSISTIVITY))
			
			Kepala.rotation.x = clamp(Kepala.rotation.x, deg_to_rad(-45), deg_to_rad(60))
		
	if Jongkok_BTN.is_pressed() and Animationplayer:
		toggle_Crouch()
		
func _physics_process(delta):
	# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		
	# Handle jump.
		if Input.is_action_just_pressed("ui_accept") or Lompat_BTN.is_pressed() and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
		if Lari_BTN.is_pressed():
			input_dir.y = -1
			SPEED = 8.0
		
		else: 
			SPEED = 5.0
		
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * lerp_time)
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()

func toggle_Crouch():
	if is_crouching == true:
		print('jongkok')
		
	elif is_crouching == false:
		print('berdiri')
	is_crouching =!is_crouching


func _on_keluar_pressed():
	get_tree().quit()
	pass # Replace with function body.
