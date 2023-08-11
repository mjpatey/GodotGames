extends Label

export (int) var paddingLength = 5

var value = 0
onready var PlayerScore = get_parent().get_parent().get_node("Player").score #get_node("ScoreText").text

func _ready():
	update()
	
# warning-ignore:unused_argument
#func _process(delta):
#	update()

func reset():
#	value = 0
	global.score = 0
	update()

func adjust (adjustment):
#	value += adjustment
	global.score += adjustment
	update()

func update():
	$Value.text = ("%0*d" % [paddingLength, global.score]) #replace score with value is not working!
#	$Test.text = ("%0*d" % [paddingLength, get_parent().get_parent().get_node("Player").get_node("WalkingSprite").animation])

func BadFlash():
	for i in 10:
		$Value.add_color_override("font_color", Color(255,0,0,255))
		yield(get_tree().create_timer(0.0625), "timeout")
		$Value.add_color_override("font_color", Color(0,0,0,255))
		yield(get_tree().create_timer(0.0625), "timeout")
	$Value.add_color_override("font_color", Color(255,255,255,255))

func GoodFlash():
	for i in 4:
		$Value.add_color_override("font_color", Color(0,0,0,255))
		yield(get_tree().create_timer(0.04), "timeout")
		$Value.add_color_override("font_color", Color(255,255,0,255))
		yield(get_tree().create_timer(0.04), "timeout")
	$Value.add_color_override("font_color", Color(255,255,255,255))	
