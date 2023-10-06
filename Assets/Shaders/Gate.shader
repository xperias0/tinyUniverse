Shader "Unlit/Gate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1) 
        _Intensity ("Intensity", Range(0, 1)) = 1 
        _Speed ("Speed", Range(0, 1)) = 0.5 
        _Alpha("Alpha",Range(0,1)) =1 
        
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Geometry-100" } 
        Cull Off 
        Blend SrcAlpha OneMinusSrcAlpha
    
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 wldnormal :TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color; 
            float _Intensity; 
            float _Speed;
            float _Alpha;
            
            v2f vert (appdata v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = float4(v.uv, v.uv);
                o.wldnormal = UnityObjectToWorldNormal( v.normal);
				
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            	float2 uv = float2(i.uv.x+_Time.x*_Speed,i.uv.y+_Time.x*_Speed);
                fixed4 col = tex2D(_MainTex, uv);
				
				return fixed4(col.rgb,_Alpha); 
            }
            ENDCG
        }
    }
}
