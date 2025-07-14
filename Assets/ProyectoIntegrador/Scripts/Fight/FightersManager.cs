using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Serialization;

public class FightersManager : MonoBehaviour
{
    [SerializeField] private List<Fighter> fighters = new List<Fighter>();
    [SerializeField] private List<float> intervals = new List<float>();

    private float timer = 0f;
    private bool isRunning = false;
    private int currentIndex;
    
    
    private void Start()
    {
       StartCycle();
    }

    private void StartCycle()
    {
        isRunning = true;
    }

    void Update()
    {
        if (!isRunning) return;
        
        timer += Time.deltaTime;
        if (timer >= intervals[currentIndex])
        {
            TriggerEvent();
        }
    }

    private void TriggerEvent()
    {
        foreach (var fighter in fighters)
        {
            fighter.TriggerAnimation();
        }

        timer = 0f;
        currentIndex++;

        if (currentIndex >= intervals.Count)
        {
            isRunning = false;
        }

    }
}