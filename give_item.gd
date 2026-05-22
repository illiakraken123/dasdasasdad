extends TextureButton

@export var item = "листок"

func _ready() -> void:
	texture_normal = GlobalInventorySettings.icons[item]

func _pressed() -> void:
	InventoryScript.set_inventory("player")
	if InventoryScript.get_items_in_inventory(item) <1:
		GlobalInventorySettings.size_inventory["player"] = GlobalInventorySettings.size_inventory["player"]+1
		Global.inv_pla.Up(GlobalInventorySettings.size_inventory["player"])
		InventoryScript.set_inventory("player")
	InventoryScript.plus_item(item,1)
	InventoryScript.upd_cell.emit("player")
	queue_free()
