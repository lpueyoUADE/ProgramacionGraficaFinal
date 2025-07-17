using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardUI : MonoBehaviour
{
    private Vector3 targetPosition;
    private Vector3 originalScale;
    private Vector3 targetScale;

    public Vector3 restingPosition;

    public float hoverHeight = 0.5f;
    public float moveSpeed = 5f;
    public float scaleSpeed = 10f;
    public float scaleFactor = 2f;

    public Transform selectedSpot;
    private static CardUI currentlySelected;

    private bool isHovered = false;
    private bool isSelected = false;

    public bool IsSelected { get => isSelected; set => isSelected = value; }

    public static Action<CardUI> OnCardSelected;
    public static Action<CardUI> OnCardDeselected;

    void Start()
    {
        restingPosition = transform.position;
        targetPosition = restingPosition;

        originalScale = transform.localScale;
        targetScale = originalScale;
    }

    void OnMouseOver()
    {
        if (!isSelected)
        {
            isHovered = true;
            targetPosition = restingPosition + Vector3.up * hoverHeight;
        }
    }

    void OnMouseExit()
    {
        if (!isSelected)
        {
            isHovered = false;
            targetPosition = restingPosition;
        }
    }

    void OnMouseDown()
    {
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
        transform.position = Vector3.Lerp(transform.position, targetPosition, Time.deltaTime * moveSpeed);
        transform.localScale = Vector3.Lerp(transform.localScale, targetScale, Time.deltaTime * scaleSpeed);
    }

    public void Select()
    {
        isSelected = true;
        currentlySelected = this;

        targetPosition = selectedSpot.position;
        targetScale = originalScale * scaleFactor;

        OnCardSelected?.Invoke(this);

        GetComponent<Rotating>().enabled = true;
    }
    public void Deselect()
    {
        isSelected = false;
        targetPosition = restingPosition;
        targetScale = originalScale;

        OnCardDeselected?.Invoke(this);
        currentlySelected = null;

        GetComponent<Rotating>().enabled = false;
    }
}
