// Knot Topology Systems for Tension and Motion Graphs
// Based on Animated Knots (https://www.animatedknots.com/) classification

// ============================================================================
// KNOT CLASSIFICATION AND TENSION SYSTEMS
// ============================================================================

// Knot types based on Animated Knots classification
#define KNOT_OVERHAND 0
#define KNOT_FIGURE_EIGHT 1
#define KNOT_SQUARE 2
#define KNOT_SHEET_BEND 3
#define KNOT_BOWLINE 4
#define KNOT_CLOVE_HITCH 5
#define KNOT_ROUND_TURN 6
#define KNOT_CARRICK_BEND 7

struct KnotTension {
    float crossing_number;
    float writhe;
    float linking_number;
    vec3 tension_vector;
    float stability_factor;
    int knot_type;
};

// Knot crossing analysis
float calculate_crossing_number(vec3[] knot_points, int num_points) {
    float crossings = 0.0;
    
    for (int i = 0; i < num_points - 3; i++) {
        for (int j = i + 2; j < num_points - 1; j++) {
            // Check if line segments cross
            vec3 p1 = knot_points[i];
            vec3 p2 = knot_points[i + 1];
            vec3 p3 = knot_points[j];
            vec3 p4 = knot_points[j + 1];
            
            if (line_segments_intersect(p1, p2, p3, p4)) {
                crossings += 1.0;
            }
        }
    }
    
    return crossings;
}

// Calculate writhe (measure of knot complexity)
float calculate_writhe(vec3[] knot_points, int num_points) {
    float writhe = 0.0;
    
    for (int i = 0; i < num_points - 1; i++) {
        for (int j = i + 1; j < num_points - 1; j++) {
            vec3 r1 = knot_points[i + 1] - knot_points[i];
            vec3 r2 = knot_points[j + 1] - knot_points[j];
            vec3 r12 = knot_points[j] - knot_points[i];
            
            vec3 cross_product = cross(r1, r2);
            float dot_product = dot(cross_product, r12);
            float magnitude = length(cross_product) * length(r12);
            
            if (magnitude > 0.0) {
                writhe += dot_product / magnitude;
            }
        }
    }
    
    return writhe / (4.0 * 3.14159);
}

// Calculate linking number
float calculate_linking_number(vec3[] knot1_points, int num1, vec3[] knot2_points, int num2) {
    float linking = 0.0;
    
    for (int i = 0; i < num1 - 1; i++) {
        for (int j = 0; j < num2 - 1; j++) {
            vec3 r1 = knot1_points[i + 1] - knot1_points[i];
            vec3 r2 = knot2_points[j + 1] - knot2_points[j];
            vec3 r12 = knot2_points[j] - knot1_points[i];
            
            vec3 cross_product = cross(r1, r2);
            float dot_product = dot(cross_product, r12);
            float magnitude = length(cross_product) * length(r12);
            
            if (magnitude > 0.0) {
                linking += dot_product / magnitude;
            }
        }
    }
    
    return linking / (4.0 * 3.14159);
}

// ============================================================================
// LSTM-BASED TENSION PREDICTION
// ============================================================================

struct LSTMState {
    vec3 cell_state;
    vec3 hidden_state;
    mat3 W_f; // Forget gate weights
    mat3 W_i; // Input gate weights
    mat3 W_o; // Output gate weights
    mat3 W_c; // Candidate values weights
    vec3 b_f; // Forget gate bias
    vec3 b_i; // Input gate bias
    vec3 b_o; // Output gate bias
    vec3 b_c; // Candidate values bias
};

// LSTM cell for tension prediction
vec3 lstm_forward(LSTMState state, vec3 input, vec3 previous_hidden) {
    // Forget gate
    vec3 forget_gate = sigmoid(state.W_f * input + state.b_f);
    
    // Input gate
    vec3 input_gate = sigmoid(state.W_i * input + state.b_i);
    
    // Candidate values
    vec3 candidate = tanh(state.W_c * input + state.b_c);
    
    // Update cell state
    vec3 new_cell_state = forget_gate * state.cell_state + input_gate * candidate;
    
    // Output gate
    vec3 output_gate = sigmoid(state.W_o * input + state.b_o);
    
    // Hidden state
    vec3 new_hidden_state = output_gate * tanh(new_cell_state);
    
    return new_hidden_state;
}

// Predict tension using LSTM
vec3 predict_tension(vec3 current_state, vec3[] previous_states, int num_states, LSTMState lstm) {
    vec3 hidden_state = current_state;
    
    for (int i = 0; i < num_states; i++) {
        hidden_state = lstm_forward(lstm, previous_states[i], hidden_state);
    }
    
    return hidden_state;
}

// ============================================================================
// MOTION GRAPH GENERATION
// ============================================================================

struct MotionNode {
    vec3 position;
    vec3 velocity;
    float tension;
    int parent_knot;
    int knot_type;
    float transition_probability;
};

