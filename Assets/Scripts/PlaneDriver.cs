using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;


public class PlaneDriver : MonoBehaviour
{
    // Start is called before the first frame update
    private List<Vector3> locations;
    
    public Transform center;
    public float speed = 10f;
    // Update is called once per frame
    private int index = 0;
    private bool isFlying = false;
    private float t = 0;

    private MainCaculator mc;

    
    private Vector3 upDirection;
    
    private int locationCount;
    private int distanceCount;
    private List<float> distances;
    private float curLength = 0;
    private GameObject tBAll;
    private void Start()
    {
        mc = GameObject.Find("GameManager").GetComponent<MainCaculator>();
        
        distances = new List<float>();
        tBAll = GameObject.Find("TestBall");
    }

    void Update()
    {
        if (isFlying)
        {
            Onflying();
        }
    }

    public void Onflying()
    {
        upDirection = (transform.position - center.position).normalized;
        curLength += speed * Time.deltaTime;
        
        float t = 0;
        if (index < locationCount - 1)
        {
            if (curLength > distances[index] && index + 1 != locationCount)
            {
                index++;
            }
            if (index == 0)
            {
                t = curLength / distances[index];
            }
            else if (index < distanceCount)
            {
                t = (curLength - distances[index - 1]) / (distances[index] - distances[index - 1]);
            }

            try
            {
                transform.position = Vector3.Lerp(locations[index], locations[index + 1], t);
                transform.LookAt(locations[index + 1],upDirection);
            }
            catch (ArgumentOutOfRangeException e)
            {
                Debug.Log("Arrived");
            }
            
        }
        else
        {
            isFlying = false;
          
        }
            
    }

    public void OnStartFly()
    {
        locations = mc.spherePostions;
        distances.Clear();
        for (int i=0;i<locations.Count - 1;i++)
        { 
            float curDis = Vector3.Distance(locations[i], locations[i + 1]);
            //Instantiate(GameObject.Find("TestBall"), locations[i], quaternion.identity);

            if (i>=1)
            {
                distances.Add(curDis + distances[i-1]);
            }
            else
            {
                distances.Add(curDis);
            }
        }

        transform.position = locations[0];
       
        isFlying = true;
        index = 0;
        curLength = 0;
        locationCount = locations.Count;
        distanceCount = locationCount - 1;
    }
}
