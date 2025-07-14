using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class Shield : MonoBehaviour
{
    [SerializeField] private Animator  animator;
    [SerializeField] private float cycleDuration;
    [SerializeField] private float delayForShieldSync;
    [SerializeField] private float shieldActive;

    public UnityEvent onShieldOn;
    public UnityEvent onShieldOff;
    

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
            animator.SetBool("activeShield", true);
            timer = 0;
            StartCoroutine(WaitForShot());
        }
    }

    IEnumerator WaitForShot()
    {
        yield return new WaitForSeconds(delayForShieldSync);
        onShieldOn?.Invoke();
        
        yield return new WaitForSeconds(shieldActive);
        animator.SetBool("activeShield", false);
        onShieldOff?.Invoke();
    }

}
