#version 300 es
precision mediump float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

vec3 adjustSaturation(vec3 color, float saturation)
{
    float luma = dot(color, vec3(0.2126, 0.7152, 0.0722));
    return mix(vec3(luma), color, saturation);
}

vec3 adjustContrast(vec3 color, float contrast)
{
    return (color - 0.5) * contrast + 0.5;
}

void main()
{
    vec4 texColor = texture(tex, v_texcoord);
    vec3 color = texColor.rgb;
    
    // 🟠 MORE SATURATION (increased from 2.0 to 3.0)
    color = adjustSaturation(color, 3.0);
    
    // 🔵 LESS CONTRAST (reduced from 1.16 to 1.05)
    color = adjustContrast(color, 1.05);
    
    // Prevent clipping
    color = clamp(color, 0.0, 1.0);
    
    fragColor = vec4(color, texColor.a);
}