using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "CardRotation", menuName = "ScriptableObjects/Rotation", order = 2)]
public class Rotation : ScriptableObject
{
    public float speed = 1f;
    public float amount = 2f;
}
