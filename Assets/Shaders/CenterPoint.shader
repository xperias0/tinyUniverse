Shader "Unlit/CenterPoint"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [HDR]_MainColor("MainColor", Color) = (1,1,1,1)
        _Speed("Speed",Float) = 1
        _Frequency("Frequency",Float) = 1
        _Size("Size", Float) = 1
       _Size1("Size1", Float) = 1
        _Amplitude("Amplitude", Float) = 1
    }
    SubShader
    {
        Tags{"Rendertype"="Transparent" "Queue"="Transparent" }
        // No culling or depth
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Frequency;
            float _Speed;
            fixed4 _MainColor;
            float _Size;
            float _Size1;
            float _Amplitude;
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mainTex = tex2D(_MainTex,i.uv);
                float2 uv = i.uv * 2 - 1;
                float center = length(uv) * _Size;
                center = 1 - center;
                saturate(center);
                
                
                float wave = sin(center *_Frequency + _Time.y*_Speed) * _Amplitude;
                //saturate(wave);
                
                float output = wave;
                
                clip(output);
                return fixed4(output.xxx,1) * _MainColor;
            }
            ENDCG
        }
    }
}
