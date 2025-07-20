using UnityEngine;

public class Rotating : MonoBehaviour
{
    public float rotationSpeed = 10f;   // Velocidad de la rotación
    public float rotationAmount = 5f;   // Cantidad máxima de rotación

    private float time;
    private Quaternion initialRotation;

    void Start()
    {
        initialRotation = transform.localRotation;
        time = Random.Range(0f, Mathf.PI * 2f);  // Para desincronizar el efecto
    }

    void Update()
    {
        time += Time.deltaTime * rotationSpeed;

        float rotationX = Mathf.Sin(time) * rotationAmount;
        float rotationY = Mathf.Cos(time) * rotationAmount;

        Quaternion offsetRotation = Quaternion.Euler(rotationX, rotationY, 0);
        transform.localRotation = initialRotation * offsetRotation;
    }

    private void OnDisable()
    {
        transform.localRotation = initialRotation;
    }
}