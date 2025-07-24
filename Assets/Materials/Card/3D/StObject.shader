// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AS_StencilModel"
{
	Properties
	{
		_BC("BC", 2D) = "white" {}
		_NM("NM", 2D) = "white" {}
		_ColorTint("ColorTint", Color) = (1,1,1,1)
		[Toggle(_PLANARCOLOR_ON)] _PlanarColor("PlanarColor", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZWrite Off
		ZTest Always
		Stencil
		{
			Ref 1
			Comp Equal
			Pass Replace
			Fail Keep
			ZFail Keep
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _PLANARCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NM;
		uniform float4 _NM_ST;
		uniform float4 _ColorTint;
		uniform sampler2D _BC;
		uniform float4 _BC_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NM = i.uv_texcoord * _NM_ST.xy + _NM_ST.zw;
			o.Normal = tex2D( _NM, uv_NM ).rgb;
			float2 uv_BC = i.uv_texcoord * _BC_ST.xy + _BC_ST.zw;
			#ifdef _PLANARCOLOR_ON
				float4 staticSwitch33 = _ColorTint;
			#else
				float4 staticSwitch33 = ( _ColorTint * tex2D( _BC, uv_BC ) );
			#endif
			o.Albedo = staticSwitch33.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
8;251;1904;760;1437.817;274.0912;1;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-1048.721,-94.18512;Inherit;True;Property;_BC;BC;0;0;Create;True;0;0;0;False;0;False;-1;None;240ce1d8a314c864fb44efc3c56a49a3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-908.1608,-275.4357;Inherit;False;Property;_ColorTint;ColorTint;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-590.1608,-228.4357;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;30;-830.6072,257.0671;Inherit;True;Property;_NM;NM;1;0;Create;True;0;0;0;False;0;False;-1;None;67dc751397e1b75439a91891c5142b92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;33;-333.1608,-12.4357;Inherit;False;Property;_PlanarColor;PlanarColor;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;26.085,8.299777;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AS_StencilModel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;5;False;-1;3;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;31;0
WireConnection;32;1;1;0
WireConnection;33;1;32;0
WireConnection;33;0;31;0
WireConnection;0;0;33;0
WireConnection;0;1;30;0
ASEEND*/
//CHKSM=0A75A9DBB27C8044AC4C03CCF36BC479D09E1D29