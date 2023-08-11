extends Area2D

var movedir = Vector2(0,30)
var firing = false

func _physics_process(delta):
	var playerpos = get_node('../Player').get_position()
	if firing == false:
		if position.y < 631:
			move_and_slide(movedir,Vector2.UP)
