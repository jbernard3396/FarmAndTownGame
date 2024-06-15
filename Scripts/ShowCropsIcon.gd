extends AnimatedSprite2D


func _on_menu_button_button_mouse_entered():
	transform.x *= 1.1
	transform.y *= 1.1

func _on_menu_button_button_mouse_exited():
	transform.x *= 1/1.1
	transform.y *= 1/1.1
	

func _on_menu_button_button_button_up():
	frame = 0


func _on_menu_button_button_button_down():
	if sprite_frames.get_frame_count(sprite_frames.get_animation_names()[0]) < 1:
		return
	frame = 1
