extends CharacterBody3D


@export var speed = 2
@export var gravity = -5
## Attach your camera3d that will follow the player
@export var camera_3d: Camera3D 
@export var camera_x_offset  = 0.0 as float
@export var camera_z_offset  = 0.0 as float
## Add a mesh that will mark the clicked place, add animations to make it looks better
@export var marker_object : MeshInstance3D
## This is the scenario representing your scenario. This should have a collisionshape3d to map the scenario 
@export var scenario_mesh : StaticBody3D

@export var tolerance = 0.1 as float

func _ready() -> void:
	#register
	scenario_mesh.connect('input_event', on_scenario_input_event)


var target = Vector3.ZERO

func _physics_process(delta):
	
	velocity.y += gravity * delta
	if target:
		look_at(target, Vector3.UP)
		rotation.x = 0
		velocity = -transform.basis.z * speed
		if transform.origin.distance_to(target) < tolerance:
			target = Vector3.ZERO
			velocity = Vector3.ZERO
	move_and_slide()
	camera_moviment(camera_3d)



func camera_moviment(camera):
	camera.position.x = position.x - (camera_x_offset )
	camera.position.z = position.z - (camera_z_offset )
	
	

func on_scenario_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			marker_object.transform.origin = position
			target = position

