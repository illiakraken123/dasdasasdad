extends Button

@export var iuput = "colbain"
@export var output = "colbaout"
@export var id = 1
var give = []

func _ready() -> void:
	$"../Timer".timeout.connect(to_time)
	$"../Panel".hide()
	$"../Panel2".hide()
	$".".show()

func _pressed() -> void:
	InventoryScript.set_inventory(iuput)
	var fo = GlobalInventorySettings.ids_crafters[id]
	var h
	for i in fo:
		h = 0
		for g in i[0]:
			if InventoryScript.get_items_in_inventory(g)>=1:
				h+=1
		if i[0].size() == h:
			h = 0 
			InventoryScript.set_inventory(output)
			for g in range(GlobalInventorySettings.size_inventory[output]) :
				if i[1].has( InventoryScript.get_item(g,"name")) or InventoryScript.get_item(g,"name")=="_" :
					h+=1
			if h == GlobalInventorySettings.size_inventory[output]:
				give = i
				gi()

func gi():
	$"../Timer".wait_time = give[2]
	$"../Timer".stop()
	$"../Timer".start()
	$"../Panel".show()
	$"../Panel2".show()
	$".".hide()
	$"../stop".show()

func to_time():
	$".".show()
	$"../Panel".hide()
	$"../Panel2".hide()
	$"../stop".hide()
	if give != []:
		for j in give[1]:
			InventoryScript.set_inventory(output)
			InventoryScript.plus_item(j,1)
			InventoryScript.set_inventory(iuput)
			for i in give[0]:
				InventoryScript.minus_item(i,1)
			InventoryScript.upd_cell.emit(iuput)
			InventoryScript.upd_cell.emit(output)


func _on_stop_pressed() -> void:
	$"../Panel".hide()
	$"../Panel2".hide()
	$"../Timer".stop()
	$".".show()
	$"../stop".hide()
