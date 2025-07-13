using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FPSLimiter : MonoBehaviour
{
    [SerializeField]
    private int fps = 60;
    private void Awake()
    {
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = fps;
    }
}
