extends Node

const MOD_DIR = "garbobo-Junk/"
const MOD_LOG = "garbobo-Junk"
const config_name = "junk_config"

var dir = ""
var cont_dir = ""
var trans_dir = ""

var junk_settings = {
	"OPT_ENABLE_JUNK":true,
	"OPT_JUNK_LESS":false,
	"OPT_JUNK_ALWAYS":false
}

var ModsConfigInterface = null
var my_config = null

func _init():
	ModLoaderLog.info("Init", MOD_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR
	cont_dir = dir + "content/"
	trans_dir = dir + "translation/"
	ModLoaderMod.install_script_extension(cont_dir + "junk/junk.gd")
	ModLoaderMod.add_translation(trans_dir + "Junk_trans.en.translation")
	ModLoaderMod.add_translation(trans_dir + "Junk_trans.zh.translation")
	call_deferred("init_setting")
	
func _ready():
	ModLoaderLog.info("Done", MOD_LOG)
	junk_settings = load_setting(config_name)
	pass

func init_setting():
	var _error_setting = load_setting(config_name)
	ModsConfigInterface = get_node_or_null("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	if ModsConfigInterface != null:
		for st in junk_settings:
			ModsConfigInterface.on_setting_changed(st,junk_settings[st],MOD_LOG)
		ModsConfigInterface.connect("setting_changed", self, "_setting_changed")

func _setting_changed(setting_name,value,mod_name):
	if mod_name == MOD_LOG:
		junk_settings[setting_name] = value
		save_setting()

func save_setting():
	my_config = ModLoaderConfig.get_config(MOD_LOG,config_name)
	if my_config == null:
		my_config = ModLoaderConfig.create_config(MOD_LOG,config_name,junk_settings)
		var _error2 = ModLoaderConfig.set_current_config(my_config)
	for key in junk_settings:
		my_config.data[key] = junk_settings[key]
	var _error = ModLoaderConfig.update_config(my_config)

func load_setting(_config_name)->Dictionary:
	var config = ModLoaderConfig.get_config(MOD_LOG,config_name)
	if config == null:
		save_setting()
		return junk_settings
	for key in junk_settings:
		junk_settings[key] = config.data[key]
	return junk_settings
