using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PI_GameManager : MonoBehaviour
{
    public static PI_GameManager instance;

    [SerializeField] private KeyCode nextSceneKey;
    [SerializeField] private KeyCode prevSceneKey;
    [SerializeField] private KeyCode restartKey;
    
    void Awake()
    {
        if (instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(nextSceneKey))
        {
            GoToNextScene();
        }

        if (Input.GetKeyDown(prevSceneKey))
        {
            GoToPrevScene();
        }
        
        if (Input.GetKeyDown(restartKey))
        {
            RestartScene();
        }
    }

    private void GoToNextScene()
    {
        int nextIndex = SceneManager.GetActiveScene().buildIndex + 1;
        if (nextIndex >= SceneManager.sceneCountInBuildSettings)
        {
            nextIndex = 0;
        }

        SceneManager.LoadScene(nextIndex);
    }

    private void GoToPrevScene()
    {
        int prevIndex = SceneManager.GetActiveScene().buildIndex - 1;
        if (prevIndex < 0)
        {
            prevIndex = SceneManager.sceneCountInBuildSettings;
        }

        SceneManager.LoadScene(prevIndex);
    }

    private void RestartScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
}
