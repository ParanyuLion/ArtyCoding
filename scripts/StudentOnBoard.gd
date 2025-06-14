extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str("Student On Board: ",Global.student_on_bus)
	
