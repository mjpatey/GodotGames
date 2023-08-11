extends Area2D

onready var bling = get_node("bling")
onready var size_min = 0.3
onready var size_max = 1.2
onready var should_shrink = true
onready var rate = 0.04
var rng = RandomNumberGenerator.new()
var picked_up = false
var level_cleared = false
var WorldName 

func _ready():
	rng.randomize()
	var starting_scale = rng.randf_range(size_min + rate + .001, size_max - rate - .001)
	$Sprite.scale.x = starting_scale
	$Sprite.scale.y = starting_scale
	WorldName = get_parent().WorldName


func _process(delta):
	
#	if get_tree().get_nodes_in_group("Pickup").size() > 0:
	
	if should_shrink:
		shrink(rate)
		if $Sprite.scale.x <= size_min:
			should_shrink = false
			
	if not should_shrink:
		grow(rate)
		if $Sprite.scale.x >= size_max:
			should_shrink = true
#	else:
#		level_cleared()
	if get_tree().get_nodes_in_group("Pickup").size() == 0:
		level_cleared()
	
	
func shrink(amount):
		$Sprite.scale.x -= amount
		$Sprite.scale.y -= amount


func grow(amount):
		$Sprite.scale.x += amount
		$Sprite.scale.y += amount
		

func _on_Gold_body_entered(body):
	if visible and not picked_up:
		print("Gold pieces remaining: ", get_tree().get_nodes_in_group("Pickup").size())
		if get_tree().get_nodes_in_group("Pickup").size() == 1:
			level_cleared()
		bling.play()
		$shink.play()
#		visible = false
		get_parent().get_node("Player").score += 100
#		print (WorldName)
		get_parent().GotCoin()
		fly_to_score()
	yield (bling, "finished")
#	queue_free()

func fly_to_score():
#	if get_tree().get_nodes_in_group("Pickup").size() == 1:
#		level_cleared()
	var startpos = position
	picked_up = true
#	if get_tree().get_nodes_in_group("Pickup").size() == 1:
#		level_cleared()
	for i in 30:
		position.x += (720 - startpos.x)/31
		position.y += (32 - startpos.y)/31
#		$Sprite.modulate.a -= 4.25
		yield(get_tree().create_timer(0.01), "timeout")
#	$shink.play()
	visible = false
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	
func level_cleared():
	get_parent().level_cleared = true
		
#	672, 32
#	if not picked_up:
#		bling.play()
#		picked_up = true
##	print ($Sprite.scale.x)
##	while $Sprite.scale.x <= 4:
###		grow(rate)
###		$Sprite.scale.x += rate*5
###		$Sprite.scale.y += rate*5		
##		$Sprite.rotation_degrees -= 15
##		position.y += 1
##		print ($Sprite.scale.x)
#	yield (bling, "finished")
#	queue_free()
