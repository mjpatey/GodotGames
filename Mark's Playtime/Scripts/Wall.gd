extends StaticBody2D

onready var Player = get_parent().get_node("Player") 



# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = false
	

func _process(delta):
	pass
#	if Player.climbable > 0:
#		self.add_collision_exception_with(Player)
##		$CollisionShape2D.disabled = true
#	else:
##		$CollisionShape2D.disabled = false
#		self.remove_collision_exception_with(Player)
