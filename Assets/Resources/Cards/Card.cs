using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[CreateAssetMenu(fileName = "NewCard", menuName = "ScriptableObjects/Cards", order = 1)]
public class Card : ScriptableObject
{
    public string cardName = "none";
    [TextArea]
    public string cardDescription = "none";
    public Color tintColor = Color.white;
    public Sprite displaySprite = null;
    public Material effectMaterial = null;
}
