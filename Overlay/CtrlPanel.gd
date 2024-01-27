extends Panel

@export var status: RichTextLabel

enum Status {
	Up,
	Down,
}

func set_status(vision_stream: Status):
	if status:
		status.clear()
	status.append_text('Vision: ')
	match vision_stream:
		Status.Up: status.append_text('[color=green]UP[/color]')
		Status.Down: status.append_text('[color=red]DOWN[/color]')
	status.append_text('\nSpeed: ')
	status.append_text(str(Input.get_axis("Adjust Speed (-)", "Adjust Speed (+)")+1.0))

# Called when the node enters the scene tree for the first time.
func _ready():
	set_status(Status.Down)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Core.visionStreamUp: set_status(Status.Up)
	else: set_status(Status.Down)
	pass
