// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shield3"
{
	Properties
	{
		_ShieldPattern("ShieldPattern", 2D) = "white" {}
		_ShieldPatternColor("ShieldPatternColor", Color) = (0,0.5409622,1,0)
		_ShieldPatternColor1("ShieldPatternColor", Color) = (0,0.5409622,1,0)
		_IntersectionColor("IntersectionColor", Color) = (0,0.5409622,1,0)
		_PatternSpeed("PatternSpeed", Range( -1 , 1)) = 0
		_WaveS("WaveS", Range( -1 , 1)) = 0
		_ShieldRimPower("ShieldRimPower", Range( 0 , 5)) = 7
		_PatternSize("PatternSize", Range( 1 , 15)) = 5
		_FresnelScale("FresnelScale", Range( 1 , 10)) = 1
		_WaveTexture("WaveTexture", 2D) = "white" {}
		_ShieldPatternPower("ShieldPatternPower", Range( 0 , 100)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0.3383762
		_IntersectionPower("IntersectionPower", Range( 0 , 0.3)) = 0
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
		uniform float4 _IntersectionColor;
		uniform sampler2D _WaveTexture;
		uniform float _WaveS;
		uniform float4 _ShieldPatternColor;
		uniform sampler2D _ShieldPattern;
		uniform float _PatternSize;
		uniform float _PatternSpeed;
		uniform float4 _ShieldPatternColor1;
		uniform float _FresnelScale;
		uniform float _ShieldRimPower;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _IntersectionPower;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime70 = _Time.y * _WaveS;
			float2 appendResult49 = (float2(1 , ( 1.0 - ( mulTime70 / 5.0 ) )));
			float2 uv_TexCoord45 = i.uv_texcoord * float2( 1,1 ) + appendResult49;
			float4 WavePattern90 = tex2D( _WaveTexture, uv_TexCoord45 );
			float2 appendResult14 = (float2(_PatternSize , _PatternSize));
			float2 appendResult19 = (float2(1 , ( _Time.y * _PatternSpeed )));
			float2 uv_TexCoord18 = i.uv_texcoord * appendResult14 + appendResult19;
			float4 MainPattern87 = ( _ShieldPatternColor * tex2D( _ShieldPattern, uv_TexCoord18 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV12 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode12 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV12, (10.0 + (_ShieldRimPower - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) );
			float4 Fresnel82 = ( _ShieldPatternColor1 * fresnelNode12 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth73 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth73 = abs( ( screenDepth73 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _IntersectionPower ) );
			float clampResult74 = clamp( distanceDepth73 , 0.0 , 1.0 );
			float Intersection78 = clampResult74;
			float4 lerpResult75 = lerp( _IntersectionColor , ( WavePattern90 * ( MainPattern87 + Fresnel82 ) ) , Intersection78);
			float4 ToEmission93 = ( _ShieldPatternPower * lerpResult75 );
			o.Emission = ToEmission93.rgb;
			o.Alpha = _Opacity;
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
0;655;1499;336;1079.172;650.4446;1.601588;True;False
Node;AmplifyShaderEditor.CommentaryNode;86;-2533.104,52.32253;Inherit;False;1776.452;570.7136;;12;87;4;2;3;18;19;14;21;13;17;15;16;Main Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;89;-2197.342,-548.1733;Inherit;False;1868.107;473.2816;;11;90;52;50;48;49;71;47;45;44;51;70;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2473.566,502.1577;Inherit;False;Property;_PatternSpeed;PatternSpeed;4;0;Create;True;0;0;0;False;0;False;0;0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-2373.263,422.6457;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2147.342,-277.4221;Inherit;False;Property;_WaveS;WaveS;5;0;Create;True;0;0;0;False;0;False;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-2037.043,357.3148;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;52;-1859.872,-199.8383;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2160.456,277.6407;Inherit;False;Property;_PatternSize;PatternSize;7;0;Create;True;0;0;0;False;0;False;5;2.9;1;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;70;-1885.097,-289.8866;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-1840.458,791.4896;Inherit;False;1368.436;552.009;;7;10;24;11;80;12;81;82;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-2178.367,448.2378;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1790.458,1123.154;Inherit;False;Property;_ShieldRimPower;ShieldRimPower;6;0;Create;True;0;0;0;False;0;False;7;0.23;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-1686.991,-241.3736;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1876.248,267.3732;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1878.28,426.4474;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1569.057,1045.526;Inherit;False;Property;_FresnelScale;FresnelScale;8;0;Create;True;0;0;0;False;0;False;1;3.12;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;48;-1518.19,-398.1734;Inherit;False;Constant;_Vector2;Vector 2;12;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1714.5,312.3109;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;11;-1483.938,1140.699;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;50;-1522.19,-246.9735;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;47;-1341.391,-498.1733;Inherit;False;Constant;_Vector1;Vector 1;12;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;80;-1190.142,841.4896;Inherit;False;Property;_ShieldPatternColor1;ShieldPatternColor;2;0;Create;True;0;0;0;False;0;False;0,0.5409622,1,0;0.6075705,0,0.7735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;12;-1251.351,1006.695;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-1424.539,102.3225;Inherit;False;Property;_ShieldPatternColor;ShieldPatternColor;1;0;Create;True;0;0;0;False;0;False;0,0.5409622,1,0;0.6075705,0,0.7735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1332.59,-343.7735;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;84;-380.7927,824.4189;Inherit;False;1061.095;228.4537;;4;72;73;74;78;Intersection;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-1451.778,282.3615;Inherit;True;Property;_ShieldPattern;ShieldPattern;0;0;Create;True;0;0;0;False;0;False;-1;None;541550711632f094a807837cb822f7eb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1137.246,-380.5123;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-330.7927,874.4189;Inherit;False;Property;_IntersectionPower;IntersectionPower;12;0;Create;True;0;0;0;False;0;False;0;0.2;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1149.62,110.0635;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-929.0551,903.1197;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;92;-612.8239,-1.920646;Inherit;False;1266.129;644.2892;;10;83;88;91;22;76;77;79;75;56;57;Put Together to Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-970.8185,104.2858;Inherit;False;MainPattern;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;73;-58.38486,884.8963;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-885.6022,-408.8138;Inherit;True;Property;_WaveTexture;WaveTexture;9;0;Create;True;0;0;0;False;0;False;-1;None;8bded9c1053755d48ab0cf2aca4f1613;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-711.4214,943.1198;Inherit;False;Fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-548.3444,488.3832;Inherit;False;82;Fresnel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-562.8239,381.0272;Inherit;False;87;MainPattern;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-541.7385,-407.9874;Inherit;False;WavePattern;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;74;244.5328,884.0482;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;440.9023,937.7126;Inherit;False;Intersection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-289.1138,389.2085;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-281.4622,234.6115;Inherit;False;90;WavePattern;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-52.45937,365.179;Inherit;False;78;Intersection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;-122.271,48.07936;Inherit;False;Property;_IntersectionColor;IntersectionColor;3;0;Create;True;0;0;0;False;0;False;0,0.5409622,1,0;1,0,0.01646233,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-57.38448,243.6363;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;75;171.3806,215.5273;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;182.5179,117.4003;Inherit;False;Property;_ShieldPatternPower;ShieldPatternPower;10;0;Create;True;0;0;0;False;0;False;0;10.4;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;485.7654,189.2987;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;697.2347,180.2226;Inherit;False;ToEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;94.71892,-426.0409;Inherit;False;Property;_Opacity;Opacity;11;0;Create;True;0;0;0;False;0;False;0.3383762;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;147.6406,-593.0097;Inherit;False;93;ToEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;65;383.8764,-633.997;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shield3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;0;71;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;51;0;70;0
WireConnection;51;1;52;0
WireConnection;14;0;13;0
WireConnection;14;1;13;0
WireConnection;19;0;21;1
WireConnection;19;1;17;0
WireConnection;18;0;14;0
WireConnection;18;1;19;0
WireConnection;11;0;10;0
WireConnection;50;0;51;0
WireConnection;12;2;24;0
WireConnection;12;3;11;0
WireConnection;49;0;48;1
WireConnection;49;1;50;0
WireConnection;2;1;18;0
WireConnection;45;0;47;0
WireConnection;45;1;49;0
WireConnection;4;0;3;0
WireConnection;4;1;2;0
WireConnection;81;0;80;0
WireConnection;81;1;12;0
WireConnection;87;0;4;0
WireConnection;73;0;72;0
WireConnection;44;1;45;0
WireConnection;82;0;81;0
WireConnection;90;0;44;0
WireConnection;74;0;73;0
WireConnection;78;0;74;0
WireConnection;22;0;88;0
WireConnection;22;1;83;0
WireConnection;76;0;91;0
WireConnection;76;1;22;0
WireConnection;75;0;77;0
WireConnection;75;1;76;0
WireConnection;75;2;79;0
WireConnection;57;0;56;0
WireConnection;57;1;75;0
WireConnection;93;0;57;0
WireConnection;65;2;94;0
WireConnection;65;9;66;0
ASEEND*/
//CHKSM=BF76ABE75CE55FAC5331BF42AD0E97D37C610690