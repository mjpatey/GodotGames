extends KinematicBody2D

enum {
	IDLE,
	NEW_DIRECTION,
	MOVE
}
const SPEED = 100
var gravity = 550
var velocity = Vector2()
var acceleration = .25
var state = MOVE
var direction = Vector2.RIGHT
var can_see = false
var flap_rising = true



func _ready():
	randomize()
	

func _process(delta):
#	match state:
#		IDLE:
#			pass
#		NEW_DIRECTION:
#			direction = choose([Vector2.RIGHT, Vector2.LEFT])
#			state = choose([IDLE, MOVE])
#		MOVE:
##			move(delta)
#			pass
	velocity.y += gravity * delta

	var playerpos = get_parent().get_node("Player").get_position()
#	position = position.move_toward(playerpos, SPEED * delta)
#	velocity = velocity.move_toward(playerpos, SPEED * delta)
#	velocity = position.direction_to(playerpos) * SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
#	print (get_parent().get_node("Player").name)	

	
	if velocity.x < 0 or position.x > playerpos.x:
		$Head/AnimatedSprite.flip_h = true
		$Body/AnimatedSprite2.flip_h = true
		$Wing/AnimatedSprite.flip_h = true
		$Head.position.x = lerp ($Head.position.x, -8, acceleration/2)
		$Head.position.y = lerp ($Head.position.y, -4, acceleration/2)
#		$Head.position.y = lerp ($Head.position.y, +8, acceleration/2)
	else:
		$Head/AnimatedSprite.flip_h = false
		$Body/AnimatedSprite2.flip_h = false
		$Wing/AnimatedSprite.flip_h = false
		$Head.position.x = lerp ($Head.position.x, 8, acceleration/2)
#		$Head.position.y = lerp ($Head.position.y, -8, acceleration/2)
		$Head.position.y = lerp ($Head.position.y, +4, acceleration/2)
	
	if can_see:
#		var playerpos = get_parent().get_node("Player").get_position()
#		velocity = position.direction_to(playerpos) * SPEED
#		look_at(playerpos)
		position = lerp(position, playerpos, .0075)
		
#		if position.y > playerpos.y:
#			velocity.y -= gravity * 1.5


	
	if position.x < 15:
		position.x = 1100
		velocity.x /=2
	elif position.x > 1100:
		position.x = 15
		velocity.x /=2
	if position.y < 15:
		position.y = 580
		velocity.y /=2
	elif position.y > 580:
		position.y = 15
		velocity.y /=2
		
func flap_rise():
	var playerpos = get_parent().get_node("Player").get_position()
	if position.y > playerpos.y:
		velocity.y -= gravity * .75
	else:
		velocity.y -= gravity * .5
#	$Wing/AnimatedSprite.flip_v = false

func flap_fall():
	$Wing/AnimatedSprite.play()
	pass
#	position.y = lerp (position.y, position.y + 32, acceleration)
#	$Wing/AnimatedSprite.flip_v = true
		
func move(delta):

#	velocity.x = lerp(velocity.x, direction.x * SPEED, acceleration)

	position += direction * SPEED * delta
			
func choose(array):
	array.shuffle()
	return array.front()


#func _on_Timer_timeout():
#	$Timer.wait_time = choose([0.5, 1, 1.5])
#	state = choose ([IDLE, NEW_DIRECTION, MOVE])
	


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		can_see = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		can_see = false


func _on_FlapTimer_timeout():
#	if not is_on_floor():
#		$Wing/AnimatedSprite.flip_v = true
	flap_fall()
	$FlapTimer2.start()
	


func _on_FlapTimer2_timeout():
#	if not is_on_floor():
#		$Wing/AnimatedSprite.flip_v = false
	flap_rise()
	$FlapTimer.start()

