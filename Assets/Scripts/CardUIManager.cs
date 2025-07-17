using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardUIManager : MonoBehaviour
{
    public List<CardUI> cards;
    public List<Transform> cardPositions;

    void OnEnable()
    {
        CardUI.OnCardSelected += HandleCardSelected;
    }

    void OnDisable()
    {
        CardUI.OnCardSelected -= HandleCardSelected;
    }

    void HandleCardSelected(CardUI card)
    {
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
}
