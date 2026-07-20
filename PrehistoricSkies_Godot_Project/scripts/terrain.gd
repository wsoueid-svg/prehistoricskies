extends Node3D

@export var terrain_size: float = 960.0
@export var resolution: int = 121
@export var max_height: float = 105.0
@export var water_level: float = 5.0

var noise := FastNoiseLite.new()
var detail_noise := FastNoiseLite.new()
var rng := RandomNumberGenerator.new()

func _ready() -> void:
    noise.seed = 72641
    noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
    noise.frequency = 0.0036
    noise.fractal_octaves = 5
    noise.fractal_gain = 0.48
    noise.fractal_lacunarity = 2.15
    detail_noise.seed = 9834
    detail_noise.noise_type = FastNoiseLite.TYPE_PERLIN
    detail_noise.frequency = 0.018
    detail_noise.fractal_octaves = 3
    rng.seed = 773
    _build_terrain()
    _build_water()
    _scatter_vegetation()
    _scatter_rocks()

func sample_height(x: float, z: float) -> float:
    var dist := Vector2(x, z).length() / (terrain_size * 0.53)
    var island_mask := clamp(1.0 - pow(dist, 2.35), -0.25, 1.0)
    var large := noise.get_noise_2d(x, z) * 0.56 + 0.44
    var ridges := abs(detail_noise.get_noise_2d(x * 0.45, z * 0.45))
    var mountains := pow(clamp(large, 0.0, 1.0), 1.65) * max_height
    var h := mountains * island_mask + ridges * 13.0 * island_mask
    h -= pow(max(dist - 0.73, 0.0), 1.3) * 190.0
    return h - 17.0

func _build_terrain() -> void:
    var vertices := PackedVector3Array()
    var normals := PackedVector3Array()
    var colors := PackedColorArray()
    var uvs := PackedVector2Array()
    var indices := PackedInt32Array()
    var step := terrain_size / float(resolution - 1)
    var half := terrain_size * 0.5

    for z in range(resolution):
        for x in range(resolution):
            var wx := -half + x * step
            var wz := -half + z * step
            var h := sample_height(wx, wz)
            vertices.append(Vector3(wx, h, wz))
            uvs.append(Vector2(float(x) / (resolution - 1), float(z) / (resolution - 1)) * 32.0)
            var hx := sample_height(wx + 1.5, wz) - sample_height(wx - 1.5, wz)
            var hz := sample_height(wx, wz + 1.5) - sample_height(wx, wz - 1.5)
            var normal := Vector3(-hx, 3.0, -hz).normalized()
            normals.append(normal)
            var slope := 1.0 - normal.y
            var color := Color("#365d37")
            if h < water_level + 2.5:
                color = Color("#a79a6b")
            elif h > 66.0 or slope > 0.48:
                color = Color("#62635c")
            elif h > 40.0:
                color = Color("#455b3e")
            else:
                var variation := detail_noise.get_noise_2d(wx, wz) * 0.055
                color = Color(0.18 + variation, 0.33 + variation, 0.17 + variation, 1.0)
            colors.append(color)

    for z in range(resolution - 1):
        for x in range(resolution - 1):
            var i := z * resolution + x
            indices.append_array(PackedInt32Array([i, i + resolution, i + 1, i + 1, i + resolution, i + resolution + 1]))

    var arrays := []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_NORMAL] = normals
    arrays[Mesh.ARRAY_COLOR] = colors
    arrays[Mesh.ARRAY_TEX_UV] = uvs
    arrays[Mesh.ARRAY_INDEX] = indices
    var mesh := ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

    var material := StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.roughness = 0.94
    material.metallic = 0.0
    material.normal_enabled = false
    mesh.surface_set_material(0, material)

    var terrain_mesh := MeshInstance3D.new()
    terrain_mesh.name = "Ground"
    terrain_mesh.mesh = mesh
    terrain_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
    add_child(terrain_mesh)

    var body := StaticBody3D.new()
    body.name = "TerrainCollision"
    var shape := CollisionShape3D.new()
    var concave := ConcavePolygonShape3D.new()
    concave.set_faces(mesh.get_faces())
    shape.shape = concave
    body.add_child(shape)
    add_child(body)

func _build_water() -> void:
    var water := MeshInstance3D.new()
    water.name = "Ocean"
    var plane := PlaneMesh.new()
    plane.size = Vector2(1500.0, 1500.0)
    plane.subdivide_width = 2
    plane.subdivide_depth = 2
    water.mesh = plane
    water.position.y = water_level
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.055, 0.25, 0.28, 0.82)
    mat.metallic = 0.12
    mat.roughness = 0.24
    mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    mat.cull_mode = BaseMaterial3D.CULL_DISABLED
    water.material_override = mat
    add_child(water)