// Generate motion graph from knot topology
MotionNode[] generate_motion_graph(vec3[] knot_points, int num_points, int knot_type) {
    MotionNode[] motion_nodes;
    
    for (int i = 0; i < num_points - 1; i++) {
        MotionNode node;
        node.position = knot_points[i];
        node.velocity = knot_points[i + 1] - knot_points[i];
        node.tension = calculate_local_tension(knot_points, i, num_points);
        node.parent_knot = knot_type;
        node.knot_type = knot_type;
        node.transition_probability = calculate_transition_probability(knot_points, i, num_points);
        
        motion_nodes.push(node);
    }
    
    return motion_nodes;
}

// Calculate local tension at a point
float calculate_local_tension(vec3[] knot_points, int index, int num_points) {
    if (index == 0 || index >= num_points - 1) return 0.0;
    
    vec3 prev = knot_points[index - 1];
    vec3 curr = knot_points[index];
    vec3 next = knot_points[index + 1];
    
    vec3 incoming = normalize(curr - prev);
    vec3 outgoing = normalize(next - curr);
    
    float angle = acos(clamp(dot(incoming, outgoing), -1.0, 1.0));
    return angle / 3.14159; // Normalize to 0-1
}

// Calculate transition probability between nodes
float calculate_transition_probability(vec3[] knot_points, int index, int num_points) {
    float tension = calculate_local_tension(knot_points, index, num_points);
    float distance = length(knot_points[index + 1] - knot_points[index]);
    
    // Higher tension and shorter distances increase transition probability
    return (1.0 - tension) * (1.0 / (1.0 + distance));
}

// ============================================================================
// KNOT-SPECIFIC TENSION SYSTEMS
// ============================================================================

// Overhand knot tension (simplest stopper knot)
KnotTension create_overhand_tension(vec3[] knot_points, int num_points) {
    KnotTension tension;
    tension.crossing_number = 1.0;
    tension.writhe = calculate_writhe(knot_points, num_points);
    tension.linking_number = 0.0;
    tension.tension_vector = calculate_tension_vector(knot_points, num_points);
    tension.stability_factor = 0.8;
    tension.knot_type = KNOT_OVERHAND;
    
    return tension;
}

// Figure-8 knot tension (non-binding stopper)
KnotTension create_figure_eight_tension(vec3[] knot_points, int num_points) {
    KnotTension tension;
    tension.crossing_number = 2.0;
    tension.writhe = calculate_writhe(knot_points, num_points);
    tension.linking_number = 0.0;
    tension.tension_vector = calculate_tension_vector(knot_points, num_points);
    tension.stability_factor = 0.9;
    tension.knot_type = KNOT_FIGURE_EIGHT;
    
    return tension;
}

// Square knot tension (joins two ropes)
KnotTension create_square_tension(vec3[] knot_points, int num_points) {
    KnotTension tension;
    tension.crossing_number = 2.0;
    tension.writhe = calculate_writhe(knot_points, num_points);
    tension.linking_number = 0.0;
    tension.tension_vector = calculate_tension_vector(knot_points, num_points);
    tension.stability_factor = 0.7;
    tension.knot_type = KNOT_SQUARE;
    
    return tension;
}

// Bowline knot tension (creates fixed loop)
KnotTension create_bowline_tension(vec3[] knot_points, int num_points) {
    KnotTension tension;
    tension.crossing_number = 3.0;
    tension.writhe = calculate_writhe(knot_points, num_points);
    tension.linking_number = 0.0;
    tension.tension_vector = calculate_tension_vector(knot_points, num_points);
    tension.stability_factor = 0.95;
    tension.knot_type = KNOT_BOWLINE;
    
    return tension;
}

// ============================================================================
// RECURSIVE KNOT ASSEMBLY
// ============================================================================

// Assemble knot physics recursively
MotionNode assemble_knot_physics(MotionNode[] nodes, int knot_type, int recursion_depth) {
    if (recursion_depth <= 0) {
        return nodes[0];
    }
    
    MotionNode[] sub_nodes;
    
    switch(knot_type) {
        case KNOT_OVERHAND:
            sub_nodes = create_overhand_assembly(nodes);
            break;
        case KNOT_FIGURE_EIGHT:
            sub_nodes = create_figure_eight_assembly(nodes);
            break;
        case KNOT_SQUARE:
            sub_nodes = create_square_assembly(nodes);
            break;
        case KNOT_BOWLINE:
            sub_nodes = create_bowline_assembly(nodes);
            break;
        default:
            sub_nodes = nodes;
            break;
    }
    
    // Recursively assemble sub-knots
    return assemble_knot_physics(sub_nodes, knot_type, recursion_depth - 1);
}

// Create overhand knot assembly
MotionNode[] create_overhand_assembly(MotionNode[] input_nodes) {
    MotionNode[] assembly;
    
    for (int i = 0; i < input_nodes.length; i++) {
        MotionNode node = input_nodes[i];
        node.tension *= 0.8; // Overhand reduces tension
        node.stability_factor = 0.8;
        assembly.push(node);
    }
    
    return assembly;
}

