extends "res://main.gd"

# Brief overview of what the changes in this file do...

const MYMOD_LOG = "garbobo-Boxer" # ! Change `MODNAME` to your actual mod's name
const BoxerOptions = preload("res://mods-unpacked/garbobo-Boxer/mod_options.gd")

# Extensions
# =============================================================================

func _ready()->void:
	# ! Note that we're *not* calling `.return` here. This is because, unlike
	# ! all other vanilla funcs (eg `get_gold_bag_pos` below), _ready will
	# ! always fire, regardless of your code. In all other cases, we would still
	# ! need to call it

	# ! Note that you won't see this in the log immediately, because main.gd
	# ! doesn't run until you start a run
	var _error_enable = ModLoaderUserProfile.enable_mod(MYMOD_LOG)
	ModLoaderUtils.log_info("Ready", MYMOD_LOG)

	# ! These are custom functions. It will run after vanilla's own _ready is
	# ! finished
	_modname_my_custom_edit_1()
	_modname_my_custom_edit_2()
	
	# var options_node = BoxerOptions.new()
	# options_node.set_name("BoxerOptions")
	# $"/root".add_child(options_node)
	
	# var direct_signal = true
	
	# if $"/root/ModLoader".has_node("dami-ModOptions"):
		# var mod_configs = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface").mod_configs
		# if mod_configs.has("garbobo-Boxer"):
			# direct_signal = false
			# ModsConfigInterface = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
			# ModsConfigInterface.connect("setting_changed", self, "on_setting_changed")
	
	# if direct_signal:
		# var options_node = $"/root/BoxerOptions"
		# options_node.connect("setting_changed", self, "on_setting_changed")

# func on_setting_changed(_setting_name:String, _value, _mod_name):
	# var options_node = $"/root/BoxerOptions"
	# options_node.load_mod_options()
	# print("settings changed")
	# var boxer_enabled = options_node.enable_boxer
	# if boxer_enabled:
		# print("true ----")
	# else:
		# print("false ----")


# This is the name of a func in vanilla
func get_gold_bag_pos()->Vector2:
	# ! This calls vanilla's version of this func. The period (.) before the
	# func lets you call it without triggering an infinite loop. In this case,
	# we're calling the vanilla func to get the original value; then, we can
	# modify it to whatever we like
	var gold_bag_pos = .get_gold_bag_pos()

	# ! If a vanilla func returns something (just as this one returns a Vector2),
	# ! your modded funcs should also return something with the same type
	return gold_bag_pos


# Custom
# =============================================================================

func _modname_my_custom_edit_1()->void: # ! `void` means it doesn't return anything
	pass # ! Using `pass` here allows you to have a empty func without causing errors


func _modname_my_custom_edit_2()->void:
	ModLoaderUtils.log_info("Main.gd has been modified", MYMOD_LOG)