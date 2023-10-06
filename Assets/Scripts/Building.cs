using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor.Animations;
using UnityEngine;

public class Building: MonoBehaviour
{
    // Start is called before the first frame update
    private Animator m_Animator;
    private AnimatorController controller;
    private Transform Sun;
    private Transform Earth;
    private Transform lights = null;

    private float angle;
    void Start()
    {
        Earth = GameObject.Find("EarthMain").transform;
        Sun = GameObject.Find("Sun").transform;
        
        m_Animator = transform.GetChild(0).GetComponent<Animator>();
        for (int i=0;i<transform.childCount;i++)
        {
            Transform cur = transform.GetChild(i);
            if (cur.name == "Lights")
            {
                lights = cur;
            }
        }
        lights.gameObject.SetActive(false);
        enableLights();
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            m_Animator.SetTrigger("IsPop");
        }
        
        if (Input.GetKeyDown(KeyCode.D))
        {
            m_Animator.SetTrigger("IsBack");
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("VAl:" + angle);
        if (other.CompareTag("Plane"))
        {
            Debug.Log("Plane in");
            m_Animator.SetTrigger("IsPop");

            if (angle < 0)
            {
                if (lights != null)
                {
                    StartCoroutine(turnLightsOn(1.7f));
                }
            }
        }

        
    }

    private void OnTriggerExit(Collider other)
    {
       // m_Animator.SetTrigger("IsBack");
    }

    void enableLights()
    {
        Vector3 upDir = transform.up;
        Vector3 earthToSunDir = (Sun.transform.position - Earth.transform.position).normalized;

        angle = Vector3.Dot(upDir, earthToSunDir);
        // if (angle >= 0f)
        // {
        //     if (lights != null)
        //     {
        //         lights.gameObject.SetActive(false);
        //     }
        // }
        Debug.Log(transform.name+":  "+angle);
    }

    IEnumerator turnLightsOn(float second)
    {
        yield return new WaitForSecondsRealtime(second);
        lights.gameObject.SetActive(true);
    }
}
