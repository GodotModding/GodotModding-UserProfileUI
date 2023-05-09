class_name ModIdLabel
extends Label


export(Color) var color_error = Color.indianred
export(Color) var color_mandatory = Color.darkgray

var mod_id: String


func set_error_color() -> void:
	_set_label_color(color_error)


func set_mandatory_color() -> void:
	_set_label_color(color_mandatory)


func _set_label_color(color: Color) -> void:
	self.add_color_override("font_color", color)
