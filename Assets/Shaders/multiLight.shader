Shader "Unlit/7_MultiLight"
{
    Properties
    {
        _DiffuseColor ("DiffuseColor", Color) = (1,1,1,1)
        _SpecularColor ("SpecularColor", Color) = (1,1,1,1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
        [KeywordEnum(OFF,ON)] _ADD_LIGHT("AdditionalLights", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline"}
       
        HLSLINCLUDE
        #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
        CBUFFER_START(UnityPerMaterial)
        float4 _DiffuseColor;
        float4 _SpecularColor;
        float _Gloss;
        CBUFFER_END
        ENDHLSL

        Pass
        {
            HLSLPROGRAM
            #include"Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _ADD_LIGHT_ON _ADD_LIGHT_OFF
            
            struct Attributes
            {
                float4 positionOS: POSITION;
                float3 normalOS: NORMAL;
                float4 tangentOS: TANGENT;
            };
            
            struct Varings
            {
                float4 positionCS: SV_POSITION;
                float3 positionWS: TEXCOORD;
                float3 normalWS: TEXCOORD1;
                float3 viewDirWS: TEXCOORD2;
            };
            
            Varings vert (Attributes i)
            {
                Varings o;
                VertexPositionInputs positionInputs = GetVertexPositionInputs(i.positionOS.xyz);
                o.positionCS = positionInputs.positionCS;
                o.positionWS = positionInputs.positionWS;
                
                VertexNormalInputs normalInput = GetVertexNormalInputs(i.normalOS, i.tangentOS);
                o.normalWS = NormalizeNormalPerVertex(normalInput.normalWS);
                o.viewDirWS = GetCameraPositionWS() - positionInputs.positionWS;
                
                return o;
            }
            
            real3 ShadeSingleLight(Light light, half3 normalWS, half3 viewDirectionWS, bool isAdditionalLight)
            {
                //half lambert
                half NdotL = saturate(dot(normalWS, light.direction))*0.5+0.5;
                half3 diffuseColor = light.color * (light.distanceAttenuation * NdotL) * _DiffuseColor;
                //blinn-phong
                half3 halfDir = normalize(light.direction+viewDirectionWS);
                half3 specularColor = light.color*pow(saturate(dot(normalWS, halfDir)), _Gloss) * _SpecularColor;
                
                return specularColor+diffuseColor;
            }
            
            half4 frag (Varings i) : SV_Target
            {
                half3 normalWS = NormalizeNormalPerPixel(i.normalWS);
                //safe防止分母为0
                half3 viewDirWS = SafeNormalize(i.viewDirWS);
                
                Light mainLight = GetMainLight();
                half3 mainLightResult = ShadeSingleLight(mainLight, normalWS, viewDirWS, false);
                
                half3 additionalLightsSumResult = 0;
                //这里不用#ifdef!!!!!
                //#if _AdditionalLights
                #if _ADD_LIGHT_ON
                    int additionalLightsCount = GetAdditionalLightsCount();
                    for(int lightIndex = 0; lightIndex < additionalLightsCount; ++ lightIndex)
                    {
                        Light additionalLight = GetAdditionalLight(lightIndex, i.positionWS);            
                        additionalLightsSumResult += ShadeSingleLight(additionalLight, normalWS, viewDirWS, true);
                    }
                    Light testLight = GetAdditionalLight(0, i.positionWS);
                    half3 testResult = ShadeSingleLight(testLight, normalWS, viewDirWS, true);
                #endif                
                half3 ambient = SampleSH(normalWS);
                

                                
               return half4(mainLightResult + additionalLightsSumResult, 1.0);
                //return half4(testResult,1.0);
            }
            ENDHLSL
        }
    }
}