extends Node

const MOD_DIR = "garbobo-Boxer/"
const MOD_LOG = "garbobo-Boxer"

var dir = ""
var cont_dir = ""
var ext_dir = ""
var trans_dir = ""

func _init():
	ModLoaderLog.info("Init", MOD_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR
	cont_dir = dir + "content/"
	trans_dir = dir + "translation/"
	ext_dir = dir + "extensions/"
	ModLoaderMod.add_translation(trans_dir + "boxer_trans.en.translation")
	ModLoaderMod.add_translation(trans_dir + "boxer_trans.zh.translation")
	
func _ready():
	ModLoaderLog.info("Done", MOD_LOG)
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	ContentLoader.load_data(dir + "content_data/boxer_content.tres", MOD_LOG)
	var OPT_monitor = load(dir + "mod_options.gd").new(dir)
	ProgressData.add_child(OPT_monitor)
