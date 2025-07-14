using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Fighter : MonoBehaviour
{
   [SerializeField] private List<float> delays  = new List<float>(); 
   [SerializeField] private List<UnityEvent> events  = new List<UnityEvent>();
   
   private int currentIndex;
   private Animator animator;

   private void Start()
   {
      animator = GetComponent<Animator>();
   }

   public void TriggerAnimation()
   {
      currentIndex++;

      StartCoroutine(DelayAnimation());
   }

   private IEnumerator DelayAnimation()
   {
      yield return new WaitForSeconds(delays[currentIndex]);
      animator.SetInteger("index", currentIndex);
      animator.SetTrigger("triggerAnim");
      events[currentIndex].Invoke();
   }

}
