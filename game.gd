extends Node2D

func _ready() -> void:
	Global.hide_all_UI.emit()
	var r = []
	for i in GlobalInventorySettings.staks.keys():
		r.append(i)
	GlobalInventorySettings.no_items["colbaout"] = r
	Global.new_client.emit()
	
	InventoryScript.set_inventory("player")
	InventoryScript.plus_item("цукор",5)
	InventoryScript.plus_item("відро",5)
	InventoryScript.upd_cell.emit("player")
