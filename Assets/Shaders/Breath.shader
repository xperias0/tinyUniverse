Shader "Unlit/Flow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [HDR]_FLowColor ("Flow Color", Color) = (1,1,1,1)
        [HDR]_BackGroundColor("Backgroudn Color",Color) = (0,0,0,0)
        _Frequency("Frequency", int) = 10
        _Speed("Speed", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Tranparent" "Queue"="Transparent" }
        Blend srcAlpha OneMinusSrcAlpha
        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _FLowColor;
            fixed4 _BackGroundColor;
            int _Frequency;
            float _Speed;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float t = saturate(sin(i.uv.x * _Frequency - _Time.y * _Speed));
                t =ceil(t);
                fixed4 col = lerp(fixed4(_BackGroundColor.rgb,0),_FLowColor,t);
                return col;
            }
            ENDCG
        }
    }
}
