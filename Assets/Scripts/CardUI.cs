using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.TextCore.Text;

public class CardUI : MonoBehaviour
{
    private Vector3 targetPosition;
    private Vector3 originalScale;
    private Vector3 targetScale;

    private Vector3 restingPosition;

    public CardUIParams cardParams;

    public Transform selectedSpot;

    private Character characterInstance;

    private static CardUI currentlySelected;

    private bool isHovered = false;
    private bool isSelected = false;

    private float dissolveAmount;
    private Coroutine currentDissolveAnim;

    public bool IsSelected { get => isSelected; }
    public Vector3 RestingPosition { get => restingPosition; }

    public static Action<CardUI> OnCardSelected;
    public static Action<CardUI> OnCardDeselected;

    void Start()
    {
        restingPosition = transform.position;
        targetPosition = restingPosition;

        originalScale = transform.localScale;
        targetScale = originalScale;

        characterInstance = null;
        dissolveAmount = 1f;
    }
    void OnMouseOver()
    {
        if (!enabled) return;

        if (!isSelected)
        {
            isHovered = true;
            targetPosition = restingPosition + Vector3.up * cardParams.hoverHeight;
        }
    }

    void OnMouseExit()
    {
        if (!enabled) return;

        if (!isSelected)
        {
            isHovered = false;
            targetPosition = restingPosition;
        }
    }

    void OnMouseDown()
    {
        if (!enabled) return;

        if (currentlySelected != null && currentlySelected != this)
        {
            currentlySelected.Deselect();
        }

        if (!isSelected)
        {
            Select();
        }
        else
        {
            Deselect();
        }
    }

    public void UpdateRestingPostion(Vector3 newPosition)
    {
        restingPosition = newPosition;
        targetPosition = isSelected ? selectedSpot.position : newPosition;
    }

    void Update()
    {
        if (transform.position == targetPosition)
        {
            return;
        }

        transform.position = Vector3.Lerp(transform.position, targetPosition, Time.deltaTime * cardParams.moveSpeed);
        transform.localScale = Vector3.Lerp(transform.localScale, targetScale, Time.deltaTime * cardParams.scaleSpeed);
    }

    public void Select()
    {
        isSelected = true;
        currentlySelected = this;

        targetPosition = selectedSpot.position;
        targetScale = originalScale * cardParams.scaleFactor;

        OnCardSelected?.Invoke(this);

        GetComponent<Rotating>().enabled = true;

        AudioSource.PlayClipAtPoint(cardParams.selectedSound, Camera.main.transform.position);
    }
    public void Deselect()
    {
        isSelected = false;
        targetPosition = restingPosition;
        targetScale = originalScale;

        OnCardDeselected?.Invoke(this);
        currentlySelected = null;

        GetComponent<Rotating>().enabled = false;

        AudioSource.PlayClipAtPoint(cardParams.deselectedSound, Camera.main.transform.position);
    }

    public void InvokeCharacter(Vector3 position, Transform parent)
    {
        if (characterInstance == null)
        {
            var newInstance = Instantiate(cardParams.characterPrefab, position, cardParams.characterPrefab.transform.rotation);
            characterInstance = newInstance.GetComponent<Character>();
            characterInstance.transform.parent = parent;

        }

        if (currentDissolveAnim != null)
            StopCoroutine(currentDissolveAnim);

        currentDissolveAnim = StartCoroutine(AnimateDissolve(0));
    }

    public void VanishCharacter()
    {
        if (characterInstance == null)
        {
            return;
        }

        if (currentDissolveAnim != null)
            StopCoroutine(currentDissolveAnim);

        currentDissolveAnim = StartCoroutine(AnimateDissolve(1));
    }

    IEnumerator AnimateDissolve(float target)
    {
        float start = dissolveAmount;
        float elapsed = 0f;
        float dissolveTime = cardParams.dissolveAnimationTime;

        if (target == 0)
        {
            characterInstance.gameObject.SetActive(true);
        }

        while (elapsed < dissolveTime)
        {
            foreach (var material in characterInstance.ExposedMaterials)
            {
                if (material.HasFloat("_DissolveAmount"))
                    material.SetFloat("_DissolveAmount", dissolveAmount);
            }
            dissolveAmount = Mathf.Lerp(start, target, elapsed / dissolveTime);
            elapsed += Time.deltaTime;
            yield return null;
        }

        if(target == 1)
        {
            characterInstance.gameObject.SetActive(false);
        }

        dissolveAmount = target;
    }
}
