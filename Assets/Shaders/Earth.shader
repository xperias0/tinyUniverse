Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Color", Color) = (1,1,1,1)
        _AmbientLightColor("AmbientLight Color",Color) = (1,1,1,1)
        _AmbinetLightIntensity("AmbientLight Intensity",Range(0,1)) = 1
        _SpecularLightIntensity("Specular Intensity",Float) = 1
        _SmoothNess("Smoothness",Float) = 1
    }
    SubShader
    {
        Tags {"RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

           
            #include "Assets/Shaders/BaseLight.cginc"
            
            ENDCG
        }
    }
}
