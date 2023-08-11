extends CharacterBody2D

var speed = 25  # move speed in pixels/sec
var rotation_speed = 4.5  # turning speed in radians/sec
#@export var bullet : PackedScene
#var screensize = get_viewport_rect().size
var screensize = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

#var Bullet = "res://Bullet.tscn"

func _ready():
	start()
	rotation_degrees = -90
	modulate = "7ab9ff"
#	$ThrustSprite.visible = 0
	$ThrustAnimation.visible = 0
#	$GunCooldown.wait_time = cooldown

func start():
	position = Vector2(screensize.x / 2, screensize.y / 2)
	print (screensize)



func _physics_process(delta):
	var move_input = Input.get_axis("ui_down", "ui_up")
	var rotation_direction = Input.get_axis("ui_left", "ui_right")
#	if velocity.x > -925 and velocity.x < 925:
	velocity += transform.x * move_input * speed
#	if velocity.y > -925 and velocity.y < 925:
#		velocity += transform.x * move_input * speed
	print(velocity)
	if move_input:
		modulate = "94c6ff"
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()

		$ThrustAnimation.visible = 1
	else:
		modulate = "7ab9ff"
		$AudioStreamPlayer.stop()
		$ThrustAnimation.visible = 0
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
	# Screen wrap code:
	
	position.x = wrapf(position.x, 0, screensize.x)
	position.y = wrapf(position.y, 0, screensize.y)
	
#	if Input.is_action_just_pressed("Shoot"):
#		shoot()
#
#func shoot():
##	var b = Bullet.instantiate()
##	owner.add_child(b)
##	b.transform = $Gun.global_transform
#	pass

