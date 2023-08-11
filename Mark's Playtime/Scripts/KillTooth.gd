extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KillTooth_Static_body_entered(body):
	if body.name == "Player":
#		print ("Missile hit Player!")
		$HitSound.play()
		get_parent().get_parent().get_node("Player").player_is_hit = true
# 		get_parent().get_node("Player").player_is_hit = true
#		get_parent().get_node("Player").push_right = true
