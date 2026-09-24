extends Node2D
@export var smooth := 0.05
static var s_zindex = 0
var myIndex = 0 
var baseScale : Vector2
@export var scaleFactor : float = 1.1
var mat : ShaderMaterial 
var mat2 : ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mat = $Body.material
	mat2 = $Image.material
	baseScale = self.scale
	self.z_index = s_zindex
	myIndex = s_zindex
	s_zindex = s_zindex + 1
	pass # Replace with function body.

func _on_move_tilt(direction : Vector2) : 
	var target_y := direction.x 
	var target_x := -direction.y

	var cur_y: float = mat.get_shader_parameter("y_rot")
	var cur_x: float = mat.get_shader_parameter("x_rot")
	
	mat2.set_shader_parameter("y_rot", lerp(cur_y, target_y, 1.0 - exp(-smooth )))
	mat2.set_shader_parameter("x_rot", lerp(cur_x, target_x, 1.0 - exp(-smooth )))
	mat.set_shader_parameter("y_rot", lerp(cur_y, target_y, 1.0 - exp(-smooth )))
	mat.set_shader_parameter("x_rot", lerp(cur_x, target_x, 1.0 - exp(-smooth )))
	print(direction)
	pass

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
	mat2.set_shader_parameter("y_rot", 0)
	mat2.set_shader_parameter("x_rot", 0)
	mat.set_shader_parameter("y_rot", 0)
	mat.set_shader_parameter("x_rot", 0)
	TweenReset()
	TweenScale(baseScale)
	if (s_zindex != myIndex) : 
		self.z_index = s_zindex
		myIndex = s_zindex
		s_zindex = s_zindex + 1
	
	
func TweenScale(targetScale : Vector2):
	tween.tween_property(self, "scale",targetScale,0.05 )
	pass
