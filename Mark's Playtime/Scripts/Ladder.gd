extends Area2D


onready var Player = get_parent().get_node("Player")
func _ready():
#	print (Player.name)
	pass

func _on_Ladder_body_entered(body):
	if body.name == "Player":
		Player.climbable += 1
		if Player.climbing == true:
			Player.position.x = position.x
		# Player.velocity.x = 0
		# Player.velocity.x = lerp(Player.velocity.x, 0, .15)
		# Player.position.x = lerp(Player.position.x, self.position.x, .5)
		# print ("on a ladder!", Player.climbable)
		
func _on_Ladder_body_exited(body):
	if body.name == "Player":
		Player.climbable -= 1
		# print ("left a ladder!", Player.climbable)
