extends Node2D

@onready var bullet = preload("res://Scenes/Bullet.tscn")
#@onready var player = $Player
#@export var playerMomentum = player.velocity as float

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#check for fire and fire bullet
	if Input.is_action_just_pressed("Shoot") and get_tree().get_nodes_in_group("Bullet").size() <= 3:
		var new_bullet = bullet.instantiate()
		new_bullet.position = $Player.position
		new_bullet.rotation = $Player.rotation
#		new_bullet.velocity += $Player.velocity
		add_child(new_bullet)
		
		
