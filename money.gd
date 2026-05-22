extends Label

func _ready() -> void:
	Global.Up_money.connect(UP)
	UP()

func UP():
	text = "money: "+str(Global.money)
