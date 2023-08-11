extends CanvasModulate

const DARK = Color("111111")
const NIGHTVISION = Color("37bf62")

var cooldown = false

func _ready():
	visible = true
	color = DARK


func cycle_vision_mode():
	if not cooldown:
		if color == NIGHTVISION:
			DARK_mode()
		else:
			NIGHTVISION_mode()
		cooldown = true
		$Timer.start()


func DARK_mode():
	color = DARK
	$AudioStreamPlayer.stream = load("res://SFX/nightvision_off.wav")
	$AudioStreamPlayer.play()

func NIGHTVISION_mode():
	color = NIGHTVISION
	$AudioStreamPlayer.stream = load("res://SFX/nightvision.wav")
	$AudioStreamPlayer.play()



func _on_Timer_timeout():
	cooldown = false
