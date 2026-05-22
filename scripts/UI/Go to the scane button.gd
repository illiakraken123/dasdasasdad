extends TextureButton

@export var nic = "sca_1"

func _pressed() -> void:
	get_tree().current_scene.get_node("поверх").load_scane(nic)
	Global.hide_UI.emit("craft")
