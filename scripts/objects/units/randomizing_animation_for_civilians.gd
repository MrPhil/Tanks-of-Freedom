func _ready():
    randomize()
    get_node("anim").seek(randf())
    if randf() < 0.5:
        self.set_flip_h(true)

    get_node("anim").set_speed_scale(rand_range(0.5, 1.5))  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
