// Integration Methods Comparison for Physics Simulation
// Runge-Kutta vs Verlet Integration for Collision Systems

// ============================================================================
// RUNGE-KUTTA 4TH ORDER INTEGRATION
// ============================================================================

struct PhysicsState {
    vec3 position;
    vec3 velocity;
    vec3 acceleration;
    float mass;
    float damping;
};

// RK4 integration for continuous systems
PhysicsState rk4_integrate(PhysicsState state, float dt, vec3 force_function(vec3, vec3, float)) {
    vec3 k1_pos = state.velocity;
    vec3 k1_vel = state.acceleration;
    
    vec3 k2_pos = state.velocity + 0.5 * dt * k1_vel;
    vec3 k2_vel = force_function(state.position + 0.5 * dt * k1_pos, 
                                 state.velocity + 0.5 * dt * k1_vel, 
                                 state.mass) / state.mass;
    
    vec3 k3_pos = state.velocity + 0.5 * dt * k2_vel;
    vec3 k3_vel = force_function(state.position + 0.5 * dt * k2_pos, 
                                 state.velocity + 0.5 * dt * k2_vel, 
                                 state.mass) / state.mass;
    
    vec3 k4_pos = state.velocity + dt * k3_vel;
    vec3 k4_vel = force_function(state.position + dt * k3_pos, 
                                 state.velocity + dt * k3_vel, 
                                 state.mass) / state.mass;
    
    vec3 new_position = state.position + (dt / 6.0) * (k1_pos + 2.0*k2_pos + 2.0*k3_pos + k4_pos);
    vec3 new_velocity = state.velocity + (dt / 6.0) * (k1_vel + 2.0*k2_vel + 2.0*k3_vel + k4_vel);
    
    return PhysicsState(new_position, new_velocity, k4_vel, state.mass, state.damping);
}

// ============================================================================
// VERLET INTEGRATION
// ============================================================================

struct VerletState {
    vec3 position;
    vec3 previous_position;
    vec3 acceleration;
    float mass;
    float damping;
};

// Verlet integration for discrete systems with better energy conservation
VerletState verlet_integrate(VerletState state, float dt, vec3 force_function(vec3, vec3, float)) {
    vec3 new_position = 2.0 * state.position - state.previous_position + 
                       state.acceleration * dt * dt;
    
    vec3 new_velocity = (new_position - state.position) / dt;
    vec3 new_acceleration = force_function(new_position, new_velocity, state.mass) / state.mass;
    
    // Apply damping
    new_velocity *= (1.0 - state.damping * dt);
    
    return VerletState(new_position, state.position, new_acceleration, state.mass, state.damping);
}

// ============================================================================
// COLLISION SYSTEMS COMPARISON
// ============================================================================

// Axis-Aligned Bounding Box (AABB) collision detection
bool aabb_collision(vec3 position, vec3 min_bounds, vec3 max_bounds) {
    return all(greaterThanEqual(position, min_bounds)) && 
           all(lessThanEqual(position, max_bounds));
}

// AABB collision response with RK4
PhysicsState aabb_collision_response_rk4(PhysicsState state, vec3 min_bounds, vec3 max_bounds, float dt) {
    if (aabb_collision(state.position, min_bounds, max_bounds)) {
        // Calculate collision normal and response
        vec3 center = (min_bounds + max_bounds) * 0.5;
        vec3 size = max_bounds - min_bounds;
        vec3 distance = abs(state.position - center) - size * 0.5;
        
        vec3 normal = vec3(0.0);
        if (distance.x > distance.y && distance.x > distance.z) {
            normal.x = sign(state.position.x - center.x);
        } else if (distance.y > distance.z) {
            normal.y = sign(state.position.y - center.y);
        } else {
            normal.z = sign(state.position.z - center.z);
        }
        
        // Reflect velocity
        state.velocity = reflect(state.velocity, normal);
        state.velocity *= 0.8; // Damping factor
    }
    
    return state;
}

