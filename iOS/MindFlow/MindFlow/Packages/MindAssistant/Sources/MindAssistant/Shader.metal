//
//  Shader.metal
//  MindAssistant
//
//  Converted from GLSL to Metal Shading Language
//

#include <metal_stdlib>
using namespace metal;

#define PI 3.141596
#define TAU 6.283185
#define EPSILON 1e-3
#define FORITERATIONS 10.0

struct Uniforms {
    float3 iResolution;
    float iTime;
    float iTimeDelta;
    float iFrameRate;
    int iFrame;
    float4 iMouse;
    
    // Control parameters
    float timeSpeed;
    float iterations;
    float cameraDistance;
    float rotationSpeed;
    float fbmIntensity;
    float colorIntensity;
    float sphereRadius;
    
    // Interactive parameters
    float yaw;
    float pitch;
    float explosion;
    float _pad;
    float2 explosionPos;
};

struct VertexOut {
    float4 position [[position]];
};

// Vertex shader - simple full-screen triangle
vertex VertexOut vertex_main(uint vertexID [[vertex_id]]) {
    VertexOut out;
    
    // Full-screen triangle technique
    // Vertex positions extend beyond viewport to cover entire screen
    float2 positions[3] = {
        float2(-1.0, -1.0),  // Bottom-left
        float2(3.0, -1.0),   // Bottom-right (extends beyond)
        float2(-1.0, 3.0)    // Top-left (extends beyond)
    };
    
    out.position = float4(positions[vertexID], 0.0, 1.0);
    
    return out;
}

float2x2 rotate(float a) {
    float s = sin(a);
    float c = cos(a);
    return float2x2(c, -s, s, c);
}

float fbm(float3 p) {
    float amp = 1.0;
    float fre = 1.0;
    float n = 0.0;
    
    for(float i = 0.0; i < 4.0; i++) {
        n += abs(dot(cos(p), float3(0.1)));
        amp *= 0.5;
        fre *= 2.0;
    }
    
    return n;
}

float sdSphere(float3 p, float r) {
    return length(p) - r;
}

// Fragment shader (mainImage equivalent)
fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant Uniforms &uniforms [[buffer(0)]]) {
    float2 R = uniforms.iResolution.xy;
    
    // Get fragment position (pixel coordinates) - Metal origin is top-left
    // We need to flip Y to match OpenGL's bottom-left origin
    float2 fragCoord = float2(in.position.x, R.y - in.position.y);
    
    // I is the fragment coordinate (pixel position) - same as gl_FragCoord in GLSL
    float2 I = fragCoord;
    
    // Convert to shader coordinates: center at origin, normalize by height
    // This matches the original: (I*2.-R)/R.y
    float2 uv = (I * 2.0 - R) / R.y;
    
    float2 m = (uniforms.iMouse.xy * 2.0 - R) / R * PI * 2.0;
    
    float T = uniforms.iTime * uniforms.timeSpeed;
    
    // Initialize with 0 alpha
    float4 O = float4(0.0, 0.0, 0.0, 0.0);
    
    float3 ro = float3(0.0, 0.0, -uniforms.cameraDistance);
    // Apply manual rotation to camera position (orbit) if desired, or rotate the scene
    // Here we rotate the ray direction and position to simulate camera movement, 
    // OR we can just rotate the scene points 'p'
    
    float3 rd = normalize(float3(uv, 1.0));
    
    // Apply pitch and yaw to the ray direction for camera rotation effect
    float2x2 rotYaw = rotate(uniforms.yaw);
    float2x2 rotPitch = rotate(uniforms.pitch);
    
    // Rotate ray direction (camera look)
    // Rotate around Y (yaw) and X (pitch)
    float3 rd_rotated = rd;
    rd_rotated.yz = rotPitch * rd_rotated.yz;
    rd_rotated.xz = rotYaw * rd_rotated.xz;
    
    // Also rotate ray origin if we want to orbit around the center (0,0,0)
    float3 ro_rotated = ro;
    ro_rotated.yz = rotPitch * ro_rotated.yz;
    ro_rotated.xz = rotYaw * ro_rotated.xz;
    
    rd = rd_rotated;
    ro = ro_rotated;
    
    float zMax = 50.0;
    float z = 0.1;
    float3 col = float3(0.0);
    
    // Use a fixed maximum for the loop to ensure compilation, but break early based on uniform
    float maxIterations = uniforms.iterations;
    for(float i = 0.0; i < 50.0; i++) {
        if (i >= maxIterations) break;
        
        float3 p = ro + rd * z;
        
        // Localize explosion effect
        // Convert explosionPos (0-1) to same coordinate space as uv
        float2 explPixels = uniforms.explosionPos * R.xy;
        float2 uv_expl = (explPixels * 2.0 - R.xy) / R.y;
        float distToExplosion = length(uv - uv_expl);
        
        // Attenuation function: stronger near the point, falls off
        float attenuation = exp(-distToExplosion * 3.0);
        
        // Apply localized explosion
        float expl = uniforms.explosion * attenuation;
        
        float rotationAngle = T + i * 2.3 * uniforms.rotationSpeed;
        
        float2x2 rotXZ = rotate(rotationAngle);
        float2x2 rotYZ = rotate(rotationAngle);
        
        p.xz = rotXZ * p.xz;
        p.yz = rotYZ * p.yz;
        
        float d = abs(sdSphere(p, uniforms.sphereRadius) * 0.9) + 0.01;
        
        // Increase noise intensity slightly during explosion
        float currentFbm = uniforms.fbmIntensity + expl * 0.5;
        d += fbm(p * 1.8) * currentFbm;
        
        // Light explosion: significant color intensity boost
        float currentIntense = uniforms.colorIntensity + expl * 5.0;
        col += (1.1 + sin(float3(3.0, 2.0, 1.0) + dot(p, float3(1.0)) + T)) / d * currentIntense;
        
        if(d < EPSILON || z > zMax) break;
        z += d;
    }
    
    col = tanh(col / 2e2);
    
    // Ensure valid premultiplied alpha: Alpha must be >= max(r, g, b)
    // Use the maximum color component as the base alpha
    float maxColor = max(max(col.r, col.g), col.b);
    
    // We can boost alpha slightly to make it more solid, but ensure it doesn't clip RGB
    // For additive-like glow, Alpha should be close to 0, but RGB > 0 is invalid for premul if Alpha < RGB.
    // Wait, for ADDITIVE blending in standard SourceOver:
    // SourceOver: Res = Src + Dst * (1 - SrcA)
    // We want: Res = Src + Dst (Additive) -> implies SrcA = 0.
    // But standard premul requires SrcRGB <= SrcA.
    // If SrcA = 0, then SrcRGB must be 0.
    // So you CANNOT do pure additive blending with standard Premultiplied SourceOver if you follow the rules strictly.
    // HOWEVER, iOS CoreAnimation generally allows "illegal" premul values (RGB > A) which results in "super-luminescent" colors (brighter than 1.0).
    // But usually this is clamped or produces artifacts.
    
    // If the user sees "dark contours", it means we are DARKENING the background.
    // Darkening happens if SrcRGB is LOW but SrcA is HIGH.
    // Res = Low + Dst * (1 - High). The Dst is attenuated heavily, but Low isn't adding enough back.
    
    // So to avoid dark contours: Ensure Alpha is NOT higher than necessary.
    // Using alpha = maxColor ensures we never darken the background more than the light we add covers it.
    
    O.rgb = col;
    O.a = maxColor;
    
    return O;
}

