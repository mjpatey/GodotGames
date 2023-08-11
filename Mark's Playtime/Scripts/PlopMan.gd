extends KinematicBody2D

var velocity = Vector2.ZERO
#var gravity = 550
var rng = RandomNumberGenerator.new()
#var dir = Vector2.ZERO
#var pouncing = false
#var pounce_scale_count = 0
#var plop_scale_count = 0
export var startpos = Vector2()
#var is_airborne = false $Timer

const UP = Vector2(0, -1)
const GRAVITY = 12
const SPEED = 400
const JUMP_HEIGHT = -600

var motion = Vector2()
var motion_previous = Vector2()

var hit_the_ground = false

var accel_count_limit = 180
var accel_count = 0
var waittime = 0.0
var hit_player = false
onready var PlayerScore = get_parent().get_node("GUI").get_node("Score").get_node("Value").text


func _ready():
	rng.randomize()
	position = startpos
#	start_delay()
#	$Timer.start()
#	$AnimatedSprite.play()

#	rng.randomize();
#	position = startpos
#	print ("Starting yield...")
#	yield(get_tree().create_timer(get_delay_time()), "timeout")
#	print ("Yield finished!")
	$Timer.start()
	$AnimatedSprite.play()


#func get_delay_time():
#	rng.randomize()
#	var waitstart = rng.randf_range(3.0, 6.25)
#	print (waitstart)
#	return waitstart


#func start_delay():
#	rng.randomize()
#	var waitstart = rng.randf_range(3.0, 6.25)
#	print (waitstart)
#	yield(get_tree().create_timer(waitstart), "timeout")

	

func pounce():
	accel_count = 0
	var player_relative = 0
	var playerpos = get_parent().get_node("Player").get_position()
	player_relative = position.x - playerpos.x
	
	if is_on_floor():
		$IdleSound.stop()
		$JumpSound.play()
		$BoingSound.play()
		motion.x = -player_relative #/ 1.25
		motion.y = (JUMP_HEIGHT - position.y / 2) * rng.randf_range(.8, 1.2) #600 + rng.randf_range(0, 600)
		velocity.y -= motion.y * GRAVITY * position.y/40
#
#
func _on_Timer_timeout():

	if is_on_floor(): #and $AnimatedSprite.frame == 2 or 3 or 4:
		pounce()
	rng.randomize()
	waittime = rng.randf_range(2.5,6.69) + 1
	$Timer.wait_time = waittime

	
func _physics_process(delta):
#	PlayerScore = int(get_parent().get_node("GUI").get_node("Score").get_node("Value").text)
	motion.y += GRAVITY
#	if $AnimatedSprite.frame == 8:
#		motion.y -=40
	
#	yield(get_tree().create_timer(1.0), "timeout")
#	var player_relative = 0
#	var playerpos = get_parent().get_node("Player").get_position()
#	pouncing = true
#	player_relative = position.x - playerpos.x
#	motion.x = -player_relative / 2
	
#	if is_on_floor():
#		if Input.is_action_just_pressed("plopjump"):
#			motion.y = JUMP_HEIGHT - position.y / 2 #600 + rng.randf_range(0, 600)
#			velocity.y -= motion.y * GRAVITY * position.y/40
##			velocity.x += motion.x / 4
##			$AnimatedSprite.frame = 6
	
	motion_previous = motion
	
	motion = move_and_slide(motion, UP, false)
	
	if not is_on_floor():
		hit_the_ground = false
		$AnimatedSprite.scale.y = range_lerp(abs(motion.y), 0, abs(JUMP_HEIGHT), 0.75, 1.75)
		$AnimatedSprite.scale.x = range_lerp(abs(motion.y), 0, abs(JUMP_HEIGHT), 1.25, 0.75)

	if not hit_the_ground and is_on_floor():
		hit_the_ground = true
		accel_count = 0
		if not $LandingSound.is_playing():
			$LandingSound.play()
		$AnimatedSprite.scale.x = range_lerp(abs(motion_previous.y), 0, abs(1700), 1.2, 2.0)
		$AnimatedSprite.scale.y = range_lerp(abs(motion_previous.y), 0, abs(1700), 0.8, 0.5)
	
	$AnimatedSprite.scale.x = lerp($AnimatedSprite.scale.x, 1, 1 - pow(0.01, delta))
	$AnimatedSprite.scale.y = lerp($AnimatedSprite.scale.y, 1, 1 - pow(0.01, delta))
	
	if is_on_floor():
		motion.x = lerp(motion.x, 0, .125)
		if not $JumpSound.is_playing() and not $LandingSound.is_playing() and not $BoingSound.is_playing() and not $IdleSound.is_playing():
