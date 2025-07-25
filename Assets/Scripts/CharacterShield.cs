using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterShield : MonoBehaviour
{
    Material material;

    public float frequencySpeed = 2f;
    public float opacitySpeed = 2f;
    public float maxOpacity = 0.7f;

    public AudioClip shieldOnSound; 
    public AudioClip shieldOffSound;

    float targetOpacity;
    float currentOpacity;

    bool isActive = false;

    private void Start()
    {
        var renderer = GetComponent<Renderer>();
        material = renderer.material;

        isActive = false;

        targetOpacity = 0;
        currentOpacity = 0;
        material.SetFloat("_Opacity", currentOpacity);
    }

    private void Update()
    {
        currentOpacity = Mathf.Lerp(currentOpacity, targetOpacity, Time.deltaTime * opacitySpeed);
        material.SetFloat("_Opacity", currentOpacity);

        material.SetFloat("_Frequency", (Mathf.Sin(Time.time * frequencySpeed) * 0.01f) + 0.01f);
    }

    public void Toggle()
    {
        isActive = !isActive;
        
        if (isActive)
        {
            Enable();
        }
        else
        {
            Disable();
        }
    }

    public void Enable(bool emitSound=true)
    {
        isActive = true;
        targetOpacity = maxOpacity;

        if (emitSound)
            AudioSource.PlayClipAtPoint(shieldOnSound, Camera.main.transform.position);
    }

    public void Disable(bool emitSound=true)
    {
        isActive = false;
        targetOpacity = 0;

        if(emitSound)
            AudioSource.PlayClipAtPoint(shieldOffSound, Camera.main.transform.position);
    }
}
