Shader "Unlit/multiLightEarthShader"
{
     Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Main Color",Color) = (1,1,1,1)
        _PixelLightIntensity("Pixel Light Intensity",Float) = 1
        _DiffuseColor("DiffuseLight Color",Color) = (1,1,1,1)
        _Gloss("Gloss",Float) = 1 
        _SpecularColor("SpecularLigh Color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Geometry" "RenderPipeline" = "UniversalRenderPipeline"}
        LOD 100
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            
             #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
             #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
             #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/SpaceTransforms.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float3 wldVertex : TEXCOORD2;
                float3 wldNormal : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _MainColor;
            half _PixelLightIntensity;
            half4 _DiffuseColor;
            half4 _SpecularColor;
            half _Gloss;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.wldVertex = mul( GetObjectToWorldMatrix(),v.vertex);
                VertexNormalInputs normalInput = GetVertexNormalInputs( v.normal, v.tangent );
                o.wldNormal = TransformObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }
            half3 ShadeSingleLight(Light light, half3 normalWS, half3 viewDirectionWS)
            {
                
                half NdotL = saturate(dot(normalWS, light.direction))*0.5+0.5;
                half3 diffuseColor = light.color * (light.distanceAttenuation * NdotL *_PixelLightIntensity) * _DiffuseColor;
                
                half3 halfDir = normalize(light.direction+viewDirectionWS);
                half3 specularColor = light.color*pow(saturate(dot(normalWS, halfDir)), _Gloss) * _SpecularColor;
                
                return specularColor+diffuseColor;
            }
            
            half4 frag (v2f i) : SV_Target
            {
                
                half4 mainTex  = tex2D(_MainTex,i.uv);
                half3 finalCol = (0.1,0.1,0.1);
                half3 wldNormal = normalize( i.wldNormal);
                float3 viewDir = SafeNormalize(GetCameraPositionWS() - i.wldVertex);
                float3 wldPos  = i.wldVertex; 
                Light mainLight = GetMainLight();
                
                half3 diffuseLight = saturate( dot(mainLight.direction,wldNormal ) ) * mainLight.color;
                
                #ifdef _ADDITIONAL_LIGHTS
                    int pixelLightCount = GetAdditionalLightsCount();
                    for(int i=0;i<pixelLightCount;++i)
                    {
                        Light light = GetAdditionalLight(i,wldPos);
                        half3 col = light.color *(light.distanceAttenuation * light.shadowAttenuation * _PixelLightIntensity);
                        half LdotN = saturate( dot(light.direction , wldNormal));
                        finalCol += ShadeSingleLight(light,wldNormal,viewDir);
                    }
                        
                #endif
                //sfinalCol += diffuseLight;
                return half4(finalCol.rbg,1) * _MainColor;
            }
            ENDHLSL
        }
    }
}
