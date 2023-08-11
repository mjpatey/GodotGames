extends KinematicBody2D

var movedir = Vector2(0,30)
var firing = false
var finished_firing = false
var FireSpeed = Vector2(150,0)
var playerpos_original = Vector2()

func _physics_process(delta):
	var playerpos = get_node('../Player').get_position()
	if firing == false:
		if position.y < 631:
			move_and_slide(movedir,Vector2.UP)
			if $Checker.is_colliding() and $Checker.get_collider().name == "Player" and firing == false:
				playerpos_original = Vector2 (1200, playerpos.y)
				firing = true
				if not $BulletSound.is_playing():
					$BulletSound.play()
		else:
			position.y = 0
			position.x = 352
	if firing == true:
#		var collision = move_and_collide((playerpos_original-position)*delta)
		var collision = move_and_collide((FireSpeed)*delta)
		if collision and collision.collider.name == "Player":
			firing = false
#			print("I collided with ", collision.collider.name)
		if position.x >1400:
			firing = false
			position.x = 352
			position.y = 0
