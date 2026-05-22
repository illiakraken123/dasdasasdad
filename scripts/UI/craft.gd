extends Control

@export var nic = "craft"

func _ready() -> void:
	Global.show_UI.connect(SUI)
	Global.hide_UI.connect(HUI)
	Global.hide_all_UI.connect(HAUI)

func SUI(n):
	if nic==n:
		show()

func HUI(n):
	if nic==n:
		hide()

func HAUI():
	hide()
