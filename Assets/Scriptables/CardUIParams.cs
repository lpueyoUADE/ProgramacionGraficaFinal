using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "CardUIParams", menuName = "ScriptableObjects/CardUIParams", order = 3)]
public class CardUIParams : ScriptableObject
{
    public float hoverHeight = 0.5f;
    public float moveSpeed = 5f;
    public float scaleSpeed = 10f;
    public float scaleFactor = 2f;

    public float dissolveAnimationTime = 1f;

    public GameObject characterPrefab;

    public AudioClip selectedSound;
    public AudioClip deselectedSound;
    public AudioClip hoverSound;
    public AudioClip invokeSound;
    public AudioClip vanishSound;
}

