extends KinematicBody2D

export (int) var speed = 150
export (int) var jump_speed = -350
export (int) var gravity = 550
export (float, 0, 1.0) var friction = 0.15
export (float, 0, 1.0) var acceleration = 0.25
export var lives = 70
export var player_start = Vector2(352, 64)
var player_is_dying = false
var climbable = 0
var climbdir = 0

var velocity = Vector2.ZERO

onready var JumpSound = $JumpSound
onready var walking = false
onready var Wall = get_parent().get_node("Wall") #trying to reference Wall's node here

func _ready():
	pass #print (Wall.name) # a test to see if we've really found "Wall"
	position = player_start

func get_input():
	if not player_is_dying:
		var dir = 0 # direction: -= 1 adds speed in the left direction, +=1 adds speed to the right
		
# Walking LEFT-RIGHT input
		
		if Input.is_action_pressed("move_right"):
			dir += 1
			$WalkingSprite.animation = "walking"
			$WalkingSprite.flip_h = false
		if Input.is_action_pressed("move_left"):
			dir -= 1
			$WalkingSprite.animation = "walking"
			$WalkingSprite.flip_h = true
		if dir == 0:
			if is_on_floor():
				$WalkingSprite.animation = "walking"
				$WalkingSprite.frame = 0
			elif climbable > 0:
				$WalkingSprite.animation = "climbing"
				$WalkSound.stop()
			else:
				$WalkingSprite.animation = "jumping"
				
		
# Climbing UP-DOWN input and execution
		
		if climbable > 0: # if we're on at least 1 ladder...
			climbdir = 0  # don't move up or down yet
			if Input.is_action_pressed("move_up"):
				climbdir = -1
			elif Input.is_action_pressed("move_down"):
				climbdir = 1

			if climbdir != 0: #if the player is pressing a climb key...
				velocity.y = speed * climbdir
				$WalkingSprite.animation = "climbing"
				$WalkingSprite.play()
				if not $LadderSound.is_playing():
					$LadderSound.play() # climbing sound here!!!
			
			else:
				velocity.y = 0
				$WalkingSprite.animation = "climbing"
				$WalkingSprite.stop()
				$LadderSound.stop() # stop climbing sound!!!
	
		if dir != 0 and (climbdir == 0): #if the player is pressing a walk key and we're not actually climbing a ladder...
			walking = true
			velocity.x = lerp(velocity.x, dir * speed, acceleration) # ramp up the x velocity to our max speed by the acceleration rate
			if is_on_floor():
#				pass
				$WalkingSprite.animation = "walking"
				$WalkingSprite.play()
			else:
				if climbable > 0:
					$WalkingSprite.animation = "climbing"
					$WalkingSprite.play()
#				else:
#					$WalkingSprite.stop()
	
		elif climbable <1: #if the player is not pressing a walk key and not on ladder...
			# velocity.x = lerp(velocity.x, 0, friction) # ramp down velocity to 0 by the friction amount
			velocity.x = 0
			walking = false
			$WalkSound.stop()
			$WalkingSprite.stop()
			$WalkingSprite.frame = 0
			
		if is_on_floor() and walking and not $WalkSound.is_playing() and climbable < 1:
			$WalkSound.play() # if we're on the floor and walking and walk sound isn't playing, play it!
			# to do: choose a random footstep as a starting point in the audio file
		if !is_on_floor() and climbable < 1:
			$WalkSound.stop() # if we're NOT on the floor and not on a ladder, stop the walk sound.
			$WalkingSprite.animation = "jumping"
#			$WalkingSprite.frame = 1
		
#		If ESC is pressed, show variables and reset Player...
		
		if Input.is_action_just_pressed("ui_cancel"):
			print ("Player must be stuck... resetting!")
			print ("At crash, velocity = ", velocity)
			print ("walking = ", walking)
			print ("on floor = ",is_on_floor())
			print ("climbable = ", climbable)
			print ("climb direction = ", climbdir)
			print()
			walking = false
			climbable = 0
			climbdir = 0
			$WalkSound.stop()
			$LadderSound.stop()
			$JumpSound.stop()
			position = player_start
			
			
func _physics_process(delta):
	if not player_is_dying:
		get_input()
		if climbable < 1:
			velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("Enemy"):
				print("Collided with: ", collision.collider.name)
			if collision.collider.name == "Bullet" and not player_is_dying:
				player_dies()
				lives -= 1
				
# If we're stuck in a wall/floor piece, pop us up out of it:
			# print ("colliding with ",collision.collider.name, "and Player is here: ",position.y, " and collider is here: ", collision.collider.position.y)
			if "Wall" in collision.collider.name:

				if self.position.y > collision.collider.position.y - 61 and velocity.y > 0:
					#print ("stuck in the wall! My y is ", position.y,", and the wall's y is ", collision.collider.position.y)
					position.y -=1
					#position.x +=4
				
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				# climbable = 0
				velocity.y = jump_speed # jump!
				$WalkSound.stop() # stop the walk sound
				$JumpSound.play() #play the jump sound
				$WalkingSprite.animation = "jumping"
#				$WalkingSprite.frame = 1
			if climbable > 0:
				velocity.y = jump_speed * 2 # jump!
				$WalkSound.stop() # stop the walk sound
				$JumpSound.play() #play the jump sound
				$WalkingSprite.animation = "jumping"
				
		
func player_dies():
	player_is_dying = true
	print("dying!")
	for i in 20:
		for n in 359:
			rotation_degrees = n
	print (lives)
	player_is_dying = false
	if lives < 1:
		queue_free()
	
