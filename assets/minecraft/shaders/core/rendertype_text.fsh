#version 400

#moj_import <fog.glsl>
#moj_import <identifiers.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec3 Position;

out vec4 fragColor;

// Constant for the rainbow array
const vec3 RainbowArray[8] = vec3[8](
    vec3( 1.0, 0.0, 0.0 ),
    vec3( 1.0, 0.5, 0.0 ),
    vec3( 1.0, 1.0, 0.0 ),
    vec3( 0.0, 0.5, 0.0 ),
    vec3( 0.0, 0.0, 1.0 ),
    vec3( 0.25, 0.0, 0.5 ),
    vec3( 0.9, 0.5, 0.9 ),
    vec3( 1.0, 1.0, 1.0 )
    );

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }

    if (is010(vertexColor)){
        color = vec4(1.0, 1.0, 1.0, 1.0);
    }

    if (is200(vertexColor)){
        color = vec4(1.0, 1.0, 1.0, 1.0);
    }
    
    if (is100(vertexColor) || is001(vertexColor)) {

        float final = mod((GameTime * 10000), 8);

        color = vec4(RainbowArray[int(final)].rgb, 1.0);

    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
    if((isScoreboard(fragColor)) && ((ScreenSize.x - gl_FragCoord.x) < 32)) discard;
    
}
