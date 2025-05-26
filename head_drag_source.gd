extends TextureRect

var original_position: Vector2
var dragging := false

func _get_drag_data(at_position):
	original_position = position
	dragging = true

	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(30, 30)

	var preview = Control.new()
	preview.add_child(preview_texture)

	set_drag_preview(preview)

	call_deferred("_on_drag_end")  # Panggil fungsi async setelah frame berjalan

	return texture


func _can_drop_data(_pos, data):
	# Source ini tidak menerima drop
	return false

func _drop_data(_pos, data):
	texture = data
	# Beri sinyal ke sumber bahwa drop berhasil
	var source = get_viewport().gui_get_drag_data_source()
	if source:
		source.dragging = false  # Tidak digunakan di sini


func _on_drag_end() -> void:
	await get_tree().process_frame
	if dragging:
		position = original_position
