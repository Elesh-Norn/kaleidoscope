@tool
extends ColorRect

# Different settings you can tweak to alter the visualisation.
enum settings {COMPLEXITY, PERIODICITY, FRACTAL_FORCE, COLOR_SPECTRUM, COLOR_SPEED, BRIGHTNESS}
enum spectrum {EMBER, RAINBOW, BMO, GBO, YMC, RANDOM}
# Counters to use iterating on settings above
var active_setting: int = 0
var active_spectrum: int = 0

# Affect how fast colors will change amongst their possible values
var color_speed: float = 0.1
# Affect the contrast and brightness
var brightness: float = 0.01
# How many iterations of our script will be ran, create more forms
var complexity: float = 3.0
# Affect pattern generation
var periodicity: float = 8.0
# Affect how strong the fractal effect will be
var fractal_force: float = 1.5


# These parameters are used in a function to modify the colors.
# Presets below are mostly from http://dev.thi.ng/gradients/
var color_presets = {
	spectrum.EMBER: [Vector3(0.914, 0.832, 0.920), Vector3(0.701, 0.468, 0.573), Vector3(0.534, 1.034, 1.222), Vector3(5.992, 2.194, 1.858)],
	spectrum.RAINBOW: [Vector3(0.500, 0.500, 0.500), Vector3(0.500, 0.500, 0.500), Vector3(1.000, 1.000, 1.000), Vector3(0.000, 0.333, 0.667)],
	spectrum.BMO: [Vector3(0.938, 0.328, 0.718), Vector3(0.659, 0.438, 0.328), Vector3(0.388, 0.388, 0.296), Vector3(2.538, 2.478, 0.168)],
	spectrum.GBO: [Vector3(0.892, 0.725, 0.000), Vector3(0.878, 0.278, 0.725), Vector3(0.332, 0.518, 0.545), Vector3(2.440, 5.043, 0.732)],
	spectrum.YMC: [Vector3(1.000, 0.500, 0.500), Vector3(0.500, 0.500, 0.500), Vector3(0.750, 1.000, 0.667), Vector3(0.800, 1.000, 0.333)],
	}

var a: Vector3 = color_presets[spectrum.EMBER][0]
var b: Vector3 = color_presets[spectrum.EMBER][1]
var c: Vector3 = color_presets[spectrum.EMBER][2]
var d: Vector3 = color_presets[spectrum.EMBER][3]

signal update_text(message)

func _ready():
	active_setting = settings.COMPLEXITY
	emit_signal("update_text", settings.keys()[active_setting])
	update_shader()

func update_shader():
	material.set("shader_parameter/color_speed", color_speed)
	material.set("shader_parameter/brightness", brightness)
	material.set("shader_parameter/complexity", complexity)
	material.set("shader_parameter/periodicity", periodicity)
	material.set("shader_parameter/fractal_force", fractal_force)
	material.set("shader_parameter/a", a)
	material.set("shader_parameter/b", b)
	material.set("shader_parameter/c", c)
	material.set("shader_parameter/d", d)

func set_color_spectrum(color_preset) -> void:
	emit_signal("update_text", spectrum.keys()[color_preset])
	if color_preset == spectrum.RANDOM:
		randomize()
		a = Vector3( randf_range(-PI, +PI), randf_range(-PI, +PI), randf_range(-PI, +PI))
		b = Vector3( randf_range(-PI, +PI), randf_range(-PI, +PI), randf_range(-PI, +PI))
		c = Vector3( randf_range(-PI, +PI), randf_range(-PI, +PI), randf_range(-PI, +PI))
		d = Vector3( randf_range(-PI, +PI), randf_range(-PI, +PI), randf_range(-PI, +PI))
	else:
		a = color_presets[color_preset][0]
		b = color_presets[color_preset][1]
		c = color_presets[color_preset][2]
		d = color_presets[color_preset][3]

func increase_setting():
	var max:bool = false 
	if active_setting == settings.COLOR_SPEED:
		if color_speed < 1:
			color_speed += 0.1
		else:
			max = true
	elif active_setting == settings.COMPLEXITY:
		if complexity < 10:
			complexity += 1
		else:
			max = true
	elif active_setting == settings.BRIGHTNESS:
		if brightness < 0.08:
			brightness += 0.005
		else:
			max = true
	elif active_setting == settings.PERIODICITY:
		if periodicity < 50.0:
			periodicity += 1.0
		else:
			max = true
	elif active_setting == settings.FRACTAL_FORCE:
		if fractal_force < 20.0:
			fractal_force += 0.1
		else:
			max = true
	elif active_setting == settings.COLOR_SPECTRUM:
		active_spectrum += 1
		active_spectrum = active_spectrum % spectrum.size()
		set_color_spectrum(active_spectrum)
		update_shader()
		return
	
	update_shader()
	if max:
		emit_signal("update_text", "Max Reached")
	else:
		emit_signal("update_text", str(settings.keys()[active_setting], " increased"))
	
	
func decrease_setting():
	var min = false
	if active_setting == settings.COLOR_SPEED:
		if color_speed > 0:
			color_speed -= 0.1
		else:
			min = true
	elif active_setting == settings.COMPLEXITY:
		if complexity > 1:
			complexity -= 1
		else:
			min = true
	elif active_setting == settings.BRIGHTNESS:
		if brightness > 0:
			brightness -= 0.001
		else:
			min = true
	elif active_setting == settings.PERIODICITY:
		if periodicity > 0.0:
			periodicity -= 1.0
		else:
			min = true
	elif active_setting == settings.FRACTAL_FORCE:
		if fractal_force > 0.0:
			fractal_force -= 0.1
		else:
			min = true
	elif active_setting == settings.COLOR_SPECTRUM:
		active_spectrum -= 1 
		active_spectrum = (active_spectrum + settings.size())  % spectrum.size()
		set_color_spectrum(active_spectrum)
		update_shader()
		return
	
	update_shader()
	if min:
		emit_signal("update_text", "Min Reached")
	else:
		emit_signal("update_text", str(settings.keys()[active_setting], " decreased"))

func next_setting():
	active_setting += 1 
	active_setting = active_setting % settings.size()
	emit_signal("update_text", settings.keys()[active_setting])

func previous_setting():
	active_setting = (active_setting - 1 + settings.size())
	active_setting = active_setting % settings.size()
	emit_signal("update_text", settings.keys()[active_setting])
