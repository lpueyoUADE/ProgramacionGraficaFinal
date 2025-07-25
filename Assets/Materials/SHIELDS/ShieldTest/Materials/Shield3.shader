// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shield3"
{
	Properties
	{
		_ShieldPattern("ShieldPattern", 2D) = "white" {}
		_ShieldPatternColor("ShieldPatternColor", Color) = (0,0.5409622,1,0)
		_PatternSpeed("PatternSpeed", Range( -1 , 1)) = 0
		_WaveS("WaveS", Range( -1 , 1)) = 0
		_ShieldRimPower("ShieldRimPower", Range( 0 , 5)) = 7
		_PatternSize("PatternSize", Range( 1 , 15)) = 5
		_FresnelScale("FresnelScale", Range( 1 , 10)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_ShieldPatternPower("ShieldPatternPower", Range( 0 , 100)) = 0
		_OpacityPower("OpacityPower", Range( 0 , 1)) = 0.3383762
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _ShieldPatternPower;
		uniform sampler2D _TextureSample1;
		uniform float _WaveS;
		uniform float4 _ShieldPatternColor;
		uniform sampler2D _ShieldPattern;
		uniform float _PatternSize;
		uniform float _PatternSpeed;
		uniform float _FresnelScale;
		uniform float _ShieldRimPower;
		uniform float _OpacityPower;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime70 = _Time.y * _WaveS;
			float2 appendResult49 = (float2(1 , ( 1.0 - ( mulTime70 / 5.0 ) )));
			float2 uv_TexCoord45 = i.uv_texcoord * float2( 1,1 ) + appendResult49;
			float4 tex2DNode44 = tex2D( _TextureSample1, uv_TexCoord45 );
			float2 appendResult14 = (float2(_PatternSize , _PatternSize));
			float2 appendResult19 = (float2(1 , ( _Time.y * _PatternSpeed )));
			float2 uv_TexCoord18 = i.uv_texcoord * appendResult14 + appendResult19;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV12 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode12 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV12, (10.0 + (_ShieldRimPower - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) );
			o.Emission = ( _ShieldPatternPower * ( tex2DNode44 * ( ( _ShieldPatternColor * tex2D( _ShieldPattern, uv_TexCoord18 ) ) + fresnelNode12 ) ) ).rgb;
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
				float3 worldNormal : TEXCOORD3;
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
572.8;73.6;555.6;426.2;1829.458;511.1083;1.711557;False;False
Node;AmplifyShaderEditor.RangedFloatNode;16;-1908.323,495.9796;Inherit;False;Property;_PatternSpeed;PatternSpeed;3;0;Create;True;0;0;0;False;0;False;0;0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1754.669,-299.1526;Inherit;False;Property;_WaveS;WaveS;4;0;Create;True;0;0;0;False;0;False;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1808.019,416.4677;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;70;-1492.424,-311.6171;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1404.224,-133.0622;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1613.123,442.0598;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1366.345,273.3699;Inherit;False;Property;_PatternSize;PatternSize;6;0;Create;True;0;0;0;False;0;False;5;1;1;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-1242.933,353.0439;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-1231.343,-174.5975;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1084.17,422.1766;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1082.138,263.1024;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;50;-1066.542,-180.1974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-920.39,308.0401;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;48;-1062.542,-331.3973;Inherit;False;Constant;_Vector2;Vector 2;12;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-1189.086,749.8427;Inherit;False;Property;_ShieldRimPower;ShieldRimPower;5;0;Create;True;0;0;0;False;0;False;7;0.23;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;11;-882.5665,767.387;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-620.8918,48.45779;Inherit;False;Property;_ShieldPatternColor;ShieldPatternColor;1;0;Create;True;0;0;0;False;0;False;0,0.5409622,1,0;0.6075705,0,0.7735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-657.6682,278.0907;Inherit;True;Property;_ShieldPattern;ShieldPattern;0;0;Create;True;0;0;0;False;0;False;-1;None;541550711632f094a807837cb822f7eb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-967.685,672.2148;Inherit;False;Property;_FresnelScale;FresnelScale;7;0;Create;True;0;0;0;False;0;False;1;5.6;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-876.9423,-276.9974;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;47;-885.7425,-431.3972;Inherit;False;Constant;_Vector1;Vector 1;12;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FresnelNode;12;-649.9797,633.3834;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-359.8046,110.0876;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-681.5974,-313.7362;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;-429.9539,-342.0377;Inherit;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;0;False;0;False;-1;None;8bded9c1053755d48ab0cf2aca4f1613;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-209.2623,213.4161;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-36.6133,-179.3033;Inherit;False;Property;_ShieldPatternPower;ShieldPatternPower;11;0;Create;True;0;0;0;False;0;False;0;6.3;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;41.58025,94.10667;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;1172.762,1982.921;Inherit;False;Property;_Opacity;Opacity;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;370.5773,1816.082;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;69;336.6218,354.2446;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;103.8706,190.0711;Inherit;False;Property;_OpacityPower;OpacityPower;12;0;Create;True;0;0;0;False;0;False;0.3383762;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;61;550.389,-305.0897;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;404.7618,1918.921;Inherit;False;Property;_Frecuency;Frecuency;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;724.7618,1870.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;60;1028.762,2014.921;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;212.7616,2126.921;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;436.7618,2126.921;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;218.1705,-50.51289;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;26;346.7245,1657.357;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;580.7615,1982.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;36;884.7617,1934.921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;33;452.7618,2030.921;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;67;184.9929,405.757;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;559.1809,1740.063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;68;17.11587,398.2177;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;94.15173,1820.924;Inherit;False;Property;_WaveSpeed;WaveSpeed;8;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;65;437.9168,-104.8255;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shield3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;0;71;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;51;0;70;0
WireConnection;51;1;52;0
WireConnection;19;0;21;1
WireConnection;19;1;17;0
WireConnection;14;0;13;0
WireConnection;14;1;13;0
WireConnection;50;0;51;0
WireConnection;18;0;14;0
WireConnection;18;1;19;0
WireConnection;11;0;10;0
WireConnection;2;1;18;0
WireConnection;49;0;48;1
WireConnection;49;1;50;0
WireConnection;12;2;24;0
WireConnection;12;3;11;0
WireConnection;4;0;3;0
WireConnection;4;1;2;0
WireConnection;45;0;47;0
WireConnection;45;1;49;0
WireConnection;44;1;45;0
WireConnection;22;0;4;0
WireConnection;22;1;12;0
WireConnection;43;0;44;0
WireConnection;43;1;22;0
WireConnection;27;0;28;0
WireConnection;69;0;67;0
WireConnection;61;0;44;0
WireConnection;31;0;30;0
WireConnection;31;1;34;0
WireConnection;57;0;56;0
WireConnection;57;1;43;0
WireConnection;34;0;32;0
WireConnection;34;1;33;0
WireConnection;36;0;31;0
WireConnection;67;0;68;0
WireConnection;30;0;26;2
WireConnection;30;1;27;0
WireConnection;65;2;57;0
WireConnection;65;9;66;0
ASEEND*/
//CHKSM=114E5CB63D3AA0524423C2C93AD5C65E057080AC