// AABB collision response with Verlet
VerletState aabb_collision_response_verlet(VerletState state, vec3 min_bounds, vec3 max_bounds, float dt) {
    if (aabb_collision(state.position, min_bounds, max_bounds)) {
        // Calculate collision normal and response
        vec3 center = (min_bounds + max_bounds) * 0.5;
        vec3 size = max_bounds - min_bounds;
        vec3 distance = abs(state.position - center) - size * 0.5;
        
        vec3 normal = vec3(0.0);
        if (distance.x > distance.y && distance.x > distance.z) {
            normal.x = sign(state.position.x - center.x);
        } else if (distance.y > distance.z) {
            normal.y = sign(state.position.y - center.y);
        } else {
            normal.z = sign(state.position.z - center.z);
        }
        
        // Adjust position to prevent penetration
        state.position += normal * 0.01;
        
        // Reflect velocity
        vec3 velocity = (state.position - state.previous_position) / dt;
        velocity = reflect(velocity, normal);
        velocity *= 0.8; // Damping factor
        
        // Update previous position to maintain velocity
        state.previous_position = state.position - velocity * dt;
    }
    
    return state;
}

// ============================================================================
// CAPSULE COLLIDERS
// ============================================================================

// Capsule collision detection
float capsule_sdf(vec3 p, vec3 a, vec3 b, float r) {
    vec3 pa = p - a;
    vec3 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h) - r;
}

// Capsule collision response with RK4
PhysicsState capsule_collision_response_rk4(PhysicsState state, vec3 capsule_a, vec3 capsule_b, float radius, float dt) {
    float distance = capsule_sdf(state.position, capsule_a, capsule_b, radius);
    
    if (distance < 0.0) {
        // Calculate collision normal
        vec3 pa = state.position - capsule_a;
        vec3 ba = capsule_b - capsule_a;
        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        vec3 closest_point = capsule_a + ba * h;
        vec3 normal = normalize(state.position - closest_point);
        
        // Reflect velocity
        state.velocity = reflect(state.velocity, normal);
        state.velocity *= 0.8; // Damping factor
        
        // Push out of collision
        state.position = closest_point + normal * radius;
    }
    
    return state;
}

// Capsule collision response with Verlet
VerletState capsule_collision_response_verlet(VerletState state, vec3 capsule_a, vec3 capsule_b, float radius, float dt) {
    float distance = capsule_sdf(state.position, capsule_a, capsule_b, radius);
    
    if (distance < 0.0) {
        // Calculate collision normal
        vec3 pa = state.position - capsule_a;
        vec3 ba = capsule_b - capsule_a;
        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        vec3 closest_point = capsule_a + ba * h;
        vec3 normal = normalize(state.position - closest_point);
        
        // Push out of collision
        state.position = closest_point + normal * radius;
        
        // Reflect velocity
        vec3 velocity = (state.position - state.previous_position) / dt;
        velocity = reflect(velocity, normal);
        velocity *= 0.8; // Damping factor
        
        // Update previous position to maintain velocity
        state.previous_position = state.position - velocity * dt;
    }
    
    return state;
}

// ============================================================================
// MANIFOLD COLLISION SYSTEM
// ============================================================================

struct Manifold {
    vec3 normal;
    float penetration;
    vec3 contact_point;
    float restitution;
    float friction;
};

// Manifold collision detection
Manifold detect_manifold_collision(vec3 pos1, vec3 pos2, float radius1, float radius2) {
    vec3 distance = pos2 - pos1;
    float distance_length = length(distance);
    float penetration = (radius1 + radius2) - distance_length;
    
    Manifold manifold;
    manifold.normal = distance_length > 0.0 ? distance / distance_length : vec3(1.0, 0.0, 0.0);
    manifold.penetration = penetration;
    manifold.contact_point = pos1 + manifold.normal * radius1;
    manifold.restitution = 0.8;
    manifold.friction = 0.5;
    
    return manifold;
}

