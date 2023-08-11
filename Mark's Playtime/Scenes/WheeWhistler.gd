extends Area2D

export var speed = 600
var x_position_max = rand_range(12000, 36000)
var whistling = false
var rng = RandomNumberGenerator.new()
var roulette = 0
var already_started = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var playerpos = get_parent().get_node("Player").get_position()
	position.y = playerpos.y
	position.x = x_position_max
	rotation_degrees = 0
	$AnimatedSprite.play()


func _process(delta):
	if not already_started:
		yield(get_tree().create_timer(5.5),"timeout")
		already_started = true
	else:
		var playerpos = get_parent().get_node("Player").get_position()
		if position.x < x_position_max:
			position.x += speed * delta
			if position.y < playerpos.y and position.x < playerpos.x and position.x > 0:
				position.y += 1.4
				rotation_degrees += .2
			if position.y > playerpos.y and position.x < playerpos.x and position.x > 0:
				position.y -= 1.4
				rotation_degrees -= .2
			else:
				rotation_degrees = lerp(rotation_degrees, 0, .04)
				
			if position.x > 0 and position.x < 200 and whistling == false:
				playerpos = get_parent().get_node("Player").get_position()
				position.y = playerpos.y
				$AudioStreamPlayer2D.play()
#				print("whistling")
				whistling = true
		else:
			playerpos = get_parent().get_node("Player").get_position()
			position.x = -600
			rotation_degrees = 0
			position.y = playerpos.y
			whistling = false
			if position.y < 30:
				position.y = 30
			$ChargeUpSound.play()
			randomize()
			x_position_max = rand_range(6000, 18000)
#			print ("X position max is now", x_position_max)


func _on_WheeWhistler_body_entered(body):
	if body.name == "Player":
#		print ("Missile hit Player!")
		$HitSound.play()
		get_parent().get_node("Player").player_is_hit = true
		get_parent().get_node("Player").push_right = true
