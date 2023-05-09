extends HBoxContainer


signal is_active_toggled(mod_id, is_active)

export(Color) var color_error = Color.indianred
export(Color) var color_mandatory = Color.darkgray
enum CONTROL_TYPES { ACTIVE_TOGGLE, CONFIG_SELECTION }
export(CONTROL_TYPES) var current_control_type

var mod_id := "" setget _set_mod_id
var is_active: bool setget _set_is_active
var is_disabled := false setget _set_is_disabled

onready var mod_id_label = $"%ModID"
onready var check_box = $"%CheckBox"
onready var config_selection = $"%ConfigSelection"


func set_error_color() -> void:
	_set_label_color(color_error)


func set_mandatory_color() -> void:
	_set_label_color(color_mandatory)


func _set_label_color(color: Color) -> void:
	mod_id_label.add_color_override("font_color", color)


func _set_mod_id(new_mod_id: String) -> void:
	mod_id = new_mod_id
	mod_id_label.text = new_mod_id
	populate_current_config_selection(new_mod_id)


func populate_current_config_selection(mod_id: String) -> void:
	var configs := ModLoaderConfig.get_mod_configs(mod_id)
	for config in configs:
		config_selection.add_item(config.name)


func _set_is_active(new_is_active: bool) -> void:
	is_active = new_is_active
	check_box.pressed = new_is_active


func _set_is_disabled(new_is_disabled: bool) -> void:
	is_disabled = is_disabled
	check_box.disabled = new_is_disabled


func _on_CheckBox_toggled(button_pressed):
	is_active = button_pressed


func _on_CheckBox_pressed():
	emit_signal("is_active_toggled", mod_id, is_active)
