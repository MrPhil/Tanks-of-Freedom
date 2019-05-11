extends TextureButton

export var offset_x = 0
export var offset_y = 3

var label
var start_position

func press_label():
	label.set_position(start_position + Vector2(offset_x,offset_y))  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func release_label():
	label.set_position(start_position)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func _ready():
	label = get_node("Label")
	start_position = label.get_position()  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	self.connect("pressed", self, "press_label")
	self.connect("released", self, "release_label")
	pass
	
