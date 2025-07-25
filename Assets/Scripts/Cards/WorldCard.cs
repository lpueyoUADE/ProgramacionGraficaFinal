using UnityEngine;

[ExecuteAlways] // Habilita ejecución en editor
public class WorldCard : MonoBehaviour
{
    [SerializeField] private Card card;
    [SerializeField] private SpriteRenderer cardBorder;
    [SerializeField] private SpriteRenderer cardIcon;
    [SerializeField] private TextMesh cardName;
    [SerializeField] private TextMesh cardDescription;
    [SerializeField] private Material stencilWindowMaskMaterial;
    [SerializeField] private Transform stencilWorldOrigin;

    private GameObject stencilWorld;
    [ContextMenu("Refresh Card")]
    public void ApplyCardData()
    {
        if (card == null) return;

        DestroyImmediate(cardBorder.sharedMaterial);
        cardBorder.sharedMaterial = Instantiate(card.effectMaterial);
        if (cardBorder.sharedMaterial.HasProperty("_IsFrame"))
            cardBorder.sharedMaterial.SetInt("_IsFrame", 1);
        if (cardBorder.sharedMaterial.HasProperty("_Color"))
            cardBorder.sharedMaterial.SetColor("_Color", card.tintColor);

        if (card.StencilPrefab != null)
        {
            for (int i = (stencilWorldOrigin.childCount) - 1; i >= 0; i--)
            {
                DestroyImmediate(stencilWorldOrigin.GetChild(i).gameObject);
            }

            cardIcon.sharedMaterial = stencilWindowMaskMaterial;
            stencilWorld = Instantiate(card.StencilPrefab, stencilWorldOrigin);
        }
        else
        {
            DestroyImmediate(cardIcon.sharedMaterial);
            cardIcon.sharedMaterial = Instantiate(card.effectMaterial); ;
        }

        cardIcon.sprite = card.displaySprite;
        cardName.text = card.cardName;
        cardDescription.text = card.cardDescription;
    }

    private void Start()
    {
        ApplyCardData();
    }
}