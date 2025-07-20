using UnityEngine;

public class Rotate : MonoBehaviour
{
    [Tooltip("Horizontal Rotation Speed")]
    [Range(-1, 1)]
    public float rotationSpeedH = 0.7f;

    [Tooltip("Vertical Rotation Speed")]
    [Range(-1, 1)]
    public float rotationSpeedV = 0.4f;

    [Tooltip("Maximum Horizontal Angle")]
    [Range(0, 60)]
    public float angleH = 20;

    [Tooltip("Maximum Vertical Angle")]
    [Range(0, 60)]
    public float angleV = 8;

    private float rotationCounter = 0;
    private Transform windowTransform;
    private Transform worldTransform;

    private Quaternion initialRotation;

    private void Awake()
    {
        windowTransform = transform.GetChild(1);
        worldTransform = transform.GetChild(2);

        // Guardar la rotación inicial
        initialRotation = transform.rotation;
    }

    void Update()
    {
        rotationCounter += Time.deltaTime;

        // Calcular rotación offset como Quaternion
        float offsetX = Mathf.Sin(rotationCounter * rotationSpeedV) * angleV;
        float offsetY = Mathf.Sin(rotationCounter * rotationSpeedH) * angleH;

        Quaternion offsetRotation = Quaternion.Euler(offsetX, offsetY, 0);

        // Aplicar rotación relativa
        transform.rotation = initialRotation * offsetRotation;
    }
}