// Manifold collision response
void resolve_manifold_collision(inout PhysicsState state1, inout PhysicsState state2, Manifold manifold) {
    if (manifold.penetration > 0.0) {
        // Calculate relative velocity
        vec3 relative_velocity = state2.velocity - state1.velocity;
        float velocity_along_normal = dot(relative_velocity, manifold.normal);
        
        // Don't resolve if velocities are separating
        if (velocity_along_normal > 0.0) return;
        
        // Calculate restitution
        float restitution = min(state1.damping, state2.damping) * manifold.restitution;
        
        // Calculate impulse scalar
        float impulse_scalar = -(1.0 + restitution) * velocity_along_normal;
        impulse_scalar /= (1.0 / state1.mass + 1.0 / state2.mass);
        
        // Apply impulse
        vec3 impulse = impulse_scalar * manifold.normal;
        state1.velocity -= impulse / state1.mass;
        state2.velocity += impulse / state2.mass;
        
        // Apply friction
        vec3 tangent = relative_velocity - manifold.normal * velocity_along_normal;
        if (length(tangent) > 0.0) {
            tangent = normalize(tangent);
            float friction_impulse = -dot(relative_velocity, tangent) * manifold.friction;
            friction_impulse /= (1.0 / state1.mass + 1.0 / state2.mass);
            
            vec3 friction_force = friction_impulse * tangent;
            state1.velocity -= friction_force / state1.mass;
            state2.velocity += friction_force / state2.mass;
        }
    }
}

// ============================================================================
// NETWORK LAG COMPENSATION
// ============================================================================

struct NetworkState {
    vec3 position;
    vec3 velocity;
    float timestamp;
    float lag_compensation;
};

// Lag compensation for network synchronization
vec3 compensate_network_lag(NetworkState current, NetworkState previous, float current_time, float network_lag) {
    float delta_time = current_time - previous.timestamp;
    float compensated_time = delta_time - network_lag;
    
    if (compensated_time > 0.0) {
        return previous.position + previous.velocity * compensated_time;
    } else {
        return current.position;
    }
}

// ============================================================================
// ANIMATION SCALING AND DEFORMATION
// ============================================================================

struct AnimationState {
    vec3 position;
    vec3 velocity;
    mat3 deformation_matrix;
    float time_scale;
    float deformation_strength;
};

// Apply animation scaling and deformation
AnimationState apply_animation_deformation(AnimationState state, float dt) {
    // Scale time
    float scaled_dt = dt * state.time_scale;
    
    // Apply deformation matrix
    state.position = state.deformation_matrix * state.position;
    state.velocity = state.deformation_matrix * state.velocity;
    
    // Apply deformation strength
    state.position *= (1.0 + state.deformation_strength * sin(state.time_scale * 2.0 * 3.14159));
    
    return state;
}

// ============================================================================
// COMPARISON FUNCTIONS
// ============================================================================

// Compare integration methods for energy conservation
float calculate_energy(PhysicsState state, vec3 gravity) {
    float kinetic = 0.5 * state.mass * dot(state.velocity, state.velocity);
    float potential = -state.mass * dot(state.position, gravity);
    return kinetic + potential;
}

// Compare integration methods for stability
bool is_stable(PhysicsState state, float max_velocity, float max_acceleration) {
    return length(state.velocity) < max_velocity && 
           length(state.acceleration) < max_acceleration;
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

// Reflect vector
vec3 reflect(vec3 incident, vec3 normal) {
    return incident - 2.0 * dot(incident, normal) * normal;
}

// Clamp function
float clamp(float x, float min_val, float max_val) {
    return min(max(x, min_val), max_val);
}

// Sign function
float sign(float x) {
    return x > 0.0 ? 1.0 : (x < 0.0 ? -1.0 : 0.0);
}

// All function for vector comparison
bool all(bvec3 v) {
    return v.x && v.y && v.z;
}

// Greater than equal for vector comparison
bvec3 greaterThanEqual(vec3 a, vec3 b) {
    return bvec3(a.x >= b.x, a.y >= b.y, a.z >= b.z);
}

// Less than equal for vector comparison
bvec3 lessThanEqual(vec3 a, vec3 b) {
    return bvec3(a.x <= b.x, a.y <= b.y, a.z <= b.z);
}









