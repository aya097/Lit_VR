Shader "Custom/Stage/Bridge/Slope"
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
            

            float4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float scaleX = length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x));
                float scaleZ = length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z));
                uv.x *= scaleX / scaleZ;

                float4 col = 0;
                return col;
            }
            ENDHLSL
        }
    }
}