#			yield(get_tree().create_timer(1.0), "timeout")
#			print($IdleSound.is_playing(), $JumpSound.is_playing(), $LandingSound.is_playing(), $BoingSound.is_playing())
			$AnimatedSprite.play()
			$IdleSound.play()

#	else:
#		$AnimatedSprite.stop()

#	velocity.y += gravity * delta
#	velocity = move_and_slide(velocity, Vector2.UP) # previously used (0,1)
	var playerpos = get_parent().get_node("Player").get_position()
	if position.x > playerpos.x:
		$AnimatedSprite.flip_h = true
		if accel_count <= accel_count_limit:
#			position.x -= .01 * accel_count
			motion.x -= .05 * accel_count
			accel_count += 1
		else:
			accel_count = accel_count_limit
	elif position.x < playerpos.x:
		$AnimatedSprite.flip_h = false
		if accel_count <= accel_count_limit:
#			position.x += .01 * accel_count
			motion.x += .05 * accel_count
			accel_count += 1
		else:
			accel_count = accel_count_limit

	if position.x < playerpos.x + 20 and position.x > playerpos.x - 20 and position.y > playerpos.y:
			rng.randomize()
			var pounce_or_not = rng.randi_range(0,33)
			if pounce_or_not == 1:
				pounce()
#
#	if is_on_floor():
#		velocity.x = lerp(velocity.x, 0, .25)
#		pouncing = false
#		pounce_scale_count = 0
#		scale.y = 1
#		plop_scale_count += 1
#		if plop_scale_count < 11:
#			scale.y -= .05
#		else:
#			if scale.y < .45:
#				scale.y =+ .05
#		yield(get_tree().create_timer(1.0), "timeout")
#		scale.y = 1
#
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
#
#	if pouncing: # vertical stretch at start of pounce
#			pounce_scale_count += 1
#			if pounce_scale_count < 11:
#				scale.y += .05 
#			else:
#				if scale.y > 1.05:
#					scale.y -= .05
#	if is_on_floor() == false:
#		is_airborne = true
#	else:
#		if is_airborne:
#			print ("Squish here")
#			squish()
#			is_airborne = false
	if position.x < 150:
#		position = startpos
		motion.x = -motion.x * 2
		$BoingSound.play()
#		velocity.y = 0
	elif position.x > 1100:
#		position = startpos
		motion.x = -motion.x * 2
		$BoingSound.play()
#		velocity.y = 0
	if position.y < 0:
#		position = startpos
#		velocity.x = 0
		motion.y = -motion.y * 2
		$BoingSound.play()
	elif position.y > 570:
#		position = startpos
#		velocity.x = 0
		motion.y = -motion.y * 2
		$BoingSound.play()
		yield(get_tree().create_timer(1.0), "timeout")
		if position.y > 570:
			position = startpos
			
# Check for collision with Player:

	if get_slide_count() > 0:
#		for i in get_slide_count():
		for i in range(0, get_slide_count()):
			var collision = get_slide_collision(i)
			if collision != null and collision.collider.name == "Player" and hit_player == false:
				hit_player = true
				$HitSound.play()
				get_parent().get_node("Player").player_is_hit = true
				if motion.x >0:
					get_parent().get_node("Player").push_right = true
				else:
					get_parent().get_node("Player").push_right = false
				$IdleSound.stop()
				var Player = get_parent().get_node("Player")
				playerpos = Player.get_position()
				if position.x > playerpos.x:
					motion.x += 200
					Player.velocity.x -= 600
				else:
					motion.x -= 200
					Player.velocity.x += 600
				motion.y -= 200
				Player.velocity.y -= 200

				yield(get_tree().create_timer(1.0), "timeout")
				$IdleSound.play()
				hit_player = false
				
	# Plopman increases in pitch and speed as score increases...		
	PlayerScore = float(get_parent().get_node("GUI/Score/Value").text)
	$AnimatedSprite.speed_scale = 0.6 + PlayerScore/2200
	$IdleSound.pitch_scale = 0.6 + PlayerScore/2200
	$JumpSound.pitch_scale = 0.6 + PlayerScore/2200
