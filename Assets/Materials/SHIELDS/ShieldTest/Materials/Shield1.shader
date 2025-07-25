// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shield1"
{
	Properties
	{
		_ShieldPattern("ShieldPattern", 2D) = "white" {}
		_ShieldPatternColor("ShieldPatternColor", Color) = (0,0.5409622,1,0)
		_PatternSpeed("PatternSpeed", Range( -1 , 1)) = 0
		_ShieldRimPower("ShieldRimPower", Range( 0 , 5)) = 7
		_PatternSize("PatternSize", Range( 2 , 15)) = 5
		_FresnelScale("FresnelScale", Range( 1 , 10)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_ShieldPatternPower("ShieldPatternPower", Range( 0 , 100)) = 0
		_OpacityPower("OpacityPower", Range( 0 , 1)) = 0.3383762
		_IntersectionPower("IntersectionPower", Range( 0 , 0.3)) = 0
		_IntersectColor("Intersect Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float4 screenPos;
		};

		uniform float _ShieldPatternPower;
		uniform float4 _IntersectColor;
		uniform sampler2D _TextureSample1;
		uniform float _PatternSpeed;
		uniform float4 _ShieldPatternColor;
		uniform sampler2D _ShieldPattern;
		uniform float _PatternSize;
		uniform float _FresnelScale;
		uniform float _ShieldRimPower;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _IntersectionPower;
		uniform float _OpacityPower;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_17_0 = ( _Time.y * _PatternSpeed );
			float2 appendResult49 = (float2(1 , ( 1.0 - ( temp_output_17_0 / 5.0 ) )));
			float2 uv_TexCoord45 = i.uv_texcoord * float2( 1,1 ) + appendResult49;
			float2 appendResult14 = (float2(_PatternSize , _PatternSize));
			float2 appendResult19 = (float2(1 , temp_output_17_0));
			float2 uv_TexCoord18 = i.uv_texcoord * appendResult14 + appendResult19;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV12 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode12 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV12, (10.0 + (_ShieldRimPower - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth69 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth69 = abs( ( screenDepth69 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _IntersectionPower ) );
			float clampResult70 = clamp( distanceDepth69 , 0.0 , 1.0 );
			float4 lerpResult71 = lerp( _IntersectColor , ( tex2D( _TextureSample1, uv_TexCoord45 ) * ( ( _ShieldPatternColor * tex2D( _ShieldPattern, uv_TexCoord18 ) ) + fresnelNode12 ) ) , clampResult70);
			o.Emission = ( _ShieldPatternPower * lerpResult71 ).rgb;
			o.Alpha = _OpacityPower;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
572.8;73.6;555.6;426.2;909.5426;856.5908;4.001541;True;False
Node;AmplifyShaderEditor.RangedFloatNode;16;-2361.165,423.0644;Inherit;False;Property;_PatternSpeed;PatternSpeed;2;0;Create;True;0;0;0;False;0;False;0;-0.59;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-2260.861,343.5525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-2065.965,369.1446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-1584.485,283.9663;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;53;-2005.605,-167.8503;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1707.897,204.2923;Inherit;False;Property;_PatternSize;PatternSize;4;0;Create;True;0;0;0;False;0;False;5;5;2;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1970.538,-129.3118;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1423.69,194.0248;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-1797.657,-170.8472;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1425.722,353.099;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;48;-1628.856,-327.6469;Inherit;False;Constant;_Vector2;Vector 2;12;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1261.941,238.9625;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;50;-1632.856,-176.4471;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1529.538,727.1459;Inherit;False;Property;_ShieldRimPower;ShieldRimPower;3;0;Create;True;0;0;0;False;0;False;7;0.63;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1443.257,-273.247;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;3;-962.4417,-20.61983;Inherit;False;Property;_ShieldPatternColor;ShieldPatternColor;1;0;Create;True;0;0;0;False;0;False;0,0.5409622,1,0;0,0.717689,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;11;-1223.018,744.6902;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1308.137,649.518;Inherit;False;Property;_FresnelScale;FresnelScale;5;0;Create;True;0;0;0;False;0;False;1;2.83;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-999.2181,209.0131;Inherit;True;Property;_ShieldPattern;ShieldPattern;0;0;Create;True;0;0;0;False;0;False;-1;None;a95bf2f5793e53040a502409c0a4a6ce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;47;-1452.057,-427.6468;Inherit;False;Constant;_Vector1;Vector 1;12;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1247.912,-309.9858;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-701.3547,41.01001;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;12;-990.4313,610.6866;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-464.2439,476.0444;Inherit;False;Property;_IntersectionPower;IntersectionPower;9;0;Create;True;0;0;0;False;0;False;0;0.109;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-996.2675,-338.2873;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;2857526e21dad664fa77fedc2981eb86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-437.5727,150.5232;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;69;-194.8484,417.2293;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;70;113.7515,446.6875;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;-201.0885,-222.0758;Inherit;False;Property;_IntersectColor;Intersect Color;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2150944,0.2150944,0.2150944,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-208.7746,-16.27669;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;71;168.6475,-48.76152;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;170.8291,-195.4377;Inherit;False;Property;_ShieldPatternPower;ShieldPatternPower;7;0;Create;True;0;0;0;False;0;False;0;50;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;425.6129,-66.64727;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;311.313,173.9367;Inherit;False;Property;_OpacityPower;OpacityPower;8;0;Create;True;0;0;0;False;0;False;0.3383762;0.162;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;65;645.3593,-120.9599;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shield1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;53;0;17;0
WireConnection;14;0;13;0
WireConnection;14;1;13;0
WireConnection;51;0;53;0
WireConnection;51;1;52;0
WireConnection;19;0;21;1
WireConnection;19;1;17;0
WireConnection;18;0;14;0
WireConnection;18;1;19;0
WireConnection;50;0;51;0
WireConnection;49;0;48;1
WireConnection;49;1;50;0
WireConnection;11;0;10;0
WireConnection;2;1;18;0
WireConnection;45;0;47;0
WireConnection;45;1;49;0
WireConnection;4;0;3;0
WireConnection;4;1;2;0
WireConnection;12;2;24;0
WireConnection;12;3;11;0
WireConnection;44;1;45;0
WireConnection;22;0;4;0
WireConnection;22;1;12;0
WireConnection;69;0;68;0
WireConnection;70;0;69;0
WireConnection;43;0;44;0
WireConnection;43;1;22;0
WireConnection;71;0;72;0
WireConnection;71;1;43;0
WireConnection;71;2;70;0
WireConnection;57;0;56;0
WireConnection;57;1;71;0
WireConnection;65;2;57;0
WireConnection;65;9;66;0
ASEEND*/
//CHKSM=188BD0592207857CB341E6CEEB0894A42B13FA7F