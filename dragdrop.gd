extends Node2D

var selected = false
var rest_point
var rest_nodes = []
var velocity = Vector2.ZERO
var falling = true

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("zone")
	rest_point = rest_nodes[0].global_position
	rest_nodes[0].select()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		selected = true
		falling = false
		velocity = Vector2.ZERO  # reset kecepatan saat dipegang

func _physics_process(delta):
	if selected:
		# Ikuti kursor dengan pergerakan halus
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	elif not falling:
		# Kembali ke rest_point jika sedang tidak jatuh dan tidak diseleksi
		global_position = lerp(global_position, rest_point, 10 * delta)
	else:
		# Tidak ada lagi jatuh, karena kita set falling = false saat dilepas
		pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
			var nearest_zone = null
			var shortest_dist = 75

			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_dist:
					shortest_dist = distance
					nearest_zone = child

			if nearest_zone:
				nearest_zone.select()
				rest_point = nearest_zone.global_position
				falling = false
			else:
				# Tidak ada zona terdekat -> objek hanya stay/melayang di tempat
				rest_point = global_position  # stay di tempat terakhir
				falling = false
				velocity = Vector2.ZERO
