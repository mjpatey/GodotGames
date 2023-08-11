extends Area2D

var screensize = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
var rot_speed = randf_range (-5, 5)
var move_speed = Vector2 (randf_range (-20, 20), randf_range(-20,20))

func _ready():
	position = Vector2 (randf_range (0, 2500), randf_range(0,1875))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += 10 * rot_speed * delta
	position += (move_speed * delta) * 7.5
	
	position.x = wrapf(position.x, 0, screensize.x)
	position.y = wrapf(position.y, 0, screensize.y)
