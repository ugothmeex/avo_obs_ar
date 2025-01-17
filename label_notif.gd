extends Label
# label_notif.tscn



func _msg(st:String,tim:float = 3.0):
	text = st
	var tw = create_tween().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self,"position:y",position.y-60,tim)
	tw.tween_property(self,"modulate:a",0.0,0.2)
	await tw.finished
	queue_free()
	
