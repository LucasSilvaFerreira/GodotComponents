extends CharacterBody3D


@export var speed = 0.7
@export var gravity = -5
## Attach your camera3d that will follow the player
@export var camera_3d: Camera3D 
@export var camera_x_offset  = 0.22 as float
@export var camera_z_offset  = -1.0 as float
## Add a mesh that will mark the clicked place, add animations to make it looks better
@export var marker_object : MeshInstance3D
## This is the scenario representing your scenario. This should have a collisionshape3d to map the scenario 
@export var scenario_mesh : StaticBody3D

@export var tolerance = 0.5 as float
# character animation
@export var animations : AnimationPlayer
# character slash
@export var slash_animation : AnimationPlayer
@export var hit_frame_in_second : float =  1.0
var enemy_selected = false
var enemy_stored : Area3D
var timer_attack : Timer

func _ready() -> void:
	#register

	scenario_mesh.connect('input_event', on_scenario_input_event)


var target = Vector3.ZERO


func _process(delta):
	hit_animation(animations.current_animation)
	
func _physics_process(delta):
	
	velocity.y += gravity * delta
	if target:
		look_at(target, Vector3.UP)
		rotation.x = 0
		velocity = -transform.basis.z * speed
		if transform.origin.distance_to(target) < tolerance:
			target = Vector3.ZERO
			velocity = Vector3.ZERO
			if enemy_selected:

				if  animations.current_animation != 'ATTACK': # to no trigger several times
					animations.play('ATTACK')
			else:
				animations.play('IDLE')
			
		else:
			animations.play('RUN')
	
	move_and_slide()
	camera_moviment(camera_3d)



func flash_animation():
		# Start value (original shader parameter value)
	var original_color: Vector4 = Vector4(0, 0, 0, 0)
	# Target value to tween to
	var target_color: Vector4 = Vector4(40,40, 40, 1)

	var mesh_to_material = enemy_stored.mesh as MeshInstance3D

	var tween = get_tree().create_tween()


	tween.tween_method( func(value): mesh_to_material.get_active_material(0).set_shader_parameter("color", value),  
 original_color,  # Start value
  target_color,  # End value
  0.3     # Duration
);
	tween.tween_method( func(value): mesh_to_material.get_active_material(0).set_shader_parameter("color", value),  
 target_color,  # Start value
  original_color,  # End value
  0.1     # Duration
);
func hit_animation(anim_name):
	#print (anim_name)
	if anim_name == 'ATTACK':
		if roundf(animations.current_animation_position * 100) == roundf(hit_frame_in_second * 100):
				enemy_stored.animation_player.play("DAMAGE")
				flash_animation()
				slash_animation.play('slash')
				

		
		

		

func camera_moviment(camera):
	camera.position.x = position.x - (camera_x_offset )
	camera.position.z = position.z - (camera_z_offset )
	
	

func on_scenario_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			enemy_selected = false
			enemy_stored = null
			marker_object.transform.origin = position
			target = position

