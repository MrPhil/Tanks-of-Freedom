extends Sprite

func _input(event):
	if(event is InputEventMouseButton):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		if (event.button_index == BUTTON_LEFT):
			if event.pressed:
				self.set_frame(1)
			else:
				self.set_frame(0)
	if (event is InputEventMouseMotion):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
			self.set_position(Vector2(event.x, event.y))  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func _ready():
	set_process_input(true)
	pass



