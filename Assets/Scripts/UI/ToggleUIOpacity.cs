using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleUIOpacity : MonoBehaviour
{
    public CanvasGroup canvasGroup;
    public float fadeDuration = 0.3f;

    private bool isVisible = true;
    private Coroutine currentFade;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Tab))
        {
            isVisible = !isVisible;

            if (currentFade != null)
                StopCoroutine(currentFade);

            currentFade = StartCoroutine(FadeCanvasGroup(canvasGroup, canvasGroup.alpha, isVisible ? 1f : 0f));
        }
    }

    System.Collections.IEnumerator FadeCanvasGroup(CanvasGroup cg, float start, float end)
    {
        float elapsed = 0f;

        while (elapsed < fadeDuration)
        {
            cg.alpha = Mathf.Lerp(start, end, elapsed / fadeDuration);
            elapsed += Time.deltaTime;
            yield return null;
        }

        cg.alpha = end;
        cg.interactable = end > 0;
        cg.blocksRaycasts = end > 0;
    }
}