// Create figure-8 knot assembly
MotionNode[] create_figure_eight_assembly(MotionNode[] input_nodes) {
    MotionNode[] assembly;
    
    for (int i = 0; i < input_nodes.length; i++) {
        MotionNode node = input_nodes[i];
        node.tension *= 0.9; // Figure-8 maintains tension better
        node.stability_factor = 0.9;
        assembly.push(node);
    }
    
    return assembly;
}

// ============================================================================
// NEGATIVE SPACE AS MOTION GRAPH
// ============================================================================

// Generate negative space motion graph
MotionNode[] generate_negative_space_graph(vec3[] positive_space, int num_points) {
    MotionNode[] negative_nodes;
    
    // Find bounding box of positive space
    vec3 min_bounds = positive_space[0];
    vec3 max_bounds = positive_space[0];
    
    for (int i = 1; i < num_points; i++) {
        min_bounds = min(min_bounds, positive_space[i]);
        max_bounds = max(max_bounds, positive_space[i]);
    }
    
    // Generate negative space nodes
    vec3 center = (min_bounds + max_bounds) * 0.5;
    vec3 size = max_bounds - min_bounds;
    
    for (int i = 0; i < 8; i++) {
        MotionNode node;
        node.position = center + vec3(
            (i & 1) ? size.x * 0.5 : -size.x * 0.5,
            (i & 2) ? size.y * 0.5 : -size.y * 0.5,
            (i & 4) ? size.z * 0.5 : -size.z * 0.5
        );
        node.velocity = vec3(0.0);
        node.tension = 0.0;
        node.parent_knot = -1;
        node.knot_type = -1;
        node.transition_probability = 1.0;
        
        negative_nodes.push(node);
    }
    
    return negative_nodes;
}

// ============================================================================
// BONE COUNT LIMITATION SYSTEM
// ============================================================================

struct BoneConstraint {
    int max_bones;
    int current_bones;
    float bone_weight_threshold;
};

// Apply bone count limitation
MotionNode[] apply_bone_limitation(MotionNode[] nodes, BoneConstraint constraint) {
    if (nodes.length <= constraint.max_bones) {
        return nodes;
    }
    
    // Sort nodes by tension (keep highest tension nodes)
    sort_nodes_by_tension(nodes);
    
    MotionNode[] limited_nodes;
    for (int i = 0; i < constraint.max_bones && i < nodes.length; i++) {
        if (nodes[i].tension > constraint.bone_weight_threshold) {
            limited_nodes.push(nodes[i]);
        }
    }
    
    return limited_nodes;
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

// Check if two line segments intersect
bool line_segments_intersect(vec3 p1, vec3 p2, vec3 p3, vec3 p4) {
    vec3 d1 = p2 - p1;
    vec3 d2 = p4 - p3;
    vec3 d3 = p3 - p1;
    
    vec3 cross_d1_d2 = cross(d1, d2);
    float dot_d3_cross = dot(d3, cross_d1_d2);
    
    if (abs(dot_d3_cross) < 0.0001) {
        return false; // Lines are parallel
    }
    
    float t1 = dot(cross(d3, d2), cross_d1_d2) / dot(cross_d1_d2, cross_d1_d2);
    float t2 = dot(cross(d3, d1), cross_d1_d2) / dot(cross_d1_d2, cross_d1_d2);
    
    return t1 >= 0.0 && t1 <= 1.0 && t2 >= 0.0 && t2 <= 1.0;
}

// Calculate tension vector
vec3 calculate_tension_vector(vec3[] knot_points, int num_points) {
    if (num_points < 2) return vec3(0.0);
    
    vec3 total_tension = vec3(0.0);
    for (int i = 1; i < num_points - 1; i++) {
        vec3 prev = knot_points[i - 1];
        vec3 curr = knot_points[i];
        vec3 next = knot_points[i + 1];
        
        vec3 incoming = normalize(curr - prev);
        vec3 outgoing = normalize(next - curr);
        
        total_tension += incoming - outgoing;
    }
    
    return normalize(total_tension);
}

// Sigmoid activation function
vec3 sigmoid(vec3 x) {
    return vec3(
        1.0 / (1.0 + exp(-x.x)),
        1.0 / (1.0 + exp(-x.y)),
        1.0 / (1.0 + exp(-x.z))
    );
}

// Tanh activation function
vec3 tanh(vec3 x) {
    return vec3(
        tanh(x.x),
        tanh(x.y),
        tanh(x.z)
    );
}

// Clamp function
float clamp(float x, float min_val, float max_val) {
    return min(max(x, min_val), max_val);
}

// Min and max functions for vectors
vec3 min(vec3 a, vec3 b) {
    return vec3(min(a.x, b.x), min(a.y, b.y), min(a.z, b.z));
}

vec3 max(vec3 a, vec3 b) {
    return vec3(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z));
}









