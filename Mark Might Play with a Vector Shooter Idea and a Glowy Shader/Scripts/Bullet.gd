extends Area2D

var screensize = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
var distance = Vector2()


@onready var startpos = position

@export var speed = 1000

func _ready():
	$AudioStreamPlayer.play()
#
func _process(delta):
#	if abs(position - startpos) <= Vector2(1000,1000):
	if abs(distance.x) <= 1400 and abs(distance.y) <=1400:
		# Move the bullet
		position += transform.x * speed * delta
		distance += transform.x * speed * delta
		print(distance)
	else:
		queue_free()
#
	position.x = wrapf(position.x, 0, screensize.x)
	position.y = wrapf(position.y, 0, screensize.y)

#func _on_area_entered(area):
#	if area.is_in_group("enemies"):
#		area.explode()
#		queue_free()
#
