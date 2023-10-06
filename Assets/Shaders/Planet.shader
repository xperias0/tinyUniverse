Shader "Unlit/Planet"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EmissiveColorMap("Emissive ColorMap", 2D) = "white"{}
        [HDR]_EmissiveColor("Emissive Color",Color) = (1,1,1,1)
        _EmissiveColorIntensity("Emissive Intensity", Float) = 1
        [KeywordEnum(EmissiveColor_On,EmissiveColor_Off)]_EmissiveColorMode("Emissive Color Mode",Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry-100"}
        //Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        
        ZTest GEqual
        ZWrite OFF
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile _EMISSIVECOLORMODE_EMISSIVECOLOR_ON _EMISSIVECOLORMODE_EMISSIVECOLOR_OFF
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal :NORMAL;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 wldPos : TEXCOORD1;
                float3 wldNormal : TEXCOORD2;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _EmissiveColorMap;
            float4 _EmissiveColor;
            float _EmissiveColorIntensity;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                o.wldPos = mul(unity_ObjectToWorld,o.vertex);
                o.wldNormal = UnityObjectToWorldNormal(v.normal);
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                float4 LightDir = normalize(float4(_WorldSpaceLightPos0.xyz,1));
                float3 wldNormal = normalize(i.wldNormal);
                fixed4 emissiveColor = tex2D(_EmissiveColorMap,i.uv) * _EmissiveColor * _EmissiveColorIntensity;
                
                
                fixed4 col = tex2D(_MainTex, i.uv);
                float diffuseLightFalloff =saturate( dot(LightDir,wldNormal) ) ;
                fixed3 diffuseLight = diffuseLightFalloff * unity_LightColor0 * col;
                
                fixed4 finalColor = col ;
               

                #ifdef _EMISSIVECOLORMODE_EMISSIVECOLOR_ON
                    return finalColor + emissiveColor;
                #endif

                #ifdef _EMISSIVECOLORMODE_EMISSIVECOLOR_OFF
                     return finalColor;
                #endif
                
            }
            ENDCG
        }
    }
}
