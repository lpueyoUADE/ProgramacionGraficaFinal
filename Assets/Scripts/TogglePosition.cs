using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TogglePosition : MonoBehaviour
{
    public Vector3 hiddenOffset = new Vector3(0, -10f, 0); // Movimiento hacia abajo
    public float moveDuration = 0.5f;

    private Transform target;
    private bool isVisible = true;
    private Vector3 originalPosition;
    private Coroutine currentMove;

    void Start()
    {
        target = transform;

        originalPosition = target.position;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Tab))
        {
            isVisible = !isVisible;

            Vector3 destination = isVisible ? originalPosition : originalPosition + hiddenOffset;

            if (currentMove != null)
                StopCoroutine(currentMove);

            currentMove = StartCoroutine(MoveTo(destination));
        }
    }

    System.Collections.IEnumerator MoveTo(Vector3 destination)
    {
        Vector3 start = target.position;
        float elapsed = 0f;

        while (elapsed < moveDuration)
        {
            target.position = Vector3.Lerp(start, destination, elapsed / moveDuration);
            elapsed += Time.deltaTime;
            yield return null;
        }

        target.position = destination;
    }
}