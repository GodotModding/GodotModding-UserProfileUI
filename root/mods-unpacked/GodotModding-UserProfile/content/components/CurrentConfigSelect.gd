class_name CurrentConfigSelect
extends OptionButton


signal current_config_selected(mod_id, config_name)

var mod_id: String
var config_names := {}


func add_mod_configs(mod_configs: Array) -> void:
	var index := 0
	for config in mod_configs:
		config_names[config.name] = index
		self.add_item(config.name)
		index = index + 1


func select_item(item_text: String) -> void:
	self.select(config_names[item_text])


func _on_CurrentConfigSelect_item_selected(index) -> void:
	emit_signal("current_config_selected", mod_id, self.get_item_text(index))
