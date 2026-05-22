extends Node2D

var file = preload("res://add_elements/client.tscn")
var T

func _ready() -> void:
	T = $Timer
	Global.new_client.connect(NC)
	NC()

func _on_timer_timeout() -> void:
	var cl = file.instantiate()
	var h = 0
	var g = randi_range(1,GlobalInventorySettings.icons.size()-1)
	for i in GlobalInventorySettings.icons.keys():
		if h==g:
			cl.item2 =  i
			cl.count2 = randi_range(1,3)
		h +=1
	add_child(cl)

func NC():
	T.stop()
	T.start()
