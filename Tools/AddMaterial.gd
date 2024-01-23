# TODO(drakeerv): Please document this
@tool
extends EditorScript

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var editor_interface = get_editor_interface()
	var material_path = editor_interface.get_current_path()
	var material = ResourceLoader.load(material_path)
	
	for node in editor_interface.get_selection().get_selected_nodes():
		if node is MeshInstance3D:
			node.material_override = material
			
	editor_interface.mark_scene_as_unsaved()
