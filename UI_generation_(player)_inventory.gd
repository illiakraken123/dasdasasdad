extends GridContainer

var sc=0
var size_inv
var new_cell
var file = preload("res://add_elements/texture_button.tscn")
var pos
var x_size = 132

func _ready() -> void:
	Global.inv_pla = get_tree().current_scene.get_node("UI/inventory/GridContainer")
	sc=0
	pos = position
	InventoryScript.upd_player_inv.connect(Up)
	size_inv = GlobalInventorySettings.size_inventory["player"]
	for i in range(size_inv):
		new_cell = file.instantiate()
		new_cell.index = i
		add_child(new_cell)
	sh()

func Up(n):
	if n > size_inv:
		for i in range(n-size_inv):
			new_cell = file.instantiate()
			new_cell.index = size_inv+i
			add_child(new_cell)
	size_inv = n
	position = pos - Vector2(((size_inv-10)*x_size)*sc/100,0)
	sh()

func delite_one():
	if get_child_count() > 0:
		get_children().back().queue_free()
		size_inv -=1

func _on_h_slider_value_changed(value: float) -> void:
	sc = value
	position = pos - Vector2(((size_inv-10)*x_size)*sc/100,0)

func sh():
	if size_inv>10:
		$"../HSlider".show()
	else:
		$"../HSlider".hide()
