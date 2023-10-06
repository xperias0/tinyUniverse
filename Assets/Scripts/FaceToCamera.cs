using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FaceToCamera : MonoBehaviour
{
    // Start is called before the first frame update
    private Camera mainCam;
    private Vector3 startPos;
    float PositionY;
    void Start()
    {
        mainCam     = Camera.main;
        PositionY = mainCam.transform.position.y;
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 lookAtPos = new Vector3(mainCam.transform.position.x, PositionY, mainCam.transform.position.z);

        transform.LookAt(lookAtPos);
    }
}
