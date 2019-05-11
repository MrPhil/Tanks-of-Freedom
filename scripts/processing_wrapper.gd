
extends Control

var processing

var handler
var working = true

func _init(processing, handler):
    self.processing = processing
    self.handler = handler
    self.set_physics_process(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func kill():
    self.working = false
    self.processing = null
    self.handler = null
    self.queue_free()

func _physics_process(delta):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
    if not self.working || not self.processing.ready:
        return

    self.handler.process(delta)

