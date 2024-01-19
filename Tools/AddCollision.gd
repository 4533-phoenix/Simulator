@tool
extends EditorScript

func get_all_children(node: Node) -> Array:
	var nodes : Array = []

	for child in node.get_children():
		if child.get_child_count() > 0:
			nodes.append(child)
			nodes.append_array(get_all_children(child))
		else:
			nodes.append(child)

	return nodes

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var editor_interface = get_editor_interface()
	var editor_selection = editor_interface.get_selection()
	
	for node in editor_selection.get_selected_nodes():
		var children = get_all_children(node)
		
		editor_selection.remove_node(node)
		
		for child in children:
			if child is CollisionShape3D:
				var parent: Node = child.get_parent()
				if not parent is StaticBody3D:
					editor_selection.add_node(parent)
