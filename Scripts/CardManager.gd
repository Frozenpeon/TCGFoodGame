extends Node2D
var cardDragged : Node2D
var offSetPickup : Vector2
var screenSize : Vector2
var oldPos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cardDragged != null : 
		var mouse_pos =  get_global_mouse_position() + offSetPickup
		if (oldPos == Vector2(0, 0)) : 
			oldPos = mouse_pos
		cardDragged._on_move_tilt(mouse_pos - oldPos)
		cardDragged.global_position = Vector2(clamp (mouse_pos.x, 0, screenSize.x), 
											  clamp(mouse_pos.y, 0, screenSize.y))
		oldPos = mouse_pos
	pass


func _input(event) : 
	if event is InputEventMouseButton  and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() : 
			raycastCheckCard()
		else :
			if cardDragged != null : 
				cardDragged.OnDropDown()
				cardDragged = null
				oldPos = Vector2(0, 0)

var highest_index = -1
var card = null

func raycastCheckCard():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		for res in result : 
			if highest_index < res["collider"].get_parent().z_index : 
				highest_index = res["collider"].get_parent().z_index
				card = res["collider"].get_parent()
		card.OnPickUp()
		cardDragged = card
		offSetPickup = cardDragged.global_position - get_global_mouse_position()
		highest_index = -1
