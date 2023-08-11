extends KinematicBody2D

onready var walkdir = 0
onready var velocity = Vector2.ZERO
onready var speed = 150
onready var acceleration = .25
onready var gravity = 550
onready var friction = .15
onready var climbable = 0
onready var walking = false
onready var testcounter = 0
onready var climbdir = 0
onready var climbing = false
onready var start_position = Vector2(504,352)
onready var move_choice_x = 0
onready var move_choice_y = 0
onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func get_input():
	move_choice_x = rng.randi_range(-5,5)
	walkdir = move_choice_x
#	walking = true
#		$WalkingSprite.flip_h = true
#		walk()
	if walkdir != 0:
		walking = true
#		$WalkingSprite.flip_h = false
#		walk()
	else:
		walking = false

	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_pressed("move_up") and climbable > 0:
		climbdir = -1
		climbing = true
	elif Input.is_action_pressed("move_down") and climbable > 0:
		climbdir = 1
		climbing = true
	else:
		climbdir = 0
		climbing = false
		
func walk():
	velocity.x = lerp(velocity.x, walkdir * speed, acceleration)
#	move_toward
#	if is_on_floor():
#		$WalkingSprite.animation = "walking"
#		$WalkingSprite.play()
#		if !$WalkSound.is_playing():
##			var rng = RandomNumberGenerator.new()
##			rng.randomize()
##			$WalkSound.pitch_scale = rng.randf_range (.95, 1.05)
##			$WalkSound.play()
#			if $WalkingSprite.frame == 0:
#				$WalkSound.play()
#				#then somehow wait until a few frames have passed, then...
#			if $WalkingSprite.frame == 4 and !$WalkSound2.is_playing():
#				$WalkSound2.play()
##				yield()
##				yield(get_tree().create_timer(1.2), "timeout")
#
#	elif climbable > 0:
#		$WalkingSprite.animation = "climbing"
#		$WalkingSprite.play()
#		$WalkSound.stop()
##		if !$LadderSound.is_playing():
##			$LadderSound.play()
##		print("climbing", testcounter)
##		testcounter -= 1
#	else:
#		$WalkingSprite.animation = "jumping"
#		$WalkSound.stop()
#		if climbable < 1:
#			$LadderSound.stop()
				
func stop():
	velocity.x = lerp(velocity.x, 0, friction * 2)
#	$WalkingSprite.frame = 0
#	$WalkingSprite.stop()
#	$WalkSound.stop()
#	$LadderSound.stop()

func jump():
	if climbable > 0 and (velocity.y > -gravity * .67 or velocity.y < gravity * .67):
		velocity.y = 0
	if is_on_floor() or climbable > 0:
		velocity.y = -gravity * .67
#		if not $JumpSound.is_playing():
#			$JumpSound.play()
#		$WalkingSprite.animation = "jumping" #    why is this
#		$WalkingSprite.play()                #    not working???
##	$WalkingSprite.animation = "jumping"
	
#func climb(climbdir):
##	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
#		position.y += climbdir * 3
##		$WalkingSprite.animation = "climbing"
##		$WalkingSprite.play()
##		if climbing and climbdir != 0 and not $LadderSound.is_playing():
##			var rng = RandomNumberGenerator.new()
##			rng.randomize()
##			$WalkSound.pitch_scale = rng.randf_range (.75, 1.25)
##			$LadderSound.play()
#		climbing = true
#	else:
#		stop()
#func unstuck():
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if "Wall" in collision.collider.name:
#			if position.y > collision.collider.position.y - 64:
#				position.y = collision.collider.position.y - 64
#				print(collision.collider.position.y)
	
	
func _physics_process(delta):
	get_input()
	
	if walking == false and climbing == false:
		stop()
	else:
		walk()
	
#	if climbable > 0:
#		climb(climbdir)

#	if climbable < 1:
	velocity.y += gravity * delta
#		if !is_on_floor():
#			$WalkingSprite.animation = "jumping"
#			if position.y > 580 and not $FallDeathSound.is_playing():
#				$FallDeathSound.volume_db = 0
#				$FallDeathSound.play()
#				if position.y > 590:
#					$FallDeathSound.volume_db = -80
#					$FallDeathSound.stop()
#					velocity.y = 0
#					position = start_position
#
#		else:
#			$WalkingSprite.animation = "walking"
#	else:
#		velocity.y = 0
		
	if climbdir == 0:	
		climbing = false
		
	if position.x < 0:
		position.x = 1024
	elif position.x > 1024:
		position.x = 0
	if position.y < 0:
		position.y = 600
		velocity.y = 0
	elif position.y > 600:
		position.y = 0
		velocity.y = 0
	
#	unstuck()
		
	velocity = move_and_slide(velocity, Vector2.UP) # ramp up the x velocity to our max speed by the acceleration rate	
	
