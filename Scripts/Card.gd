extends Node2D

static var s_zindex = 0
var myIndex = 0 
var baseScale : Vector2
@export var scaleFactor : float = 1.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	baseScale = self.scale
	self.z_index = s_zindex
	myIndex = s_zindex
	s_zindex = s_zindex + 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
var tween

func TweenReset() :
	if tween : 
		tween.kill()
	tween = create_tween()

func OnPickUp() -> void:
	TweenReset()
	TweenScale(baseScale * scaleFactor)
	self.z_index = s_zindex + 1

func OnDropDown() -> void:
	
	TweenReset()
	TweenScale(baseScale)
	if (s_zindex != myIndex) : 
		self.z_index = s_zindex
		myIndex = s_zindex
		s_zindex = s_zindex + 1
	
	
func TweenScale(targetScale : Vector2):
	tween.tween_property(self, "scale",targetScale,0.05 )
	pass
