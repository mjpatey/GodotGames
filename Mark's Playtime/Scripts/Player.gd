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
onready var push_right = false

export var player_health = 1000

var player_is_hit = false
var score = 0
var WorldName

var FootL01 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L01.ogg")
var FootL02 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L02.ogg")
var FootL03 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L03.ogg")
var FootL04 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L04.ogg")
var FootL05 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L05.ogg")
var FootL06 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L06.ogg")
var FootL07 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L07.ogg")
var FootL08 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L08.ogg")
var FootL09 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L09.ogg")
var FootL10 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L10.ogg")
var FootL11 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L11.ogg")
var FootL12 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L12.ogg")
var FootL13 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L13.ogg")
var FootL14 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L14.ogg")
var FootL15 = preload ("res://Sounds/Indexed_Footsteps/Left/Footstep_L15.ogg")

var FootR01 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R01.ogg")
var FootR02 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R02.ogg")
var FootR03 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R03.ogg")
var FootR04 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R04.ogg")
var FootR05 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R05.ogg")
var FootR06 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R06.ogg")
var FootR07 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R07.ogg")
var FootR08 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R08.ogg")
var FootR09 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R09.ogg")
var FootR10 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R10.ogg")
var FootR11 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R11.ogg")
var FootR12 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R12.ogg")
var FootR13 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R13.ogg")
var FootR14 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R14.ogg")
var FootR15 = preload ("res://Sounds/Indexed_Footsteps/Right/Footstep_R15.ogg")

var falling_too_fast = false

#onready var Plopman = get_parent().get_child().

func _ready():
	var WorldName = get_parent().WorldName

func get_input():
	if Input.is_action_pressed("move_left"):
		walkdir = -1
		walking = true
		$WalkingSprite.flip_h = true

	elif Input.is_action_pressed("move_right"):
		walkdir = 1
		walking = true
		$WalkingSprite.flip_h = false

	else:
		walking = false
		walkdir = 0
#		$WalkingSprite.animation = "standing"

	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_pressed("move_up") and climbable > 0:
		climbdir = -.9
		climbing = true
	elif Input.is_action_pressed("move_down") and climbable > 0:
		climbdir = 1.1
		climbing = true
	else:
		climbdir = 0
		climbing = false
		
func walk():
	velocity.x = lerp(velocity.x, walkdir * speed, acceleration)
	if is_on_floor():
		$WalkingSprite.animation = "walking"
		$WalkingSprite.play()
		if !$WalkSound.is_playing():
			walking = true
			
			# Here's where we sync footstep sounds to the animation:
			if $WalkingSprite.frame == 0:
				WalkSound_Randomize_L()
				$WalkSound.play()
#				print ("Left: ", $WalkSound.stream)
			if $WalkingSprite.frame == 4 and !$WalkSound2.is_playing():
				WalkSound_Randomize_R()
				$WalkSound2.play()
#				print ("Right: ", $WalkSound2.stream)
		else:
			walking = false
#			$WalkingSprite.animation = "standing"

	elif climbable > 0:
		$WalkingSprite.animation = "climbing"
		$WalkingSprite.play()
		$WalkSound.stop()
#		if !$LadderSound.is_playing():
#			$LadderSound.play()
#		print("climbing", testcounter)
#		testcounter -= 1
	else:
		$WalkingSprite.animation = "jumping_old"
		$WalkSound.stop()
		if climbable < 1:
			$LadderSound.stop()
				
func stop():
	$WalkingSprite.animation = "standing"
	$WalkingSprite.frame = 0
	$WalkingSprite.stop()
	$WalkSound.stop()
	$LadderSound.stop()
	velocity.x = lerp(velocity.x, 0, friction * 2)

	

func jump():
	if climbable > 0 and (velocity.y > -gravity * .67 or velocity.y < gravity * .67):
		velocity.y = 0
	if is_on_floor() or climbable > 0:
		velocity.y = -gravity * .67
		if climbable > 0:
			velocity.y = -gravity * .67
		if not $JumpSound.is_playing():
			$JumpSound.play()
		$WalkingSprite.animation = "jumping_old" #    why is this
		$WalkingSprite.play()                #    not working???

	
func climb(climbdir):
#	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		position.y += climbdir * 3
		$WalkingSprite.animation = "climbing"
		$WalkingSprite.play()
		if climbing and climbdir != 0 and not $LadderSound.is_playing():
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			$LadderSound.pitch_scale = rng.randf_range (.85, 1.15)
			$LadderSound.play()
		climbing = true
