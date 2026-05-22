extends Node

var inventory
var size_inventory
var staks
var icons
var item
var no_items
var locked_items

signal upd_cell(innv)
signal upd_player_inv(ns)
var inventory_player_name = "player"
var index_torch_cell = null
var inventory_torch_cell

func set_inventory(inventory_name: String):
	# Link local variables to global settings for the specified inventory
	item = GlobalInventorySettings.item.duplicate()
	icons = GlobalInventorySettings.icons
	staks = GlobalInventorySettings.staks
	inventory = GlobalInventorySettings.inventorys[inventory_name]
	size_inventory = GlobalInventorySettings.size_inventory[inventory_name]
	no_items = GlobalInventorySettings.no_items[inventory_name]
	locked_items = GlobalInventorySettings.locked_items[inventory_name]
	
	# Adjust inventory array size to match defined capacity
	while inventory.size() < size_inventory:
		inventory.append(item.duplicate())
	while inventory.size() > size_inventory:
		inventory.remove_at(inventory.size() - 1)

func get_plus_item(item_name: String):
	var f = null   # Stores index of an existing stack with available space
	var fh = null  # Stores index of the first available empty slot
	var g = 0      # Current index counter
	
	# Iterate through inventory to find suitable placement slots
	for i in inventory:
		if f == null:
			# Check if item exists and isn't fully stacked
			if i[0] == item_name and i[1] != staks[item_name]:
				f = g
			# Identify empty slots
			if i == item:
				if fh == null:
					fh = g
		g += 1
	
	return [f, fh] # Returns [target_stack_index, empty_slot_index]

func plus_item(item_name: String, v: int):
	# Check if the item is permitted in this inventory (Blacklist check)
	if true:
		var g = get_plus_item(item_name)
		var f = g[0]
		var fh = g[1]
		var col = -1
		
		# Calculate potential overflow if a slot is found
		if f != null or fh != null:
			if f != null:
				col = inventory[f][1] + v - staks[item_name]
			else:
				col = inventory[fh][1] + v - staks[item_name]
		
		if col > 0:
			# Handle overflow: Fill current slot and recursively process the remainder
			if f == null:
				if fh == null:
					print("Inventory Full!")
					return v
				else:
					inventory[fh][0] = item_name
					inventory[fh][1] += v - col
					return plus_item(item_name, col)
			else:
				inventory[f][1] += v - col
				return plus_item(item_name, col)
		else:
			# Item(s) fit within a single slot
			if f == null:
				if fh == null:
					print("Inventory Full!")
				else:
					inventory[fh][0] = item_name
					inventory[fh][1] += v
			else:
				inventory[f][1] += v
			return 0
	else:
		# Item is blacklisted for this inventory
		return v

func clear():
	# Wipe inventory and re-initialize with empty slots
	inventory = []
	for i in range(size_inventory):
		inventory.append(item.duplicate())

func delete(index: int):
	# Reset a specific slot to its default empty state
	inventory[index] = item.duplicate()

func get_item(index: int, v: String):
	# Helper to retrieve specific data from a slot (name, count, icon, or stack limit)
	if v == "name":
		return inventory[index][0]
	elif v == "number":
		return inventory[index][1]
	elif v == "icon":
		return icons[inventory[index][0]]
	elif v == "stak":
		return staks[inventory[index][0]]

func a_to_b(index_: int, index: int):
	# Handles internal item movement and stacking logic
	if index != index_: # Prevent operations on the same slot
		var item_name = inventory[index_][0]
		var v = inventory[index_][1]
		
		if inventory[index][0] == item_name: # Handle stacking existing items
			var col = inventory[index][1] + v - staks[item_name]
			if col > 0: # Handle remainder if the target stack overflows
				inventory[index][1] = staks[item_name]
				inventory[index_][1] = col
			else:
				inventory[index][1] += v
				delete(index_)
		else:
			# Swap items if types are different
			var f = inventory[index]
			inventory[index] = inventory[index_]
			inventory[index_] = f

func drop(index: int, v: int):
	# Handles item dropping logic with "Locked Item" protection
	if locked_items.find(inventory[index][0]) == -1:
		var f = inventory[index][1]
		var g = f - v
		if g < 0:
			var dropped = f
			delete(index)
			return dropped
		else:
			if g == 0:
				delete(index)
			else:
				inventory[index][1] -= v
			return v
	return 0 # Item is locked and cannot be dropped

func a_to_b_inventory(index_: int, index: int, inventory_name: String):
	# Transfers items between different inventories with full permission checks
	var target_inv = GlobalInventorySettings.inventorys[inventory_name]
	var target_no_items = GlobalInventorySettings.no_items[inventory_name]
	var target_locked = GlobalInventorySettings.locked_items[inventory_name]
	
	# Check Locked items and Blacklists for both source and destination
	if (locked_items.find(inventory[index_][0]) == -1) and \
	   (target_locked.find(target_inv[index][0]) == -1):
		
		if target_no_items.find(inventory[index_][0]) == -1 and \
		   no_items.find(target_inv[index][0]) == -1:
			
			var item_name = inventory[index_][0]
			var v = inventory[index_][1]
			
			if target_inv[index][0] == item_name: # Handle stacking in target inventory
				var col = target_inv[index][1] + v - staks[item_name]
				if col > 0:
					target_inv[index][1] = staks[item_name]
					inventory[index_][1] = col
				else:
					target_inv[index][1] += v
					delete(index_)
			else:
				# Swap items between inventories
				var f = target_inv[index].duplicate()
				target_inv[index] = inventory[index_].duplicate()
				inventory[index_] = f

func get_items_in_inventory(item_name: String):
	# Calculates total quantity of a specific item across all slots
	var count = 0
	for i in inventory:
		if i[0] == item_name:
			count += i[1]
	return count

func minus_item(item_name: String, v: int):
	# Consumes a specific amount of items from the inventory
	if get_items_in_inventory(item_name) >= v:
		var count = 0
		var slots_to_clear = []
		var current_idx = 0
		
		# Identify slots containing the target item
		for i in inventory:
			if i[0] == item_name:
				if count < v:
					slots_to_clear.append(current_idx)
					count += i[1]
			current_idx += 1
		
		# Iterate through identified slots and remove/reduce stacks
		var last_slot_idx = slots_to_clear.size() - 1
		for j in range(slots_to_clear.size()):
			if j != last_slot_idx:
				delete(slots_to_clear[j])
		
		# Handle the remaining quantity in the last processed slot
		var last_idx = slots_to_clear[last_slot_idx]
		inventory[last_idx][1] = count - v
		if inventory[last_idx][1] == 0:
			delete(last_idx)
