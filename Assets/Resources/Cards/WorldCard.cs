using UnityEngine;

[ExecuteAlways] // Habilita ejecución en editor
public class WorldCard : MonoBehaviour
{
    [SerializeField] private Card card;
    [SerializeField] private SpriteRenderer cardBorder;
    [SerializeField] private SpriteRenderer cardIcon;
    [SerializeField] private TextMesh cardName;
    [SerializeField] private TextMesh cardDescription;

    private Material tempBorderMaterial;
    private Material tempDisplayMaterial;

    [ContextMenu("Refresh Card")]
    public void ApplyCardData()
    {
        if (card == null) return;

        // Crear una instancia del material si no existe o si cambió el original
        if (tempBorderMaterial == null || tempBorderMaterial.name != card.effectMaterial.name + " (Instance)")
        {
            tempBorderMaterial = Instantiate(card.effectMaterial);
            tempBorderMaterial.name = card.effectMaterial.name + " (Instance)";
        }

        // Crear una instancia del material si no existe o si cambió el original
        if (tempDisplayMaterial == null || tempDisplayMaterial.name != card.effectMaterial.name + " (Instance)")
        {
            tempDisplayMaterial = Instantiate(card.effectMaterial);
            tempDisplayMaterial.name = card.effectMaterial.name + " (Instance)";
        }

#if UNITY_EDITOR
        cardBorder.sharedMaterial = tempBorderMaterial;
        if (cardBorder.sharedMaterial.HasProperty("_Tint"))
            cardBorder.sharedMaterial.SetColor("_Tint", card.tintColor);
        if (cardBorder.sharedMaterial.HasProperty("_IsBorder"))
            cardBorder.sharedMaterial.SetInt("_IsBorder", 0);


        cardIcon.sharedMaterial = tempDisplayMaterial;
        if (cardBorder.sharedMaterial.HasProperty("_IsBorder"))
            cardBorder.sharedMaterial.SetInt("_IsBorder", 1);
#else
        cardBorder.material = tempMaterial;
        if (cardBorder.material.HasProperty("_Tint"))
            cardBorder.material.SetColor("_Tint", card.tintColor);
#endif

        // Asignar sprite e información textual
        cardIcon.sprite = card.displaySprite;
        cardName.text = card.cardName;
        cardDescription.text = card.cardDescription;
    }

    private void Awake()
    {
        if (Application.isPlaying)
            ApplyCardData();
    }

    private void OnValidate()
    {
        ApplyCardData();
    }
}