using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class HeadLookAtMouse : MonoBehaviour
{
    
    public float lookAtWeight = 1.0f;         // Qué tan fuerte es el efecto
    public float bodyWeight = 0.0f;           // Qué tanto rota el torso
    public float headWeight = 1.0f;           // Qué tanto rota la cabeza
    public float eyesWeight = 1.0f;           // Qué tanto los ojos (si hay soporte)
    public float clampWeight = 0.5f;          // Qué tan limitado es el movimiento
    public float stopLookingAfter = 1f;

    private Animator animator;

    private bool lookingAt;

    private float lastMouseMovementCounter;
    private Vector3 lastMousePosition;
    private Camera cam;

    void Start()
    {
        cam = Camera.main;
        animator = GetComponent<Animator>();
        lastMouseMovementCounter = 0;
        lastMousePosition = Input.mousePosition;
    }

    private void Update()
    {
        float deltaTime = Time.deltaTime;
        lastMouseMovementCounter += deltaTime;

        lookingAt = lastMouseMovementCounter < stopLookingAfter;

        if (lastMousePosition != Input.mousePosition)
        {
            lastMouseMovementCounter = 0;
        }

        float deltaWeight = deltaTime *  4 * (lookingAt ? 1 : -1);

        lookAtWeight = Mathf.Clamp(lookAtWeight + deltaWeight, 0, 1);

        lastMousePosition = Input.mousePosition;
    }

    void OnAnimatorIK(int layerIndex)
    {
        float playerAndCamPosDiffZ = transform.position.z - cam.transform.position.z;
        Vector3 mousePos = cam.ScreenToWorldPoint(Input.mousePosition + Vector3.forward * playerAndCamPosDiffZ);

        animator.SetLookAtWeight(lookAtWeight, bodyWeight, headWeight, eyesWeight, clampWeight);

        animator.SetLookAtPosition(mousePos + new Vector3(0, 0, -5));
    }
}
