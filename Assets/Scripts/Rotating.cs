using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotating : MonoBehaviour
{
    public float rotationSpeed = 10f;  // Velocidad de la rotaci�n
    public float rotationAmount = 5f;  // Cantidad m�xima de rotaci�n

    private RectTransform rectTransform;
    private float time;

    void Start()
    {
        // rectTransform = GetComponent<RectTransform>();
        time = Random.Range(0f, Mathf.PI * 2f);  // Para desincronizar el efecto
    }

    void Update()
    {
        time += Time.deltaTime * rotationSpeed;
        float rotationx = Mathf.Sin(time) * rotationAmount;  // Oscilaci�n senoidal
        float rotationy = Mathf.Cos(time) * rotationAmount;  // Oscilaci�n senoidal
        transform.localRotation = Quaternion.Euler(rotationx, rotationy, 0);
    }
}
