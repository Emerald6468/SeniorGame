@tool
extends MeshInstance3D

@export var size = 1
@export var size_x = 1
@export var size_z = 1
@export var height = 1
#@export var material: Material
#@export var height: Texture2D
@export var map: Texture2D

@export_tool_button("Generate") var button = generate
@export_tool_button("Create Map") var button2 = create_map

func _ready() -> void:
	generate()

func generate():
	mesh = ArrayMesh.new()
	var image = map.get_image()
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	#for i in vertex_array.size():
		#var vertex = vertex_array[i]
		#st.add_vertex(Vector3(vertex.x, image.get_noise_2d(vertex.x, vertex.z)*height, vertex.z))
	
	for step_h in range(size_x):
		for step_v in range(size_z):
			st.add_vertex(Vector3(0 + (size * step_h), image.get_pixel(0 + step_h, 0 + step_v).get_luminance() * height, 0 + (size * step_v)))
			st.add_vertex(Vector3(size + (size * step_h), image.get_pixel(1 + step_h, 0 + step_v).get_luminance() * height, 0 + (size * step_v)))
			st.add_vertex(Vector3(size + (size * step_h), image.get_pixel(1 + step_h, 1 + step_v).get_luminance() * height, size + (size * step_v)))
			
			st.add_vertex(Vector3(size + (size * step_h), image.get_pixel(1 + step_h, 1 + step_v).get_luminance() * height, size + (size * step_v)))
			st.add_vertex(Vector3(0 + (size * step_h), image.get_pixel(0 + step_h, 1 + step_v).get_luminance() * height, size + (size * step_v)))
			st.add_vertex(Vector3(0 + (size * step_h), image.get_pixel(0 + step_h, 0 + step_v).get_luminance() * height, 0 + (size * step_v)))

	st.index()
	st.generate_normals()
	st.commit(mesh)

func create_map():
	var new_img = Image.create_empty(size_x + 1, size_z + 1, false, Image.FORMAT_RGB8)
	new_img.fill(Color.BLACK)
	var new_img_tex = ImageTexture.create_from_image(new_img)
	map = new_img_tex
