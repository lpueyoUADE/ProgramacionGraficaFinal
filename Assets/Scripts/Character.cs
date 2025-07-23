using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Character : MonoBehaviour
{
    [SerializeField]
    public List<SkinnedMeshRenderer> renderers;

    public List<Material> exposedMaterials;

    public List<Material> ExposedMaterials { get => exposedMaterials; }

    private void Awake()
    {
        var skinnedRenderers = GetComponentsInChildren<SkinnedMeshRenderer>(true);
        foreach (var renderer in skinnedRenderers)
        {
            foreach (var mat in renderer.sharedMaterials)
            {
                if(mat.HasFloat("_DissolveAmount"))
                    exposedMaterials.Add(mat);
            }
        }
    }
}
