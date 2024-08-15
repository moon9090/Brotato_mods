extends "res://main.gd"

func _ready():
	# Determine whether to spawn junk
	var ModsConfigInterface = get_node_or_null("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	var junk_enabled = ModsConfigInterface.mod_configs["garbobo-Junk"]["OPT_ENABLE_JUNK"]
	var junk_less = ModsConfigInterface.mod_configs["garbobo-Junk"]["OPT_JUNK_LESS"]
	var junk_always = ModsConfigInterface.mod_configs["garbobo-Junk"]["OPT_JUNK_ALWAYS"]
	if junk_enabled == true:
		var toggle = randi() % 3
		# toggle = 1 #debug
		if toggle != 0 and junk_less == false:
			spawn_junk(toggle)
		elif toggle == 2 and junk_less == true:
			spawn_junk(toggle)
		elif junk_always == true:
			spawn_junk(toggle)

func spawn_junk(toggle):
	var junk_dir = "res://mods-unpacked/garbobo-Junk/content/junk/"
	var ld = 15.0
	var ad = 10.0
	var m = 50.0
	var b = 0
	var junk_layers = 128
	var junk_masks = 128
	var maxx = $EntitySpawner._zone_max_pos.x
	var maxy = $EntitySpawner._zone_max_pos.y
	var junk_size = Vector2(100, 100)
	var junk_rigid = RigidBody2D.new()
	var junk_collision = CollisionShape2D.new()
	var junk_texture = Sprite.new()
	var junk_shape = RectangleShape2D.new()
	var junk_shader = load(junk_dir + "shaders/junk_outline.gdshader")
	var selector = randi() % 6
	# var selector = 0 #debug

	# Randomly select junk
	# Porta potty:
	if selector == 0:
		junk_texture.texture = load(junk_dir + "sprites/porta.png")
		junk_layers = 154
	# Merry-go-round: can be slid but not rotated
	if selector == 1:
		junk_texture.texture = load(junk_dir + "sprites/merry.png")
		junk_rigid.mode = RigidBody2D.MODE_CHARACTER
	# Old car: stationary object
	if selector == 2:
		junk_texture.texture = load(junk_dir + "sprites/car.png")
		junk_rigid.mode = RigidBody2D.MODE_STATIC
	# Beach ball: lightweight and bouncy
	if selector == 3:
		junk_texture.texture = load(junk_dir + "sprites/beach.png")
		ld = 0.3
		ad = 0.1
		m = 1.0
		b = 0.9
	# Teddy bear: cuddly, variable size
	if selector == 4:
		junk_texture.texture = load(junk_dir + "sprites/bear.png")
		if toggle == 1:
			#Teddy's giant aspect 
			junk_texture.scale = Vector2(1.5, 1.5)
			junk_size = Vector2(150, 150)
		if toggle == 2:
			#Teddy's tiny aspect
			junk_texture.scale = Vector2(0.5, 0.5)
			junk_size = Vector2(50, 50)
			m = 1.0
		junk_layers = 154
	# Boudly: BFF
	if selector == 5:
		junk_texture.texture = load(junk_dir + "sprites/bouldy.png")
		junk_layers = 154

	# Assemble junk child
	junk_texture.material = ShaderMaterial.new()
	junk_texture.material.shader = junk_shader
	junk_shape.extents = junk_size
	junk_collision.shape = junk_shape
	junk_rigid.add_child(junk_texture)
	junk_rigid.add_child(junk_collision)
	junk_rigid.position.x = rand_range(250, maxx-250)
	junk_rigid.position.y = rand_range(100, maxy-100)
	junk_rigid.set_collision_layer(junk_layers)
	junk_rigid.set_collision_mask(junk_masks)
	junk_rigid.linear_damp = ld
	junk_rigid.angular_damp = ad
	junk_rigid.mass = m
	junk_rigid.bounce = b
	add_child(junk_rigid)
