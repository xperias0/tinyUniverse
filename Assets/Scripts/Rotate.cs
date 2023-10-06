using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    // Start is called before the first frame update
    public float rotSpeed = 10f;

    public Transform c;
    // Update is called once per frame
    

    void Update()
    {
        transform.Rotate(transform.forward,rotSpeed);
       
    }
}