#	else:
#		stop()
#func unstuck():
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if "Wall" in collision.collider.name:
#			if position.y > collision.collider.position.y - 64:
#				position.y = collision.collider.position.y - 64
#				print(collision.collider.position.y)
func WalkSound_Randomize_L():
	var rng = RandomNumberGenerator.new()
	var LeftFootSound
	rng.randomize()
	var LeftFootIndex = rng.randi_range (1, 15)
	if LeftFootIndex == 1:
		LeftFootSound = FootL01
	if LeftFootIndex == 2:
		LeftFootSound = FootL02
	if LeftFootIndex == 3:
		LeftFootSound = FootL03
	if LeftFootIndex == 4:
		LeftFootSound = FootL04
	if LeftFootIndex == 5:
		LeftFootSound = FootL05
	if LeftFootIndex == 6:
		LeftFootSound = FootL06
	if LeftFootIndex == 7:
		LeftFootSound = FootL07
	if LeftFootIndex == 8:
		LeftFootSound = FootL08
	if LeftFootIndex == 9:
		LeftFootSound = FootL09
	if LeftFootIndex == 10:
		LeftFootSound = FootL10
	if LeftFootIndex == 11:
		LeftFootSound = FootL11
	if LeftFootIndex == 12:
		LeftFootSound = FootL12
	if LeftFootIndex == 13:
		LeftFootSound = FootL13
	if LeftFootIndex == 14:
		LeftFootSound = FootL14
	if LeftFootIndex == 15:
		LeftFootSound = FootL15
	$WalkSound.stream = LeftFootSound
#	print("Left: ", LeftFootIndex)
	
	
func WalkSound_Randomize_R():
	var RightFootSound
	var rando = RandomNumberGenerator.new()
	rando.randomize()
	var RightFootIndex = rando.randi_range (1, 15)
	if RightFootIndex == 1:
		RightFootSound = FootR01
	if RightFootIndex == 2:
		RightFootSound = FootR02
	if RightFootIndex == 3:
		RightFootSound = FootR03
	if RightFootIndex == 4:
		RightFootSound = FootR04
	if RightFootIndex == 5:
		RightFootSound = FootR05
	if RightFootIndex == 6:
		RightFootSound = FootR06
	if RightFootIndex == 7:
		RightFootSound = FootR07
	if RightFootIndex == 8:
		RightFootSound = FootR08
	if RightFootIndex == 9:
		RightFootSound = FootR09
	if RightFootIndex == 10:
		RightFootSound = FootR10
	if RightFootIndex == 11:
		RightFootSound = FootR11
	if RightFootIndex == 12:
		RightFootSound = FootR12
	if RightFootIndex == 13:
		RightFootSound = FootR13
	if RightFootIndex == 14:
		RightFootSound = FootR14
	if RightFootIndex == 15:
		RightFootSound = FootR15
	$WalkSound2.stream = RightFootSound
#	print("Right: ", RightFootIndex)
	
	
func _physics_process(delta):
	
	if not player_is_hit:
		get_input()
	
	if walking == false and climbing == false and (is_on_floor() or climbable >0):
		stop()
#	if walking == false and climbing == false and climbable > 0:
#		stop()

	else:
		walk()
	
	if climbable > 0:
		climb(climbdir)

	if climbable < 1:
		velocity.y += gravity * delta
		if !is_on_floor() and not $JumpSound.is_playing():
			$WalkingSprite.animation = "jumping_old"
			$WalkingSprite.frame = 4
			if position.y > 580 and not $FallDeathSound.is_playing():
				$FallDeathSound.volume_db = 0
				$FallDeathSound.play()
				if position.y > 590:
#					get_node("/root/World1").PlayerHit()
					get_parent().PlayerHit()
					$FallDeathSound.volume_db = -80
					$FallDeathSound.stop()
					velocity.y = 0
					position = get_parent().PlayerSpawn # start_position
					
#		else:
#			$WalkingSprite.animation = "walking"
	else:
		velocity.y = 0
		
	if climbdir == 0:	
		climbing = false
	
#	if velocity.y > 675:
#		falling_too_fast = true
#		player_is_hit = true
#	else:
#		falling_too_fast = false
#		player_is_hit = false
		
	velocity = move_and_slide(velocity, Vector2.UP) # ramp up the x velocity to our max speed by the acceleration rate	
#	print (position.x, "   ", position.y)
#	print (Plopman)
#	$ScoreText.text = str(score)
	if player_is_hit:
		$HitSound.play()
		blink_player()
#		score -= 100
#		print (score)
#		get_node("/root/World1").PlayerHit()
		get_parent().PlayerHit()
#		get_parent().get_node("GUI").get_node("Score").get_node("Value").adjustment = -100
		velocity.y = -gravity*.67
		if push_right == true:
			velocity.x = 1200
		else:
			velocity.x = -1200
	
		player_is_hit = false
		
#		yield(get_tree().create_timer(1.0),"timeout")
#		velocity.x = 0
#		velocity.y = 0

func blink_player():
	for i in 10:
		$WalkingSprite.visible = false
		yield(get_tree().create_timer(0.05), "timeout")
		$WalkingSprite.visible = true
		yield(get_tree().create_timer(0.075), "timeout")

