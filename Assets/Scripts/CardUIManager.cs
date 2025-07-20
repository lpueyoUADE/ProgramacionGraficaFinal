using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardUIManager : MonoBehaviour
{
    public List<CardUI> cards;
    public List<Transform> cardPositions;
    public GameObject ActionsPanel;

    private void Start()
    {
        ActionsPanel.SetActive(false);
    }

    void OnEnable()
    {
        CardUI.OnCardSelected += HandleCardSelected;
        CardUI.OnCardDeselected += HandleCardDeselected;
    }

    void OnDisable()
    {
        CardUI.OnCardSelected -= HandleCardSelected;
        CardUI.OnCardDeselected -= HandleCardDeselected;
    }

    void HandleCardSelected(CardUI card)
    {
        ActionsPanel.SetActive(true);

        bool found = false;
        Vector3 aux;
        for (int i = 0; i < cards.Count; i++)
        {
            if(found)
            {
                (cards[i], cards[i - 1]) = (cards[i - 1], cards[i]);

                aux = cards[i].restingPosition;
                cards[i].UpdateRestingPostion(cards[i - 1].restingPosition);
                cards[i - 1].UpdateRestingPostion(aux);
            }

            if(card == cards[i])
            {
                found = true;
            }
        }
    }

    void HandleCardDeselected(CardUI card)
    {
        ActionsPanel.SetActive(false);
    }
}
