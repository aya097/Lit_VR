#ifndef NOISE_MATH
#define NOISE_MATH

float randomNoise(float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898,78.233))) * 43758.5453);
}

float valueNoise(float2 uv, float pixelsize)
{
    float2 p = floor(uv * pixelsize);
    float2 f = frac(uv * pixelsize);
    float2 u = f * f * (3.0 - 2.0 * f);            
    float v00 = randomNoise(p + float2(0,0));
    float v01 = randomNoise(p + float2(0,1));
    float v10 = randomNoise(p + float2(1,0));
    float v11 = randomNoise(p + float2(1,1));
    float v0010 = lerp(v00,v10,u.x);
    float v0111 = lerp(v01,v11,u.x);
    return lerp(v0010,v0111,u.y);
}

float perlinNoise(float2 uv , float  pixelsize)
{
    float2 p = floor(uv * pixelsize);
    float2 f = frac(uv * pixelsize);
    float2 u = f * f * (3.0 - 2.0 * f);
    float2 v00 = float2(randomNoise(p+float2(0,0)), randomNoise(p + float2(0,0) + float2(1000,800)) );
    float2 v01 = float2(randomNoise(p+float2(0,1)), randomNoise(p + float2(0,1) + float2(1000,800)) );
    float2 v10 = float2(randomNoise(p+float2(1,0)), randomNoise(p + float2(1,0) + float2(1000,800)) );
    float2 v11 = float2(randomNoise(p+float2(1,1)), randomNoise(p + float2(1,1) + float2(1000,800)) );
    v00 = (v00 - 0.5 ) * 2;
    v01 = (v01 - 0.5 ) * 2;
    v10 = (v10 - 0.5 ) * 2;
    v11 = (v11 - 0.5 ) * 2;

    return lerp(lerp( dot( v00, f - float2(0,0) ), dot( v10, f - float2(1,0) ), u.x ),
        lerp( dot( v01, f - float2(0,1) ), dot( v11, f - float2(1,1) ), u.x ), 
        u.y) + 0.5f;

}

#endif