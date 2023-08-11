extends Label


# Declare member variables here. Examples:
onready var score = get_parent().get_node("Player").score
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	score = get_parent().get_node("Player").score

func process(delta):
	score = get_parent().get_node("Player").score
	print (score)
	print ("Hello, score?")
	text = str(score)
