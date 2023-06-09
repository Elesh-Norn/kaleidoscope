GDPC                 �                                                                         X   res://.godot/exported/133200997/export-67ebf3113d5492a6388489aa32ae3562-kaleidoscope.scn       f      nM��#j��)CN~*    P   res://.godot/exported/133200997/export-af264238fd56c207f706f08f8043dda4-Main.scn !      �      �	��@�%�%�Kz��<    ,   res://.godot/global_script_class_cache.cfg                 ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�%      ^      2��r3��MgB�[79       res://.godot/uid_cache.bin  E      d       T�����Py��� �,��       res://icon.svg  �4      N      ]��s�9^w/�����       res://icon.svg.import   3      �       �"����	�ߧO��       res://project.binary�E      �      ����!�`N���3       res://src/Main.gd   P      �      �)��t*bx��x       res://src/Main.tscn.remap   P4      a       T�X��bu����O��       res://src/kaleidoscope.gd           �      W��H_�5��~P	Ь    $   res://src/kaleidoscope.tscn.remap   �3      i       #�U���fQ�MژS��    (   res://src/kaleidoscope_script.gdshader  �      �      ���������d��    �"G�v0�2�g��list=Array[Dictionary]([])
�6�@tool
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
�P�~�(�k��4�RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name    shader    shader_parameter/color_speed    shader_parameter/brightness    shader_parameter/complexity    shader_parameter/periodicity    shader_parameter/fractal_force    shader_parameter/a    shader_parameter/b    shader_parameter/c    shader_parameter/d    script 	   _bundled       Shader '   res://src/kaleidoscope_script.gdshader ��������   Script    res://src/kaleidoscope.gd ��������      local://ShaderMaterial_ab6qv �         local://PackedScene_rmumo G         ShaderMaterial                    )   �������?   )   {�G�z�?        @@         A        �?      ��i?��T?�k?	      �t3?���>!�?
      9�?Z�?j�?      w��@j@���?         PackedScene          	         names "   	      Canvas 	   material    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    scale    script 
   ColorRect    	   variants                      �?      
   �B��A               node_count             nodes        ��������       ����                                                        conn_count              conns               node_paths              editable_instances              version             RSRC	+�mU��ushader_type canvas_item;
uniform float color_speed;
uniform float brightness; 
uniform float complexity;
uniform float periodicity;
uniform float fractal_force;
uniform vec3 a;
uniform vec3 b;
uniform vec3 c;
uniform vec3 d;

// This code was made following kishimisu video, go check it out it's awesome.
// https://youtu.be/f4s1h2YETNY

vec3 palette( float t){

	return a + b *cos( 6.28318*(c*t*d));
}
void fragment() {
	vec2 i_resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = (FRAGCOORD.xy *2.0 - i_resolution.xy) / i_resolution.y;
	vec2 uv0 = uv;
	vec3 finalColor = vec3(0.0);
	
	for (float i = 0.0; i < complexity; i++) {
		uv = (fract(uv*fractal_force)-0.5);

		float dist = length(uv) * exp(-length(uv0));
		vec3 col = palette(length(uv0) + i*.4 + TIME *color_speed);
		dist = sin(dist*periodicity + TIME)/periodicity;
		dist = abs(dist);
		dist = pow(brightness/dist, 1.2);
		finalColor += col * dist;
	}
	
	COLOR = vec4(finalColor, 1.0);
	}(H7�*�wa�ڗextends Control

@onready var label = $RichTextLabel
@onready var canvas = $Canvas
var tween: Tween

func _ready():
	canvas.connect("update_text", on_text_update)
	
	
func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		canvas.increase_setting()
	elif Input.is_action_just_pressed("ui_down"):
		canvas.decrease_setting()
	elif Input.is_action_just_pressed("ui_left"):
		canvas.previous_setting()
	elif Input.is_action_just_pressed("ui_right"):
		canvas.next_setting()

func on_text_update(text):
	if tween:
		tween.kill()
	tween = create_tween()
	
	label.modulate = Color.WHITE_SMOKE
	label.text = text
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 2)
	

U�� _KRSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://src/Main.gd ��������   PackedScene    res://src/kaleidoscope.tscn ��aO�l      local://PackedScene_krphw A         PackedScene          	         names "         ControlShader    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    Control    Canvas    RichTextLabel 	   modulate    anchor_top    offset_top    offset_right    text    	   variants                        �?                                    �?  �?  �?         ��    �D             Read Option       node_count             nodes     7   ��������       ����                                                          ���	                           
   
   ����	                                          	      
                   conn_count              conns               node_paths              editable_instances              version             RSRC���vD�l~�GST2   �   �      ����               � �        &  RIFF  WEBPVP8L  /������!"2�H�l�m�l�H�Q/H^��޷������d��g�(9�$E�Z��ߓ���'3���ض�U�j��$�՜ʝI۶c��3� [���5v�ɶ�=�Ԯ�m���mG�����j�m�m�_�XV����r*snZ'eS�����]n�w�Z:G9�>B�m�It��R#�^�6��($Ɓm+q�h��6�4mb�h3O���$E�s����A*DV�:#�)��)�X/�x�>@\�0|�q��m֋�d�0ψ�t�!&����P2Z�z��QF+9ʿ�d0��VɬF�F� ���A�����j4BUHp�AI�r��ِ���27ݵ<�=g��9�1�e"e�{�(�(m�`Ec\]�%��nkFC��d���7<�
V�Lĩ>���Qo�<`�M�$x���jD�BfY3�37�W��%�ݠ�5�Au����WpeU+.v�mj��%' ��ħp�6S�� q��M�׌F�n��w�$$�VI��o�l��m)��Du!SZ��V@9ד]��b=�P3�D��bSU�9�B���zQmY�M~�M<��Er�8��F)�?@`�:7�=��1I]�������3�٭!'��Jn�GS���0&��;�bE�
�
5[I��=i�/��%�̘@�YYL���J�kKvX���S���	�ڊW_�溶�R���S��I��`��?֩�Z�T^]1��VsU#f���i��1�Ivh!9+�VZ�Mr�טP�~|"/���IK
g`��MK�����|CҴ�ZQs���fvƄ0e�NN�F-���FNG)��W�2�JN	��������ܕ����2
�~�y#cB���1�YϮ�h�9����m������v��`g����]1�)�F�^^]Rץ�f��Tk� s�SP�7L�_Y�x�ŤiC�X]��r�>e:	{Sm�ĒT��ubN����k�Yb�;��Eߝ�m�Us�q��1�(\�����Ӈ�b(�7�"�Yme�WY!-)�L���L�6ie��@�Z3D\?��\W�c"e���4��AǘH���L�`L�M��G$𩫅�W���FY�gL$NI�'������I]�r��ܜ��`W<ߛe6ߛ�I>v���W�!a��������M3���IV��]�yhBҴFlr�!8Մ�^Ҷ�㒸5����I#�I�ڦ���P2R���(�r�a߰z����G~����w�=C�2������C��{�hWl%��и���O������;0*��`��U��R��vw�� (7�T#�Ƨ�o7�
�xk͍\dq3a��	x p�ȥ�3>Wc�� �	��7�kI��9F}�ID
�B���
��v<�vjQ�:a�J�5L&�F�{l��Rh����I��F�鳁P�Nc�w:17��f}u}�Κu@��`� @�������8@`�
�1 ��j#`[�)�8`���vh�p� P���׷�>����"@<�����sv� ����"�Q@,�A��P8��dp{�B��r��X��3��n$�^ ��������^B9��n����0T�m�2�ka9!�2!���]
?p ZA$\S��~B�O ��;��-|��
{�V��:���o��D��D0\R��k����8��!�I�-���-<��/<JhN��W�1���(�#2:E(*�H���{��>��&!��$| �~�+\#��8�> �H??�	E#��VY���t7���> 6�"�&ZJ��p�C_j����	P:�~�G0 �J��$�M���@�Q��Yz��i��~q�1?�c��Bߝϟ�n�*������8j������p���ox���"w���r�yvz U\F8��<E��xz�i���qi����ȴ�ݷ-r`\�6����Y��q^�Lx�9���#���m����-F�F.-�a�;6��lE�Q��)�P�x�:-�_E�4~v��Z�����䷳�:�n��,㛵��m�=wz�Ξ;2-��[k~v��Ӹ_G�%*�i� ����{�%;����m��g�ez.3���{�����Kv���s �fZ!:� 4W��޵D��U��
(t}�]5�ݫ߉�~|z��أ�#%���ѝ܏x�D4�4^_�1�g���<��!����t�oV�lm�s(EK͕��K�����n���Ӌ���&�̝M�&rs�0��q��Z��GUo�]'G�X�E����;����=Ɲ�f��_0�ߝfw�!E����A[;���ڕ�^�W"���s5֚?�=�+9@��j������b���VZ^�ltp��f+����Z�6��j�`�L��Za�I��N�0W���Z����:g��WWjs�#�Y��"�k5m�_���sh\���F%p䬵�6������\h2lNs�V��#�t�� }�K���Kvzs�>9>�l�+�>��^�n����~Ěg���e~%�w6ɓ������y��h�DC���b�KG-�d��__'0�{�7����&��yFD�2j~�����ټ�_��0�#��y�9��P�?���������f�fj6͙��r�V�K�{[ͮ�;4)O/��az{�<><__����G����[�0���v��G?e��������:���١I���z�M�Wۋ�x���������u�/��]1=��s��E&�q�l�-P3�{�vI�}��f��}�~��r�r�k�8�{���υ����O�֌ӹ�/�>�}�t	��|���Úq&���ݟW����ᓟwk�9���c̊l��Ui�̸z��f��i���_�j�S-|��w�J�<LծT��-9�����I�®�6 *3��y�[�.Ԗ�K��J���<�ݿ��-t�J���E�63���1R��}Ғbꨝט�l?�#���ӴQ��.�S���U
v�&�3�&O���0�9-�O�kK��V_gn��k��U_k˂�4�9�v�I�:;�w&��Q�ҍ�
��fG��B��-����ÇpNk�sZM�s���*��g8��-���V`b����H���
3cU'0hR
�w�XŁ�K݊�MV]�} o�w�tJJ���$꜁x$��l$>�F�EF�޺�G�j�#�G�t�bjj�F�б��q:�`O�4�y�8`Av<�x`��&I[��'A�˚�5��KAn��jx ��=Kn@��t����)�9��=�ݷ�tI��d\�M�j�B�${��G����VX�V6��f�#��V�wk ��W�8�	����lCDZ���ϖ@���X��x�W�Utq�ii�D($�X��Z'8Ay@�s�<�x͡�PU"rB�Q�_�Q6  e�[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bha80rat48nye"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 yڬJ�7bbT���>p
[remap]

path="res://.godot/exported/133200997/export-67ebf3113d5492a6388489aa32ae3562-kaleidoscope.scn"
	u��y�y[remap]

path="res://.godot/exported/133200997/export-af264238fd56c207f706f08f8043dda4-Main.scn"
�ly޶%1������#�<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><g transform="translate(32 32)"><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99z" fill="#363d52"/><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99zm0 4h96c6.64 0 12 5.35 12 11.99v95.98c0 6.64-5.35 11.99-12 11.99h-96c-6.64 0-12-5.35-12-11.99v-95.98c0-6.64 5.36-11.99 12-11.99z" fill-opacity=".4"/></g><g stroke-width="9.92746" transform="matrix(.10073078 0 0 .10073078 12.425923 2.256365)"><path d="m0 0s-.325 1.994-.515 1.976l-36.182-3.491c-2.879-.278-5.115-2.574-5.317-5.459l-.994-14.247-27.992-1.997-1.904 12.912c-.424 2.872-2.932 5.037-5.835 5.037h-38.188c-2.902 0-5.41-2.165-5.834-5.037l-1.905-12.912-27.992 1.997-.994 14.247c-.202 2.886-2.438 5.182-5.317 5.46l-36.2 3.49c-.187.018-.324-1.978-.511-1.978l-.049-7.83 30.658-4.944 1.004-14.374c.203-2.91 2.551-5.263 5.463-5.472l38.551-2.75c.146-.01.29-.016.434-.016 2.897 0 5.401 2.166 5.825 5.038l1.959 13.286h28.005l1.959-13.286c.423-2.871 2.93-5.037 5.831-5.037.142 0 .284.005.423.015l38.556 2.75c2.911.209 5.26 2.562 5.463 5.472l1.003 14.374 30.645 4.966z" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 919.24059 771.67186)"/><path d="m0 0v-47.514-6.035-5.492c.108-.001.216-.005.323-.015l36.196-3.49c1.896-.183 3.382-1.709 3.514-3.609l1.116-15.978 31.574-2.253 2.175 14.747c.282 1.912 1.922 3.329 3.856 3.329h38.188c1.933 0 3.573-1.417 3.855-3.329l2.175-14.747 31.575 2.253 1.115 15.978c.133 1.9 1.618 3.425 3.514 3.609l36.182 3.49c.107.01.214.014.322.015v4.711l.015.005v54.325c5.09692 6.4164715 9.92323 13.494208 13.621 19.449-5.651 9.62-12.575 18.217-19.976 26.182-6.864-3.455-13.531-7.369-19.828-11.534-3.151 3.132-6.7 5.694-10.186 8.372-3.425 2.751-7.285 4.768-10.946 7.118 1.09 8.117 1.629 16.108 1.846 24.448-9.446 4.754-19.519 7.906-29.708 10.17-4.068-6.837-7.788-14.241-11.028-21.479-3.842.642-7.702.88-11.567.926v.006c-.027 0-.052-.006-.075-.006-.024 0-.049.006-.073.006v-.006c-3.872-.046-7.729-.284-11.572-.926-3.238 7.238-6.956 14.642-11.03 21.479-10.184-2.264-20.258-5.416-29.703-10.17.216-8.34.755-16.331 1.848-24.448-3.668-2.35-7.523-4.367-10.949-7.118-3.481-2.678-7.036-5.24-10.188-8.372-6.297 4.165-12.962 8.079-19.828 11.534-7.401-7.965-14.321-16.562-19.974-26.182 4.4426579-6.973692 9.2079702-13.9828876 13.621-19.449z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 104.69892 525.90697)"/><path d="m0 0-1.121-16.063c-.135-1.936-1.675-3.477-3.611-3.616l-38.555-2.751c-.094-.007-.188-.01-.281-.01-1.916 0-3.569 1.406-3.852 3.33l-2.211 14.994h-31.459l-2.211-14.994c-.297-2.018-2.101-3.469-4.133-3.32l-38.555 2.751c-1.936.139-3.476 1.68-3.611 3.616l-1.121 16.063-32.547 3.138c.015-3.498.06-7.33.06-8.093 0-34.374 43.605-50.896 97.781-51.086h.066.067c54.176.19 97.766 16.712 97.766 51.086 0 .777.047 4.593.063 8.093z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 784.07144 817.24284)"/><path d="m0 0c0-12.052-9.765-21.815-21.813-21.815-12.042 0-21.81 9.763-21.81 21.815 0 12.044 9.768 21.802 21.81 21.802 12.048 0 21.813-9.758 21.813-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 389.21484 625.67104)"/><path d="m0 0c0-7.994-6.479-14.473-14.479-14.473-7.996 0-14.479 6.479-14.479 14.473s6.483 14.479 14.479 14.479c8 0 14.479-6.485 14.479-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 367.36686 631.05679)"/><path d="m0 0c-3.878 0-7.021 2.858-7.021 6.381v20.081c0 3.52 3.143 6.381 7.021 6.381s7.028-2.861 7.028-6.381v-20.081c0-3.523-3.15-6.381-7.028-6.381" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 511.99336 724.73954)"/><path d="m0 0c0-12.052 9.765-21.815 21.815-21.815 12.041 0 21.808 9.763 21.808 21.815 0 12.044-9.767 21.802-21.808 21.802-12.05 0-21.815-9.758-21.815-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 634.78706 625.67104)"/><path d="m0 0c0-7.994 6.477-14.473 14.471-14.473 8.002 0 14.479 6.479 14.479 14.473s-6.477 14.479-14.479 14.479c-7.994 0-14.471-6.485-14.471-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 656.64056 631.05679)"/></g></svg>
�Y   ��aO�l   res://src/kaleidoscope.tscn��B�C}   res://src/Main.tscn ⶸ_�'   res://icon.svg��x"QϑS���ECFG      application/config/name         Kaleidoscope   application/run/main_scene         res://src/Main.tscn    application/config/features(   "         4.0    GL Compatibility       application/config/icon         res://icon.svg  #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility��'�W!