extends Area3D
#iterative area3D
@export var character_body_3d: CharacterBody3D
@export var marker_area: Area3D
@export var animation_player: AnimationPlayer 
@export var mesh : MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marker_area.connect('area_entered', marker_on_interaction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func marker_on_interaction(area):
	print (area.name)
	character_body_3d.enemy_selected = true
	character_body_3d.enemy_stored = area
