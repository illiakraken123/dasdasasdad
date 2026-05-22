extends Node2D

func load_scane(name_sc:String):
	for i in get_children():
		i.hide()
	$".".get_node(name_sc).show()

func _ready() -> void:
	load_scane("sca_1")
	
