extends WindowDialog


export(PackedScene) var user_profile_section: PackedScene
export(String) var text_restart := "A game restart is required to apply the settings"
export(String) var text_profile_create_error := "There was an error creating the profile - check logs"
export(String) var text_profile_select_error := "There was an error selecting the profile - check logs"
export(String) var text_profile_delete_error := "There was an error deleting the profile - check logs"
export(String) var text_mod_enable_error := "There was an error enabling the mod - check logs"
export(String) var text_mod_disable_error := "There was an error disabling the mod - check logs"
export(String) var text_current_profile := " (Current Profile)"

onready var user_profile_sections := $"%UserProfileSections"
onready var profile_select = $"%ProfileSelect"
onready var popup_new_profile = $"%PopupNewProfile"
onready var input_profile_name = $"%InputProfileName"
onready var button_profile_name_submit = $"%ButtonProfileNameSubmit"
onready var button_new_profile = $"%ButtonNewProfile"
onready var mod_list = $"%ModList"
onready var info_text = $"%InfoText"


func _ready() -> void:
	_populate_profile_select()
	_generate_user_profile_section()


func _input(event) -> void:
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_U:
			popup_centered() if not visible else hide()


func _update_ui() -> void:
	# Update the profile select list
	_populate_profile_select()

	# Update the Setting list
	_generate_user_profile_section()

func _populate_profile_select() -> void:
	var index_current_profile: int

	profile_select.clear()

	for user_profile in ModLoaderUserProfile.get_all_as_array():
		var is_current_profile := true if ModLoaderStore.current_user_profile == user_profile.name else false
		profile_select.add_item(user_profile.name + text_current_profile if is_current_profile else user_profile.name)

		# Get the item index of the current profile
		if is_current_profile:
			index_current_profile = profile_select.get_item_count() - 1

	# Select current profile
	profile_select.select(index_current_profile)


func _generate_user_profile_section() -> void:
	mod_list.clear_mod_list()
	mod_list.generate_mod_list(ModLoaderUserProfile.get_current())


func _on_ButtonNewProfile_pressed() -> void:
	popup_new_profile.popup_centered()


func _on_ButtonDeleteProfile_pressed():
	var profile_to_delete := ModLoaderStore.current_user_profile
	# Switch to default profile
	if not ModLoaderUserProfile.set_profile("default"):
		info_text.text = text_profile_select_error
		return
	# Delete the profile
	if not ModLoaderUserProfile.delete_profile(profile_to_delete):
		info_text.text = text_profile_delete_error
		return

	_update_ui()


func _on_ButtonProfileNameSubmit_pressed() -> void:
	# Create new User Profile
	if not ModLoaderUserProfile.create_profile(input_profile_name.text):
		# If there was an error creating the profile
		# Add error message to the info text label
		info_text.text = text_profile_create_error
		# And return early
		return

	_update_ui()

	# Close popup
	popup_new_profile.hide()


func _mod_is_active_changed(mod_id: String, is_active: bool) -> void:
	if is_active:
		if not ModLoaderUserProfile.enable_mod(mod_id):
			info_text.text = text_mod_enable_error
			return
	else:
		if not ModLoaderUserProfile.disable_mod(mod_id):
			info_text.text = text_mod_disable_error
			return

	info_text.text = text_restart


func _on_ProfileSelect_item_selected(index: int) -> void:
	if not ModLoaderUserProfile.set_profile(profile_select.get_item_text(index)):
		info_text.text = text_profile_select_error
		return

	_update_ui()

	info_text.text = text_restart
