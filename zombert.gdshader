shader_type canvas_item;

uniform vec2 light_pos;

void calculateLight(in vec2 pixel_pos, out float light_contribution) {
    // Calculate the distance between the pixel and the light
    float distance = distance(pixel_pos, light_pos);

    // Modify the light_contribution based on the distance or other light calculations
    light_contribution = 1.0 - distance;
}

void fragment() {
    // Get the pixel position in UV coordinates
    vec2 pixel_pos = SCREEN_UV;

    // Calculate the light contribution for the current pixel
    float light_contribution;
    calculateLight(pixel_pos, light_contribution);

    // Discard the pixel if it's outside the light range
    if (light_contribution <= 0.0) {
        discard;
    }

    // Output the final
}
