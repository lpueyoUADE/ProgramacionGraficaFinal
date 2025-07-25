// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RainbowFoil"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_Pattern("Pattern", 2D) = "white" {}
		_IsFrame("IsBorder", Float) = 0
		_FrameIntensity("FrameIntensity", Float) = 0.9
		_DisplayIntensity("DisplayIntensity", Float) = 0.5
		_ColorRamp("ColorRamp", 2D) = "white" {}
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
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float _IsFrame;
			uniform float4 _MainTex_ST;
			uniform sampler2D _ColorRamp;
			uniform sampler2D _Pattern;
			uniform float _DisplayIntensity;
			uniform float _FrameIntensity;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				float3 ase_worldPos = mul(unity_ObjectToWorld, IN.vertex).xyz;
				OUT.ase_texcoord1.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(IN.ase_normal);
				OUT.ase_texcoord2.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				OUT.ase_texcoord1.w = 0;
				OUT.ase_texcoord2.w = 0;
				
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

				float4 color18_g11 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
				float border21_g11 = _IsFrame;
				float4 lerpResult19_g11 = lerp( color18_g11 , _Color , border21_g11);
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_output_6_0 = ( lerpResult19_g11 * tex2D( _MainTex, uv_MainTex ) );
				float3 ase_worldPos = IN.ase_texcoord1.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float dotResult1_g12 = dot( ase_worldViewDir , ase_worldNormal );
				float temp_output_21_0 = dotResult1_g12;
				float2 texCoord11 = IN.texcoord.xy * float2( 0.25,1 ) + float2( 1,0 );
				float2 panner12 = ( temp_output_21_0 * float2( 0.5,0 ) + texCoord11);
				float2 texCoord5 = IN.texcoord.xy * float2( 0.5,1.25 ) + float2( 0,0 );
				float lerpResult7 = lerp( _DisplayIntensity , _FrameIntensity , border21_g11);
				float4 lerpResult18 = lerp( temp_output_6_0 , tex2D( _ColorRamp, panner12 ) , saturate( ( temp_output_21_0 * ( tex2D( _Pattern, texCoord5 ).r * lerpResult7 ) ) ));
				float A17 = (temp_output_6_0).a;
				float4 appendResult20 = (float4(lerpResult18.rgb , A17));
				
				fixed4 c = appendResult20;
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
-1930;112;1904;706;2153.46;468.8207;1.3;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-1477.797,-285.1058;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;3;-1468.272,-188.2009;Inherit;False;0;0;_Color;Shader;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1596.826,268.8162;Inherit;False;Property;_DisplayIntensity;DisplayIntensity;5;0;Create;True;0;0;0;False;0;False;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1842.248,701.7913;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,1.25;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1595.726,344.4162;Inherit;False;Property;_FrameIntensity;FrameIntensity;4;0;Create;True;0;0;0;False;0;False;0.9;0.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;6;-1234.272,-207.7009;Inherit;False;MF_CardBase;1;;11;8d4e347984fd2bf4f8d6a241ae916745;0;2;8;SAMPLER2D;0;False;11;COLOR;0,0,0,0;False;2;FLOAT;13;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1991.088,478.6641;Inherit;True;Property;_Pattern;Pattern;0;0;Create;True;0;0;0;False;0;False;None;3bb09ef40bd31b243bebe920988fbfcf;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;8;-1580.919,483.2611;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-1274.505,276.7573;Inherit;False;3;0;FLOAT;0.4;False;1;FLOAT;0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;21;-2078.61,201.6722;Inherit;False;MF_FrontWeitgth;-1;;12;99a400e47f3aca240af2ff536cf9cc05;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1069.852,515.4442;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.76;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2076.754,39.92618;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.25,1;False;1;FLOAT2;1,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;14;-856.4718,-184.8009;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1811.29,39.20914;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-852.2481,203.7912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-670.2481,207.7912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-622.5103,-188.8289;Inherit;False;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1598.664,10.17813;Inherit;True;Property;_ColorRamp;ColorRamp;6;0;Create;True;0;0;0;False;0;False;-1;None;a06df7a26138ce34e80a7c171d8cd75a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;-582.4467,-10.88292;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-243.9109,80.77116;Inherit;False;17;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-191.6729,-12.70189;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;RainbowFoil;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;True;True;1;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;6;8;2;0
WireConnection;6;11;3;0
WireConnection;8;0;4;0
WireConnection;8;1;5;0
WireConnection;7;0;23;0
WireConnection;7;1;22;0
WireConnection;7;2;6;13
WireConnection;9;0;8;1
WireConnection;9;1;7;0
WireConnection;14;0;6;0
WireConnection;12;0;11;0
WireConnection;12;1;21;0
WireConnection;13;0;21;0
WireConnection;13;1;9;0
WireConnection;15;0;13;0
WireConnection;17;0;14;0
WireConnection;16;1;12;0
WireConnection;18;0;6;0
WireConnection;18;1;16;0
WireConnection;18;2;15;0
WireConnection;20;0;18;0
WireConnection;20;3;19;0
WireConnection;1;0;20;0
ASEEND*/
//CHKSM=703A715F9BD33FAD1B0577422122F939E544A7C1