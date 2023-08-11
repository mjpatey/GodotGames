extends Node2D

var rng = RandomNumberGenerator.new()
var LocalPlopMan = preload("res://Scenes/PlopMan.tscn")
var level_cleared = false
var WorldName="WorldA"
var newploppy = false
onready var PlayerSpawn = $Player.position #This will set player spawn/respawn location to wherever he's hand-placed in the level
onready 	var startscore = global.score

func _ready():

#	pass
	rng.randomize()
	var waitstart = rng.randf_range(3.0, 6.25)
#	print (waitstart)
	yield(get_tree().create_timer(waitstart), "timeout")
	var LocalPlopManInstance = LocalPlopMan.instance()
	if 0 == 1: #In other words, don't do the following:
		self.add_child(LocalPlopManInstance)
#	$Gold.WorldName = WorldName


	
func _process(delta):
	if get_tree().get_nodes_in_group("Pickup").size() == 0:
		level_cleared = true

	if level_cleared == true:
		print("Level Clear!")
		get_tree().change_scene("res://Scenes/World1.tscn")

		level_cleared = false
	
	if global.score == startscore + 200:
		$JumpmanBG2.position.y = -360
	if global.score == startscore + 300:
		$JumpmanBG2.position.y = -600
		
	#Add this if you want to spawn one new PlopMan at 1000 pts:
	
#	if int($GUI/Score/Value.text) > 900 and newploppy == false:
#		var LocalPlopManInstance = LocalPlopMan.instance()
#		self.add_child(LocalPlopManInstance)
#		newploppy = true
	
	
func GotCoin():
	$GUI/Score.adjust(100)
	$GUI/Score.GoodFlash()
#	print("PlopMan Instance ID is ",get_instance_id())

func PlayerHit():
	if int($GUI/Score/Value.text) > 0:
		$GUI/Score.adjust(-100)
		$GUI/Score.BadFlash()

