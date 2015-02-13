#ifdef GL_ES
    precision highp float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform sampler2D texture;
uniform sampler2D flowTexture;
varying float light;
varying vec2 uv;

void main(void) {
    vec4 c = texture2D(texture, uv);
    vec4 f = texture2D(flowTexture, uv);
    float alpha = 1.0;
    if (c.z < 0.0) {
        alpha = 0.0;
    };

    vec3 color = vec3(0, 0.5, 0.5 + 0.5 * (c.z + c.w));

    float distanceToLineX = mod(uv.x + 0.5/256.0, 1.0/256.0) * 256.0;
    distanceToLineX = min(1.0 - distanceToLineX, distanceToLineX);
    float xGradient = 100.0 * length(vec2(dFdx(uv.x) , dFdy(uv.x)));
    float xEdgyness = smoothstep(1.0, 0.0, 0.3 * distanceToLineX / xGradient);

    float distanceToLineY = mod(uv.y - 0.5/256.0, 1.0/256.0) * 256.0;
    distanceToLineY = min(1.0 - distanceToLineY, distanceToLineY);
    float yGradient = 100.0 * length(vec2(dFdx(uv.y) , dFdy(uv.y)));
    float yEdgyness = smoothstep(1.0, 0.0, 0.3 * distanceToLineY / xGradient);

    float edgyness = max(xEdgyness, yEdgyness);

    //color = mix(color, vec3(1.0, 1.0, 1.0), min(0.3, edgyness/(30.0 * max(xGradient, yGradient))));
    color = mix(color, vec3(1.0, 1.0, 1.0), min(0.6, f.x));

    gl_FragColor = vec4(color, alpha);
}