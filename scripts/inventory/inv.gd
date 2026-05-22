extends TextureButton

var time_t = 0
var upp = true
var in_cadr = 5

@export var index = 0
@export var inventory = "player"

func _ready() -> void:
	mouse_entered.connect(toch_cur)
	mouse_exited.connect(not_toch_cur)
	button_up.connect(butt_up)
	button_down.connect(butt_down)
	InventoryScript.upd_cell.connect(update_cell)
	if index == -1:
		Global.hid_pri_inv.connect(hid)
		Global.sho_pri_inv.connect(sho)

func update_cell(innv):
	if innv == inventory:
		time_t = 0
		set_process(true)

func _process(delta):
	if index != -1:
		if time_t >=index/in_cadr:
			InventoryScript.set_inventory(inventory)
			texture_normal=InventoryScript.get_item(index,"icon")
			upp = false
			set_process(false)
			var fdds = InventoryScript.get_item(index,"number")
			if  fdds>1:
				$Label.text = str(fdds)
			else:
				$Label.text = ""
	time_t+=1

func toch_cur():
	InventoryScript.index_torch_cell = index
	InventoryScript.inventory_torch_cell = inventory

func not_toch_cur():
	InventoryScript.index_torch_cell = null
	InventoryScript.inventory_torch_cell = null

func butt_up():
	if index != -1:
		InventoryScript.set_inventory(inventory)
		if InventoryScript.get_item(index,"name") != InventoryScript.item[0] and InventoryScript.index_torch_cell !=null:
			if InventoryScript.index_torch_cell == -1:
				if InventoryScript.inventory_torch_cell != inventory:
					var rn = InventoryScript.get_item(index,"name")
					var rc = InventoryScript.get_item(index,"number")
					InventoryScript.delete(index)
					InventoryScript.set_inventory(InventoryScript.inventory_torch_cell)
					if InventoryScript.get_items_in_inventory(rn) <1:
						GlobalInventorySettings.size_inventory[InventoryScript.inventory_torch_cell] = GlobalInventorySettings.size_inventory[InventoryScript.inventory_torch_cell]+1
						Global.inv_pla.Up(GlobalInventorySettings.size_inventory[InventoryScript.inventory_torch_cell])
						InventoryScript.set_inventory(InventoryScript.inventory_torch_cell)
					InventoryScript.plus_item(rn,rc)
					InventoryScript.upd_cell.emit(inventory)
					InventoryScript.upd_cell.emit(InventoryScript.inventory_torch_cell)
			else:
				if inventory == InventoryScript.inventory_torch_cell:
					#InventoryScript.a_to_b(index,InventoryScript.index_torch_cell)
					#InventoryScript.upd_cell.emit(inventory)
					print()
				else:
					InventoryScript.set_inventory(InventoryScript.inventory_torch_cell)
					if GlobalInventorySettings.locked_items[inventory].find(InventoryScript.get_item(InventoryScript.index_torch_cell,"name")) == -1:
						InventoryScript.set_inventory(inventory)
						if GlobalInventorySettings.locked_items[inventory].find(InventoryScript.get_item(index,"name")) == -1:
							InventoryScript.a_to_b_inventory(index,InventoryScript.index_torch_cell,InventoryScript.inventory_torch_cell)
							
							InventoryScript.set_inventory("player")
							if inventory == "player":
								if InventoryScript.get_item(index,"number") == 0:
									InventoryScript.a_to_b(index,GlobalInventorySettings.size_inventory["player"]-1)
									Global.inv_pla.delite_one()
									GlobalInventorySettings.size_inventory["player"] = GlobalInventorySettings.size_inventory["player"]-1
							elif InventoryScript.inventory_torch_cell == "player":
								if InventoryScript.get_item(InventoryScript.index_torch_cell,"number") == 0:
									InventoryScript.a_to_b(InventoryScript.index_torch_cell,GlobalInventorySettings.size_inventory["player"]-1)
									Global.inv_pla.delite_one()
									GlobalInventorySettings.size_inventory["player"] = GlobalInventorySettings.size_inventory["player"]-1
							InventoryScript.upd_cell.emit(inventory)
							InventoryScript.upd_cell.emit(InventoryScript.inventory_torch_cell)
	Input.set_custom_mouse_cursor(null)
	Global.hid_pri_inv.emit()

func butt_down():
	Global.sho_pri_inv.emit()
	if index!=-1:
		InventoryScript.set_inventory(inventory)
		var img = InventoryScript.get_item(index,"icon")
		var texture = img.get_image()
		texture.resize(64, 64, Image.INTERPOLATE_LANCZOS)
		img = ImageTexture.create_from_image(texture)
		Input.set_custom_mouse_cursor(img,Input.CURSOR_ARROW,img.get_size() / 2)

func sho():
	show()
func hid():
	hide()
