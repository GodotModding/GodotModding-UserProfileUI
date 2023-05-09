extends MarginContainer


signal mod_is_active_changed(mod_id, is_active)

export(PackedScene) var mod_list_mod
export(String) var section_name := "" setget _set_section_name

onready var label_section_name := $"%SectionName"
onready var mod_list = $"%ModLists"


func _set_section_name(new_name: String) -> void:
	section_name = new_name
	if label_section_name:
		label_section_name.text = new_name


func generate_mod_list(user_profile: ModLoaderUserProfile.Profile) -> void:
	for mod_id in user_profile.mod_list.keys():
		var new_mod_list_mod: HBoxContainer = mod_list_mod.instance()

		new_mod_list_mod.connect("is_active_toggled", self, "_on_mod_is_active_toggled")
		mod_list.add_child(new_mod_list_mod)
		new_mod_list_mod.mod_id = mod_id
		new_mod_list_mod.is_active = user_profile.mod_list[mod_id].is_active

		if ModLoaderStore.mod_data.has(mod_id):
			var mod: ModData = ModLoaderStore.mod_data[mod_id]

			# Check if mod is locked
			if mod.is_locked:
				# Disable the checkbox if it is
				new_mod_list_mod.is_disabled = true
				new_mod_list_mod.set_mandatory_color()

			# Check if the mod is loadable
			if not mod.is_loadable:
				new_mod_list_mod.set_error_color()


func clear_mod_list() -> void:
	for child in mod_list.get_children():
		mod_list.remove_child(child)
		child.free()

func _on_mod_is_active_toggled(mod_id: String, is_active: bool) -> void:
	emit_signal("mod_is_active_changed", mod_id, is_active)
