using UnityEngine;

public class Rotating : MonoBehaviour
{
    public Rotation rotation;

    private float time;
    private Quaternion initialRotation;

    void Start()
    {
        initialRotation = transform.localRotation;
        time = Random.Range(0f, Mathf.PI * 2f);  // Para desincronizar el efecto
    }

    void Update()
    {
        time += Time.deltaTime * rotation.speed;

        float rotationX = Mathf.Sin(time) * rotation.amount;
        float rotationY = Mathf.Cos(time) * rotation.amount;

        Quaternion offsetRotation = Quaternion.Euler(rotationX, rotationY, 0);
        transform.localRotation = initialRotation * offsetRotation;
    }

    private void OnDisable()
    {
        transform.localRotation = initialRotation;
    }
}