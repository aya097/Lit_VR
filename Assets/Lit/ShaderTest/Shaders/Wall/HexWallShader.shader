Shader "Custom/Stage/Wall/Hex"
{
    Properties
    {
        _Distance("Distance",float) = 1
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        LOD 100
        blend SrcAlpha OneMinusSrcAlpha

        Pass
        {

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "../../../Utility/Shaders/Hex.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 positionWS : TEXCOORD1;
            };

            float _Distance;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.positionWS = TransformObjectToWorld(v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.vertex = TransformObjectToHClip(v.vertex);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float scale = 20;
                float2 uv = Hex(i.uv, scale);
                float hex_alpha = smoothstep(0, 0.03, length(i.uv - uv));
                float3 cameraPositionWs = _WorldSpaceCameraPos.xyz;
                float distance = length(cameraPositionWs - i.positionWS) * 0.5;
                float r = 1.7;
                float alpha = smoothstep(0,0.5, 1 - abs(r - distance) * 10);
                alpha = max(0, alpha);
                // alpha = lerp(alpha, 0, length(i.uv - uv));


                
                float4 col = float4(uv.xy,0,alpha * hex_alpha);
                return col;


                // float4 col;
                // float r = 0.3;
                // float d = length(i.uv - float2(0.5,0.5));
                // col = 1 - abs(r - d) * 10;

                // col.a = 1;
                // return col;
            }
            ENDHLSL
        }
    }
}