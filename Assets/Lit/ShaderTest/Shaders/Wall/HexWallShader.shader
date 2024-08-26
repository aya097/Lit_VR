Shader "Custom/Stage/Wall/Hex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HitRadiuses ("HitRadius", float) = 1
        _Scale ("Scale",float) = 20

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _HitRadius;
            float _Scale;

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
                // 六角形を生成
                float2 uv = Hex(i.uv, _Scale);

                // 縁を強調
                float hex_alpha = smoothstep(0, 0.03, length(i.uv - uv));

                // カメラとの距離を取得
                float3 cameraPositionWs = _WorldSpaceCameraPos.xyz;
                float distance = length(cameraPositionWs - i.positionWS) * 0.5;
                
                // _HitRadiusに近いところを強調
                float alpha = smoothstep(0,0.5, 1 - abs(_HitRadius - distance) * 10);
                alpha = max(0, alpha);
                
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