// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShieldTest"
{
	Properties
	{
		_ShieldPattern("ShieldPattern", 2D) = "white" {}
		_ShieldPatternColor("ShieldPatternColor", Color) = (0,0.5409622,1,0)
		_PatternSpeed("PatternSpeed", Range( -1 , 1)) = 0
		_ShieldRimPower("ShieldRimPower", Range( 0 , 10)) = 7
		_PatternSize("PatternSize", Range( 2 , 15)) = 5
		_FresnelScale("FresnelScale", Range( 1 , 10)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_ShieldPatternPower("ShieldPatternPower", Range( 0 , 100)) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _ShieldPatternPower;
			uniform sampler2D _TextureSample1;
			uniform float _PatternSpeed;
			uniform float4 _ShieldPatternColor;
			uniform sampler2D _ShieldPattern;
			uniform float _PatternSize;
			uniform float _FresnelScale;
			uniform float _ShieldRimPower;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float temp_output_17_0 = ( _Time.y * _PatternSpeed );
				float2 appendResult49 = (float2(1 , ( 1.0 - ( temp_output_17_0 / 5.0 ) )));
				float2 texCoord45 = i.ase_texcoord1.xy * float2( 1,1 ) + appendResult49;
				float4 tex2DNode44 = tex2D( _TextureSample1, texCoord45 );
				float2 appendResult14 = (float2(_PatternSize , _PatternSize));
				float2 appendResult19 = (float2(1 , temp_output_17_0));
				float2 texCoord18 = i.ase_texcoord1.xy * appendResult14 + appendResult19;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float fresnelNdotV12 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode12 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV12, (10.0 + (_ShieldRimPower - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) );
				
				
				finalColor = ( _ShieldPatternPower * ( tex2DNode44 * ( ( _ShieldPatternColor * tex2D( _ShieldPattern, texCoord18 ) ) + fresnelNode12 ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
688.8;73.6;522.0001;463.8;1125.862;1379.592;4.817264;True;False
Node;AmplifyShaderEditor.RangedFloatNode;16;-1908.323,495.9796;Inherit;False;Property;_PatternSpeed;PatternSpeed;3;0;Create;True;0;0;0;False;0;False;0;0.4375115;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1808.019,416.4677;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1613.123,442.0598;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1404.224,-133.0622;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;53;-1439.291,-171.6006;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-1242.933,353.0439;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;13;-1366.345,273.3699;Inherit;False;Property;_PatternSize;PatternSize;5;0;Create;True;0;0;0;False;0;False;5;5;2;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-1231.343,-174.5975;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1084.17,422.1766;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1082.138,263.1024;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;48;-1062.542,-331.3973;Inherit;False;Constant;_Vector2;Vector 2;12;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-920.39,308.0401;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;50;-1066.542,-180.1974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1189.086,749.8427;Inherit;False;Property;_ShieldRimPower;ShieldRimPower;4;0;Create;True;0;0;0;False;0;False;7;7;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;47;-885.7425,-431.3972;Inherit;False;Constant;_Vector1;Vector 1;12;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;49;-876.9423,-276.9974;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-967.685,672.2148;Inherit;False;Property;_FresnelScale;FresnelScale;6;0;Create;True;0;0;0;False;0;False;1;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;11;-889.7664,753.7868;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-657.6682,278.0907;Inherit;True;Property;_ShieldPattern;ShieldPattern;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-620.8918,48.45779;Inherit;False;Property;_ShieldPatternColor;ShieldPatternColor;1;0;Create;True;0;0;0;False;0;False;0,0.5409622,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-359.8046,110.0876;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;12;-649.9797,633.3834;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-681.5974,-313.7362;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-209.2623,213.4161;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;-429.9539,-342.0377;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-36.6133,-179.3033;Inherit;False;Property;_ShieldPatternPower;ShieldPatternPower;10;0;Create;True;0;0;0;False;0;False;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;41.58025,94.10667;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;36;884.7617,1934.921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;60;1028.762,2014.921;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;26;346.7245,1657.357;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-294.705,-58.22474;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;559.1809,1740.063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;1172.762,1982.921;Inherit;False;Property;_Opacity;Opacity;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;404.7618,1918.921;Inherit;False;Property;_Frecuency;Frecuency;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;436.7618,2126.921;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;724.7618,1870.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;94.15173,1820.924;Inherit;False;Property;_WaveSpeed;WaveSpeed;7;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;212.7616,2126.921;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;370.5773,1816.082;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;218.1705,-50.51289;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;61;585.5197,-83.3275;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TauNode;33;452.7618,2030.921;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;580.7615,1982.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;64;1097.48,60.2109;Float;False;True;-1;2;ASEMaterialInspector;100;1;ShieldTest;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;-1;1;False;-1;0;2;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;53;0;17;0
WireConnection;51;0;53;0
WireConnection;51;1;52;0
WireConnection;19;0;21;1
WireConnection;19;1;17;0
WireConnection;14;0;13;0
WireConnection;14;1;13;0
WireConnection;18;0;14;0
WireConnection;18;1;19;0
WireConnection;50;0;51;0
WireConnection;49;0;48;1
WireConnection;49;1;50;0
WireConnection;11;0;10;0
WireConnection;2;1;18;0
WireConnection;4;0;3;0
WireConnection;4;1;2;0
WireConnection;12;2;24;0
WireConnection;12;3;11;0
WireConnection;45;0;47;0
WireConnection;45;1;49;0
WireConnection;22;0;4;0
WireConnection;22;1;12;0
WireConnection;44;1;45;0
WireConnection;43;0;44;0
WireConnection;43;1;22;0
WireConnection;36;0;31;0
WireConnection;30;0;26;2
WireConnection;30;1;27;0
WireConnection;31;0;30;0
WireConnection;31;1;34;0
WireConnection;27;0;28;0
WireConnection;57;0;56;0
WireConnection;57;1;43;0
WireConnection;61;0;44;0
WireConnection;34;0;32;0
WireConnection;34;1;33;0
WireConnection;64;0;57;0
ASEEND*/
//CHKSM=EBB848EACF8B61A1FE630C96B0944C604E2940F9