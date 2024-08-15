extends Node 

var dir = ""
var my_mod_name = "garbobo-Boxer"
func _init(dirs):
	name = "mod_options"
	dir = dirs

var ModsConfigInterface = null

var OPT_settings = {
	"OPT_ENABLE_BOXER":true,
}

var my_config = null
const my_config_name = "opt_config"

func _ready():
	OPT_settings = load_setting(my_config_name)
	call_deferred("init")
	
func init():
	if check_dependencies():
		call_deferred("init_setting")

var mods_options_ok = true

func check_dependencies():
	var mods_options =  get_mod_by_name("dami-ModOptions")
	if mods_options == null :
		mods_options_ok = false 
	else:
		if ProgressData.VERSION.left(1) == "1":
			var manifest = mods_options.manifest.version_number
			if manifest == "0.3.1":
				mods_options_ok = false 
			else:
				mods_options_ok = true 
		else:
			mods_options_ok = true 
	return mods_options_ok

func get_mod_by_name(mod_name=""): #Credit: signalApi
	var modloader = null
	if ProgressData.VERSION.left(1) == "0":
		modloader = get_node("/root/ModLoader")
	else:
		modloader = get_node("/root/ModLoaderStore")

	for mod in modloader.mod_load_order:
		if mod is ModData:
			if mod.dir_name.ends_with(mod_name):
				return mod
	return null

func init_setting():
	var _error_setting = load_setting(my_config_name)
	ModsConfigInterface = get_node_or_null("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	if ModsConfigInterface != null:
		for st in OPT_settings:
			ModsConfigInterface.on_setting_changed(st,OPT_settings[st],my_mod_name)
		ModsConfigInterface.connect("setting_changed", self, "_setting_changed")
	else:
		print_debug("ModsConfigInterface not Found")

func _setting_changed(setting_name,value,mod_name):
	if mod_name == my_mod_name:
		OPT_settings[setting_name] = value
		save_setting()
		if RunData.current_character == null:
			if value == true:
				ProgressData.characters_unlocked.append("character_boxer")
				ProgressData.weapons_unlocked.append("weapon_boxing")
			if value == false:
				ProgressData.characters_unlocked.erase("character_boxer")
				ProgressData.weapons_unlocked.erase("weapon_boxing")
			get_tree().reload_current_scene()

func save_setting():
	my_config = ModLoaderConfig.get_config(my_mod_name,my_config_name)
	if my_config == null:
		my_config = ModLoaderConfig.create_config(my_mod_name,my_config_name,OPT_settings)
		var _error2 = ModLoaderConfig.set_current_config(my_config)
	for key in OPT_settings:
		my_config.data[key] = OPT_settings[key]
	var _error = ModLoaderConfig.update_config(my_config)

func load_setting(_my_config_name)->Dictionary:
	var config = ModLoaderConfig.get_config(my_mod_name,my_config_name)
	if config == null:
		save_setting()
		return OPT_settings
	for key in OPT_settings:
		OPT_settings[key] = config.data[key]
		if config.data[key] == false:
			ProgressData.characters_unlocked.erase("character_boxer")
			ProgressData.weapons_unlocked.erase("weapon_boxing")
	return OPT_settings
