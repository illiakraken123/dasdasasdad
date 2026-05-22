extends Node2D

@export var item1 = "_"
@export var item2 = "_"
@export var item3 = "_"

@export var count1 = 0
@export var count2 = 0
@export var count3 = 0

var a
var b

func _ready() -> void:
	InventoryScript.upd_cell.connect(update_cell)
	update_cell("player")

func _on_button_pressed() -> void:
	a = []
	a.append(item1)
	a.append(item2)
	a.append(item3)
	b = []
	b.append(count1)
	b.append(count2)
	b.append(count3)
	
	InventoryScript.set_inventory("player")
	var h = 0
	var g = 0
	for i in a:
		if i=="_":
			g +=1
		elif InventoryScript.get_items_in_inventory(i) >= b[h]:
			g +=1
		h+=1
	if g == 3:
		h = 0
		for i in a:
			if i!="_":
				InventoryScript.minus_item(i,b[h])
			h+=1
		Global.money +=10
		Global.Up_money.emit()
		Global.new_client.emit()
		InventoryScript.upd_cell.emit("player")
		queue_free()

func update_cell(n):
	if n == "player":
		a = []
		a.append(item1)
		a.append(item2)
		a.append(item3)
		b = []
		b.append(count1)
		b.append(count2)
		b.append(count3)
		
		InventoryScript.set_inventory("player")
		var h = 0
		var g = 0
		for i in a:
			get_node("ico"+str(h)).texture = GlobalInventorySettings.icons[i]
			if b[h]>1:
				get_node("ico"+str(h)).get_node("Label").text = str(b[h])
			if i=="_":
				get_node("Panel"+str(h)).hide()
			else:
				if InventoryScript.get_items_in_inventory(i) >= b[h]:
					get_node("Panel"+str(h)).hide()
				else:
					get_node("Panel"+str(h)).show()
			h+=1
