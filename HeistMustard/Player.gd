extends "res://Characters/TemplateCharacter.gd"

var motion = Vector2()

#export var zoom_factor = Vector2(.05, .05)
#export var zoom_in_limit = 1
#export var zoom_out_limit = 3.0


func _physics_process(delta):
	update_movement()
	move_and_slide(motion)
#	toggle_vision_mode()


func update_movement():
	look_at(get_global_mouse_position())
#	look_at(position + motion)
	if Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up"):
		motion.y = clamp (motion.y + SPEED, 0, MAX_SPEED)
	elif Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
		motion.y = clamp (motion.y - SPEED, -MAX_SPEED, 0)
	else:
		motion.y = lerp (motion.y, 0, FRICTION)
	
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		motion.x = clamp (motion.x - SPEED, -MAX_SPEED, 0)	
	elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		motion.x = clamp (motion.x + SPEED, 0, MAX_SPEED)
	else:
		motion.x = lerp (motion.x, 0, FRICTION)
#	if Input.is_action_pressed("zoom_in") and $Camera2D.zoom.x > zoom_in_limit:
#		$Camera2D.zoom -= (zoom_factor) * ($Camera2D.zoom/5)
#	elif Input.is_action_pressed("zoom_out")and $Camera2D.zoom.x < zoom_out_limit:
#		$Camera2D.zoom += (zoom_factor) * ($Camera2D.zoom/5)


func _input(event):
	if Input.is_action_just_pressed("toggle_vision_mode"):
		get_tree().call_group("Interface", "cycle_vision_mode")
#		print("Cycling vision mode!")
