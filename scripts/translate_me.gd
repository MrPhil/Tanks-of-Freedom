extends Node
export var trans_key = 'LABEL_DEFAULT'

# I think this is no longer needed, because the Godot translation
# system takes care of this for us? - MrPhil May 11, 2019
# TODO: Do a real fix, maybe
func _ready():
#	add_to_group("translate_me")
#	refresh_label()
	pass

func refresh_label():
#	self.set_text(tr(self.trans_key))
	pass

func set_trans_key(new_key):
	self.trans_key = new_key
#	refresh_label()