func _scatter_vegetation() -> void:
    var trunk_mesh := CylinderMesh.new()
    trunk_mesh.top_radius = 0.28
    trunk_mesh.bottom_radius = 0.5
    trunk_mesh.height = 4.7
    trunk_mesh.radial_segments = 6
    var trunk_mat := StandardMaterial3D.new()
    trunk_mat.albedo_color = Color("#4c3524")
    trunk_mat.roughness = 1.0
    trunk_mesh.material = trunk_mat

    var crown_mesh := SphereMesh.new()
    crown_mesh.radius = 2.2
    crown_mesh.height = 4.7
    crown_mesh.radial_segments = 7
    crown_mesh.rings = 4
    var crown_mat := StandardMaterial3D.new()
    crown_mat.albedo_color = Color("#24462b")
    crown_mat.roughness = 0.95
    crown_mesh.material = crown_mat

    var trunks := MultiMeshInstance3D.new()
    var crowns := MultiMeshInstance3D.new()
    trunks.name = "TreeTrunks"
    crowns.name = "TreeCanopies"
    var trunk_multi := MultiMesh.new()
    var crown_multi := MultiMesh.new()
    trunk_multi.transform_format = MultiMesh.TRANSFORM_3D
    crown_multi.transform_format = MultiMesh.TRANSFORM_3D
    trunk_multi.mesh = trunk_mesh
    crown_multi.mesh = crown_mesh
    var transforms: Array[Transform3D] = []
    for i in range(820):
        var angle := rng.randf_range(0.0, TAU)
        var radius := sqrt(rng.randf()) * terrain_size * 0.46
        var x := cos(angle) * radius
        var z := sin(angle) * radius
        var y := sample_height(x, z)
        if y < water_level + 7.0 or y > 61.0:
            continue
        var scale := rng.randf_range(0.65, 1.65)
        var basis := Basis(Vector3.UP, rng.randf_range(0.0, TAU)).scaled(Vector3(scale, scale, scale))
        transforms.append(Transform3D(basis, Vector3(x, y + 2.35 * scale, z)))
    trunk_multi.instance_count = transforms.size()
    crown_multi.instance_count = transforms.size()
    for i in range(transforms.size()):
        trunk_multi.set_instance_transform(i, transforms[i])
        var t := transforms[i]
        t.origin.y += 3.0 * t.basis.get_scale().y
        crown_multi.set_instance_transform(i, t)
    trunks.multimesh = trunk_multi
    crowns.multimesh = crown_multi
    trunks.visibility_range_end = 520.0
    crowns.visibility_range_end = 520.0
    trunks.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
    crowns.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
    add_child(trunks)
    add_child(crowns)

func _scatter_rocks() -> void:
    var rock_mesh := SphereMesh.new()
    rock_mesh.radius = 1.3
    rock_mesh.height = 2.7
    rock_mesh.radial_segments = 6
    rock_mesh.rings = 4
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("#5e615a")
    mat.roughness = 0.96
    rock_mesh.material = mat
    var rocks := MultiMeshInstance3D.new()
    rocks.name = "Rocks"
    var multi := MultiMesh.new()
    multi.transform_format = MultiMesh.TRANSFORM_3D
    multi.mesh = rock_mesh
    var transforms: Array[Transform3D] = []
    for i in range(280):
        var angle := rng.randf_range(0.0, TAU)
        var radius := sqrt(rng.randf()) * terrain_size * 0.49
        var x := cos(angle) * radius
        var z := sin(angle) * radius
        var y := sample_height(x, z)
        if y < water_level + 1.0:
            continue
        var sx := rng.randf_range(0.4, 2.8)
        var sy := rng.randf_range(0.35, 1.7)
        var sz := rng.randf_range(0.5, 2.4)
        var basis := Basis(Vector3.UP, rng.randf_range(0.0, TAU)).scaled(Vector3(sx, sy, sz))
        transforms.append(Transform3D(basis, Vector3(x, y + sy * 0.6, z)))
    multi.instance_count = transforms.size()
    for i in range(transforms.size()):
        multi.set_instance_transform(i, transforms[i])
    rocks.multimesh = multi
    rocks.visibility_range_end = 390.0
    rocks.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
    add_child(rocks)
