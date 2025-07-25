// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Foil"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_FoilNormal("FoilNormal", 2D) = "white" {}
		_IsFrame("IsBorder", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite On
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float _IsFrame;
			uniform float4 _MainTex_ST;
			uniform sampler2D _FoilNormal;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				float3 ase_worldTangent = UnityObjectToWorldDir(IN.ase_tangent);
				OUT.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(IN.ase_normal);
				OUT.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = IN.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				OUT.ase_texcoord3.xyz = ase_worldBitangent;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				OUT.ase_texcoord1.w = 0;
				OUT.ase_texcoord2.w = 0;
				OUT.ase_texcoord3.w = 0;
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float4 color18_g1 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
				float border21_g1 = _IsFrame;
				float4 lerpResult19_g1 = lerp( color18_g1 , _Color , border21_g1);
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 texCoord77 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode11 = tex2D( _FoilNormal, texCoord77 );
				float3 appendResult76 = (float3(tex2DNode11.r , tex2DNode11.g , tex2DNode11.b));
				float3 ase_worldTangent = IN.ase_texcoord1.xyz;
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal73 = appendResult76;
				float3 worldNormal73 = float3(dot(tanToWorld0,tanNormal73), dot(tanToWorld1,tanNormal73), dot(tanToWorld2,tanNormal73));
				float3 objectSpaceViewDir101 = ObjSpaceViewDir( float4( 0,0,0,1 ) );
				float dotResult74 = dot( worldNormal73 , objectSpaceViewDir101 );
				float4 temp_output_107_0 = saturate( ( ( lerpResult19_g1 * tex2D( _MainTex, uv_MainTex ) ) + ( ( 1.0 - saturate( min( abs( dotResult74 ) , 0.9 ) ) ) / 2.0 ) ) );
				
				fixed4 c = saturate( temp_output_107_0 );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
-1872;138;1904;934;1643.267;286.1405;3.366867;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;9;689.3884,1278.145;Inherit;True;Property;_FoilNormal;FoilNormal;0;0;Create;True;0;0;0;False;0;False;None;72e133a3814c27c4791547e3accb0151;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;711.5396,1549.426;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;1049.79,1391.829;Inherit;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;76;1434.818,1410.616;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;73;1654.992,1476.62;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjSpaceViewDirHlpNode;101;1615.454,1728.78;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;74;1951.294,1557.492;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;112;2097.032,1550.599;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;105;2240.204,1468.587;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;80;2378.866,1545.57;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;1878.574,1000.605;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;51;1838.58,1092.895;Inherit;False;0;0;_Color;Shader;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;81;2561.781,1465.502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;79;2620.498,1198.132;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;116;2192.36,1022.57;Inherit;False;MF_CardBase;1;;1;8d4e347984fd2bf4f8d6a241ae916745;0;2;8;SAMPLER2D;0;False;11;COLOR;0,0,0,0;False;2;FLOAT;13;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;2618.837,1056.023;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;107;2793.032,1052.599;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;113;1997.04,1749.698;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;108;3189.032,1019.599;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;110;3014.318,1161.442;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3372.795,1021.333;Float;False;True;-1;2;ASEMaterialInspector;0;6;Foil;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;True;True;1;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;11;0;9;0
WireConnection;11;1;77;0
WireConnection;76;0;11;1
WireConnection;76;1;11;2
WireConnection;76;2;11;3
WireConnection;73;0;76;0
WireConnection;74;0;73;0
WireConnection;74;1;101;0
WireConnection;112;0;74;0
WireConnection;105;0;112;0
WireConnection;80;0;105;0
WireConnection;81;0;80;0
WireConnection;79;0;81;0
WireConnection;116;8;8;0
WireConnection;116;11;51;0
WireConnection;78;0;116;0
WireConnection;78;1;79;0
WireConnection;107;0;78;0
WireConnection;108;0;107;0
WireConnection;110;0;107;0
WireConnection;0;0;108;0
ASEEND*/
//CHKSM=C853CBA6D8DBC26408057215C9257602E467958A