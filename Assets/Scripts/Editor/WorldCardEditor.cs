
using static UnityEngine.GraphicsBuffer;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(WorldCard))]
public class WorldCardEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        WorldCard myTarget = (WorldCard)target;

        if (GUILayout.Button("RefreshCard"))
        {
            myTarget.ApplyCardData();
        }
    }
}