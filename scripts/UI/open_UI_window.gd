extends TextureButton

@export var nic = "craft"
@export var inv = true

func _pressed() -> void:
	Global.hide_all_UI.emit()
	Global.show_UI.emit(nic)
	if inv:
		Global.show_UI.emit("inventory")
