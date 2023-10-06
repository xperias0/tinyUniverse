Shader "Unlit/EarthMat"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Color", Color) = (1,1,1,1)
        _AmbientLightColor("AmbientLight Color",Color) = (1,1,1,1)
        _AmbinetLightIntensity("AmbientLight Intensity",Range(0,1)) = 1
        _SpecularLightIntensity("Specular Intensity",Range(0,1)) = 1
        _SpecularLightFactor("SpecularLight Factor",Float) = 1
        _Height("Height",Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry+10" "LightMode"="UniversalForward"}
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            //#pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "Assets/Shaders/BaseLight.cginc"
            
            ENDCG
        }
        
        
    }
}
