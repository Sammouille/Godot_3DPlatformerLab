extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Bloque la souris et la fait disparaître.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	
	
	# Déplacement du joueur
	var input := Vector3.ZERO
	input.x = Input.get_axis("bouger_gauche","bouger_droite")
	input.z = Input.get_axis("bouger_avant", "bouger_arrière")
	
	apply_central_force(twist_pivot.basis * input * delta * 1200)
	
	
	# Libère la souris si échap est pressé et la capture si échap est pressé de nouveau
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == 0 :
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		else :
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	# Rotation de la camera et du joueur (en tant que capsule)
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x,
		deg_to_rad(-30),
		deg_to_rad(30)
		)
	twist_input = 0.0
	pitch_input = 0.0
	
	
	# Saut et fast fall
	if Input.is_action_just_pressed("sauter"):
		apply_central_impulse(Vector3(0.0, 8.0, 0.0))
	
	if Input.is_action_just_pressed("chuteRapide"):
		apply_central_force(Vector3(0.0, -30.0, 0.0) * delta * 1200)
	

# Déplacement de la caméra uniquement si la souris est cachée
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
			
			
