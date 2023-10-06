using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClockControll : MonoBehaviour
{
    // Start is called before the first frame update
    private bool isOpen = false;
    private bool isClick = false;
    private bool isOnArraw = false;
    private Transform Arrow;
    private Animator m_animator;
    private Vector2 mouseClickPosition;
    public float rotSpeed;
    private float rotAngle;
    private float targetX;
    private float targetY;

    public Transform rotCenter;
    void Start()
    {
        m_animator = GetComponent<Animator>();
        Arrow = transform.GetChild(2);
        
    }

    // Update is called once per frame
    void Update()
    {
        clockDetecter();
    }

    void clockDetecter()
    {
        Ray ray = new Ray();
        ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, 1000f, 1 << 7))
        {
            m_animator.SetBool("IsOpen",true);
            isOpen = true;
        }
        else 
        {
            m_animator.SetBool("IsOpen",false);
            isOpen = false;
        }

        if (Physics.Raycast(ray, 1000f, 1 << 8) && isClick)
        {
            
            if (Input.GetMouseButtonDown(0))
            {
                isOnArraw = true;
                mouseClickPosition = Input.mousePosition;
                print("Click: "+mouseClickPosition);
            }
        }

        if (isOpen && Input.GetMouseButtonDown(0))
        {
            m_animator.SetBool("IsClick",true);
            isClick = true;
        }
        
        if (!isOpen && Input.GetMouseButtonDown(0))
        {
            m_animator.SetBool("IsClick",false);
            isClick = false;
        }

       // rotateArrow();
    }


    void rotateArrow()
    {
        if (isOnArraw)
        {
            if (Input.GetMouseButtonUp(0))
            {
                isOnArraw = false;
            }
            
            Vector2 deltaPos = new Vector2(Input.mousePosition.x,Input.mousePosition.y) - mouseClickPosition;
            rotAngle = Mathf.Atan2(deltaPos.y,deltaPos.x) * Mathf.Rad2Deg;
            
            Quaternion angle = Quaternion.AngleAxis(rotAngle,rotCenter.forward) ;
            
            Arrow.rotation = angle;
           // Arrow.rotation = Quaternion.Lerp(Arrow.rotation, angle, rotSpeed * Time.deltaTime);
        }

        

    }
}
