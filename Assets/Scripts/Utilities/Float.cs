using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Float : MonoBehaviour
{
    [Header("Position")]
    [SerializeField] Vector3 direction;
    [SerializeField] float amplitude;
    [SerializeField] float frequency;

    [Header("Rotation")]
    [SerializeField] Vector3 rotationAxis;
    [SerializeField] float rotationSpeed;
    
    Vector3 initialPosition;
    void Start()
    {
        initialPosition = transform.position;
    }

    void Update()
    {
        transform.position = initialPosition + (direction * (Mathf.Sin(Time.time * frequency) + 1) * amplitude);
        transform.Rotate(rotationAxis, rotationSpeed * Time.deltaTime);
    }
}
