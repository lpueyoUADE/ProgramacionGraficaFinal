using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Character : MonoBehaviour
{
    [SerializeField]
    public List<SkinnedMeshRenderer> renderers;

    public List<Material> exposedMaterials;

    private CharacterShield characterShield;

    private Animator animator;
    public List<Material> ExposedMaterials { get => exposedMaterials; }
    public CharacterShield CharacterShield { get => characterShield; set => characterShield = value; }


    public enum Actions
    {
        IDLE,
        INVOKE,
        VANISH
    }

    public Dictionary<Actions, string> ActionsTriggerValue =
    new() {
        {Actions.IDLE, "DoIdle"},
        {Actions.INVOKE, "DoInvoke"},
        {Actions.VANISH, "DoVanish"},
    };

    private void Awake()
    {
        animator = GetComponent<Animator>();

        characterShield = GetComponentInChildren<CharacterShield>();

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

    public void DoAction(Actions action)
    {
        animator.SetTrigger(ActionsTriggerValue[action]);
    }
}
