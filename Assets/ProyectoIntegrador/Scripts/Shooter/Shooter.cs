using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class Shooter : MonoBehaviour
{
    [SerializeField] private Animator  animator;
    [SerializeField] private float cycleDuration;
    [SerializeField] private float delayForShotSync;

    public UnityEvent onShoot;
    

    private float timer = 0f;
    
    void Start()
    {
        animator = GetComponent<Animator>();
    }
    
    void Update()
    {
        timer += Time.deltaTime;
        if (timer >= cycleDuration)
        {
            animator.SetTrigger("triggerAnim");
            timer = 0;
            StartCoroutine(WaitForShot());
        }
    }

    IEnumerator WaitForShot()
    {
        yield return new WaitForSeconds(delayForShotSync);

        onShoot?.Invoke();
    }

}
