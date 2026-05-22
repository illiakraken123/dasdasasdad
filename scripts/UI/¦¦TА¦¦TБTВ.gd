extends Button

func _pressed() -> void:
	Global.hide_all_UI.emit()
