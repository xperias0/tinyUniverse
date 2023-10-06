using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class CameraRotation : MonoBehaviour
{
    public float rotSpeed = 5f;

    public float maxVertAngle = 90f;

    public float minVertAngle = -90f;

    public float lerpSpeed = 10f;

    private float targetRotX = 0f;

    private float targetRotY = 0f;

    public Transform target;

    private float distance;

    public float mouseScrollSpeed = 5f;

    public float minDistance;

    private float maxDistance;

    float camDistance;

    Vector2 camStartPos;
    Vector2 camEndPos;
    // Start is called before the first frame update
    void Start()
    {
        distance = Vector3.Distance(target.transform.position, transform.position);
        maxDistance = distance;
        
    }

    // Update is called once per frame
    void Update()
    {
        

        
        if (Input.GetMouseButton(1))
        {
            float rotXInput = -Input.GetAxis("Mouse Y");
            float rotYInput = Input.GetAxis("Mouse X");

            targetRotX += rotXInput * rotSpeed;
            targetRotY += rotYInput * rotSpeed;

            Quaternion targetRotation = Quaternion.Euler(targetRotX, targetRotY, 0);
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, lerpSpeed * Time.deltaTime);
        }

        float scrollVal = -Input.GetAxis("Mouse ScrollWheel");

        if (scrollVal != 0)
        {
            distance += scrollVal * mouseScrollSpeed;
        }

        distance = Mathf.Clamp(distance, minDistance, maxDistance);
        Vector3 targetPos = target.transform.position - transform.forward * distance;

        transform.position = Vector3.Lerp(transform.position,targetPos,mouseScrollSpeed*Time.deltaTime);
    }
}
