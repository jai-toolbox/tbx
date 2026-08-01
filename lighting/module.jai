#import "Math";

#scope_export

MAX_POINT_LIGHTS       :: 16;
MAX_SPOT_LIGHTS        :: 16;
MAX_DIRECTIONAL_LIGHTS :: 4;

BLENDER_GLTF_WATTS_TO_LUMENS :: 683.0;

Point_Light :: struct {
    position: Vector3;
    color: Vector3 = .{1, 1, 1};
    intensity: float32 = 1.0;
    range: float32 = 6.0;
    enabled: bool = true;
}

Spot_Light :: struct {
    position: Vector3;
    direction: Vector3;
    color: Vector3 = .{1, 1, 1};
    intensity: float32 = 1.0;
    inner_cos: float32 = 0.92;
    outer_cos: float32 = 0.72;
    range: float32 = 8.0;
    enabled: bool = true;
}

Directional_Light :: struct {
    direction: Vector3 = .{-0.4, -1.0, -0.35};
    color: Vector3 = .{1.0, 0.96, 0.88};
    intensity: float32 = 2.0;
    enabled: bool = false;
    casts_shadows: bool = true;
}
