// SDF Max Linear Algebra Examples
// Advanced volume expressions with calculus perturbations

// ============================================================================
// MODULE 1: LINEAR ALGEBRA FOUNDATIONS FOR SDF VOLUME EXPRESSIONS
// ============================================================================

// Basic SDF primitives with matrix transformations
float sdf_sphere(vec3 p, float r) {
    return length(p) - r;
}

float sdf_box(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float sdf_capsule(vec3 p, vec3 a, vec3 b, float r) {
    vec3 pa = p - a;
    vec3 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h) - r;
}

// Matrix transformation of SDFs
float sdf_transformed(vec3 p, mat4 transform, float base_sdf(vec3)) {
    vec3 local_p = (inverse(transform) * vec4(p, 1.0)).xyz;
    return base_sdf(local_p);
}

// ============================================================================
// CALCULUS 2 PERTURBATIONS FOR COMPLEX SHAPES
// ============================================================================

// Sawtooth pattern for hair simulation
float sawtooth_perturbation(vec3 p, float frequency, float amplitude, vec3 direction) {
    float phase = dot(p, direction) * frequency;
    float sawtooth = 2.0 * (phase - floor(phase + 0.5));
    return amplitude * sawtooth;
}

// Sine wave perturbation for organic shapes
float sine_perturbation(vec3 p, float frequency, float amplitude, vec3 direction) {
    float phase = dot(p, direction) * frequency;
    return amplitude * sin(phase);
}

// Noise-based perturbation using fractional Brownian motion
float fbm_perturbation(vec3 p, int octaves, float frequency, float amplitude) {
    float value = 0.0;
    float current_amplitude = amplitude;
    float current_frequency = frequency;
    
    for (int i = 0; i < octaves; i++) {
        value += current_amplitude * noise(p * current_frequency);
        current_amplitude *= 0.5;
        current_frequency *= 2.0;
    }
    
    return value;
}

// Combined perturbation function
float apply_perturbation(vec3 p, float base_sdf, int perturbation_type, 
                        float frequency, float amplitude, vec3 direction) {
    float perturbation = 0.0;
    
    switch(perturbation_type) {
        case 0: // Sawtooth
            perturbation = sawtooth_perturbation(p, frequency, amplitude, direction);
            break;
        case 1: // Sine
            perturbation = sine_perturbation(p, frequency, amplitude, direction);
            break;
        case 2: // FBM Noise
            perturbation = fbm_perturbation(p, 4, frequency, amplitude);
            break;
        case 3: // Combined
            perturbation = 0.5 * sawtooth_perturbation(p, frequency, amplitude, direction) +
                          0.5 * sine_perturbation(p, frequency * 2.0, amplitude * 0.5, direction);
            break;
    }
    
    return base_sdf + perturbation;
}

// ============================================================================
// HAIR SIMULATION WITH SDF PERTURBATIONS
// ============================================================================

// Hair strand with sawtooth pattern
float hair_strand_sdf(vec3 p, vec3 root, vec3 tip, float radius, 
                     float sawtooth_freq, float sawtooth_amp) {
    vec3 local_p = p - root;
    vec3 direction = normalize(tip - root);
    float length_to_tip = length(tip - root);
    
    // Project onto hair axis
    float t = dot(local_p, direction);
    vec3 closest_point = root + direction * clamp(t, 0.0, length_to_tip);
    
    // Base capsule SDF
    float base_sdf = length(p - closest_point) - radius;
    
    // Apply sawtooth perturbation along hair direction
    float perturbation = sawtooth_perturbation(local_p, sawtooth_freq, sawtooth_amp, direction);
    
    return base_sdf + perturbation;
}

// Hair clump with multiple strands
float hair_clump_sdf(vec3 p, vec3 center, float clump_radius, int num_strands) {
    float min_sdf = 1000.0;
    
    for (int i = 0; i < num_strands; i++) {
        // Generate random strand parameters
        float angle = float(i) * 6.28318 / float(num_strands);
        vec3 offset = vec3(cos(angle), 0.0, sin(angle)) * clump_radius * 0.5;
        vec3 root = center + offset;
        vec3 tip = root + vec3(0.0, 1.0, 0.0) + offset * 0.3;
        
        float strand_sdf = hair_strand_sdf(p, root, tip, 0.02, 8.0, 0.01);
        min_sdf = min(min_sdf, strand_sdf);
    }
    
    return min_sdf;
}

// ============================================================================
// ADVANCED SDF OPERATIONS WITH LINEAR ALGEBRA
// ============================================================================

// Smooth minimum operation
float smin(float a, float b, float k) {
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * h * k * (1.0 / 6.0);
}

// Smooth maximum operation
float smax(float a, float b, float k) {
    float h = max(k - abs(a - b), 0.0) / k;
    return max(a, b) + h * h * h * k * (1.0 / 6.0);
}

// Chamfer operation
float chamfer(float a, float b, float r) {
    return min(min(a, b), (a + b - r) * 0.5);
}

// Round operation
float round(float a, float b, float r) {
    return min(min(a, b), (a + b + r) * 0.5);
}

// ============================================================================
// MATRIX OPERATIONS FOR SDF TRANSFORMATIONS
// ============================================================================

// Rotation matrix around X axis
mat3 rotate_x(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        1.0, 0.0, 0.0,
        0.0, c, -s,
        0.0, s, c
    );
}

// Rotation matrix around Y axis
mat3 rotate_y(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c
    );
}

// Rotation matrix around Z axis
mat3 rotate_z(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        c, -s, 0.0,
        s, c, 0.0,
        0.0, 0.0, 1.0
    );
}

// Scale matrix
mat3 scale(vec3 s) {
    return mat3(
        s.x, 0.0, 0.0,
        0.0, s.y, 0.0,
        0.0, 0.0, s.z
    );
}

// ============================================================================
// COMPLEX SHAPE EXAMPLES
// ============================================================================

// Twisted torus
float twisted_torus_sdf(vec3 p, float major_radius, float minor_radius, float twist) {
    vec2 q = vec2(length(p.xz) - major_radius, p.y);
    float angle = atan(p.z, p.x) + twist * p.y;
    q = vec2(cos(angle) * q.x - sin(angle) * q.y,
             sin(angle) * q.x + cos(angle) * q.y);
    return length(q) - minor_radius;
}

// Möbius strip
float mobius_strip_sdf(vec3 p, float radius, float width) {
    float u = atan(p.y, p.x);
    float v = p.z;
    
    vec3 q = vec3(cos(u) * (radius + v * cos(u * 0.5)),
                  sin(u) * (radius + v * cos(u * 0.5)),
                  v * sin(u * 0.5));
    
    return length(p - q) - width;
}

// Spiral staircase
float spiral_staircase_sdf(vec3 p, float radius, float height, float steps) {
    float angle = atan(p.z, p.x);
    float step_height = height / steps;
    float step_angle = angle / (2.0 * 3.14159) * steps;
    float step_y = floor(step_angle) * step_height;
    
    vec3 step_center = vec3(cos(angle) * radius, step_y, sin(angle) * radius);
    return sdf_box(p - step_center, vec3(0.5, step_height * 0.5, 0.1));
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

// Noise function (simplified)
float noise(vec3 p) {
    return sin(p.x) * cos(p.y) * sin(p.z);
}

// Smooth step function
float smoothstep(float edge0, float edge1, float x) {
    float t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t);
}

// Linear interpolation
float mix(float a, float b, float t) {
    return a + t * (b - a);
}

// Clamp function
float clamp(float x, float min_val, float max_val) {
    return min(max(x, min_val), max_val);
}









