extends Node

var item = ["_",0]

# Stores item IDs and their texture paths
var icons : Dictionary = { 
	"_" : load("res://icons/null.png"),
	"листок" : load("res://icons/листок.png"),
	"відро" : load("res://icons/відро води.png"),
	"цукор" : load("res://icons/цукор.png"),
	"пробірка(солона)" : load("res://icons/пробірка(солона_вода).png")
}

 # Max stack size for each item
var staks : Dictionary = {
	"_" : 0,
	"листок" : 999999999999999999,
	"відро" : 999999999999999999,
	"цукор" : 999999999999999999,
	"пробірка(солона)" : 999999999999999999,
}

# Current content of each inventory
var inventorys : Dictionary = {
	"player" : [],
	
	"colbain" : [],
	"colbaout" : [],
}

# Blacklist: Items that ARE NOT ALLOWED in specific inventories
# Example: if "gold" is in "chest", player cannot put gold into that chest.
var no_items : Dictionary = {
	"player" : [],
	
	"colbain" : [],
	"colbaout" : [],
}

# Size (slot count) for each inventory
var size_inventory : Dictionary = {
	"player" : 2,
	
	"colbain" : 2,
	"colbaout" : 1,
}

# Items that cannot be dropped from the inventory (Drop Protection)
var locked_items : Dictionary = {
	"player" : [],
	
	"colbain" : [],
	"colbaout" : [],
}

var ids_crafters : Array = [
	[  [ ["відро","цукор"],["пробірка(солона)"],5 ]  ],
]
