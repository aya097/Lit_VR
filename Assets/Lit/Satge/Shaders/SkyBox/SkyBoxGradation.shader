Shader "Custom/SkyBox/Gradation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightValue ("LightValue",Range(0,1)) = 0
        _Threshold("Threshold",Range(0,1)) = 1
        _ChangeWidth("ChangeWidth",float) = 0.1
        _LineWidth("LineWidth",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "../../../Utility/Shaders/Noise.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LightValue;
            float _Threshold;
            float _ChangeWidth;
            float _LineWidth;



            v2f vert (appdata v)
            {
                v2f o;
                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);//追加
                o.vertex = vertexInput.positionCS;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            float Lit(float u)
            {
                u = frac(u);
                float time = _Time.y;
                return smoothstep(frac(time),frac(time + 0.1),u) * step(u,frac(time + 0.1)) * sign(_Threshold - _LightValue);
            }

            float4 frag (v2f i) : SV_Target
            {
                // 0~1 に正規化
                float u = (i.uv.x + 1) * 0.5;
                float v = (i.uv.y + 1) * 0.5;

                // LightValue の値に応じて色を決定
                float4 col = smoothstep(_Threshold - _ChangeWidth , _Threshold + _ChangeWidth, _LightValue * (1 + _ChangeWidth));
                col.a = 1.0;
                
                // 線を走らせる
                float f = i.uv.x * 2 + i.uv.y;
                float diff = 2;
                col += (1 - diff * col + Lit(u)) * smoothstep(0.4,0.4 + _LineWidth , f) * step(f,0.4 + _LineWidth);
                f = -i.uv.x * 2 + i.uv.y - 1;
                col += (1 - diff * col + Lit(u)) * smoothstep(0.4,0.4 + _LineWidth , f) * step(f,0.4 + _LineWidth);
                f = i.uv.x * 0.3 + i.uv.y;
                col += (1 - diff * col + Lit(u)) * smoothstep(0.4,0.4 + _LineWidth , f) * step(f,0.4 + _LineWidth);
                f = i.uv.x * 0.2 + i.uv.y + 0.5;
                col += (1 - diff * col + Lit(u)) * smoothstep(0.4,0.4 + _LineWidth , f) * step(f,0.4 + _LineWidth);

         
                return col;
            }
            ENDHLSL
        }
    }
}
