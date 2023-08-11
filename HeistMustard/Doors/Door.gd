extends Area2D

var can_click = false
var distance_to_player

#func _ready():
#	$AnimationPlayer.play("Open")


func _on_Door_body_entered(body):
	if body.collision_layer == 1:
		can_click = true
	else:
		open()


func _on_Door_body_exited(body):
	if body.collision_layer == 1:
		can_click = false


func _on_Door_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
		open() 

func open():
	#distance_to_player = global_position - get_parent().get_parent().get_node("Player").global_position
	#print (distance_to_player)
	#$AudioStreamPlayer2D.volume_db = (0-self.position.distance_to($"/root/Player")
	$AnimationPlayer.play("Open")
	#$AudioStreamPlayer2D.stream
	$AudioStreamPlayer2D.play()
