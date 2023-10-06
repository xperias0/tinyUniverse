using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class OrbitDrawer : MonoBehaviour
{
    // Start is called before the first frame update
    private LineRenderer _lineRenderer;
    public GameObject CenterPointGameObject;
    float radius ;    
    private Vector3 centerPosition;
    
    void Start()
    {
        Color c = GetComponent<Planet>().OrbitColor;
      
        
        centerPosition = CenterPointGameObject.transform.position;
        radius = Vector3.Distance(transform.position, centerPosition);
        Debug.Log(radius);
        _lineRenderer = GetComponent<LineRenderer>();
        drawLineRenderer();
    }

    // Update is called once per frame

  
    void drawLineRenderer()
    {
        int pointNum = _lineRenderer.positionCount;
        Debug.Log("pointNum:"+pointNum);
        float angle = 360.0f / (pointNum - 1) ;
        float curAngle = 0; 
        
        for (int i = 0; i < pointNum; i++)
        {
            float xPos = centerPosition.x + (radius * Mathf.Cos(Mathf.Deg2Rad * curAngle));
            float zPos = centerPosition.z + (radius * Mathf.Sin(Mathf.Deg2Rad * curAngle));
            Vector3 CurPos = transform.position + new Vector3(xPos, transform.position.y, zPos);
            _lineRenderer.SetPosition(i,CurPos);
  
            curAngle += angle;
        }

        
    }
}
