extends Node


var KANA_User_Profile_MOD_DIR := "KANA-UserProfile"
var KANA_User_Profile_LOG_NAME := "KANA-UserProfile"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


func _init(modLoader = ModLoader) -> void:
	ModLoaderUtils.log_info("Init", KANA_User_Profile_LOG_NAME)
	mod_dir_path = modLoader.UNPACKED_DIR.plus_file(KANA_User_Profile_MOD_DIR)

	# Add extensions
	install_script_extensions(modLoader)

	# Add translations
	add_translations(modLoader)


func install_script_extensions(modLoader) -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")


func add_translations(modLoader) -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")


func _ready():
	var user_profile_dialog = load("res://mods-unpacked/KANA-UserProfile/content/UserProfiles.tscn").instance()
	get_tree().root.call_deferred("add_child", user_profile_dialog)
