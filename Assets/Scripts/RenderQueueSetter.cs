using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderQueueSetter : MonoBehaviour
{
    // Start is called before the first frame update
    private Renderer rd;
    public int materialIndex;
    public int queue;
    public float ztestVal;
    void Start()
    {
        rd = GetComponent<Renderer>();
        rd.materials[materialIndex].renderQueue = queue;
       // rd.materials[materialIndex].SetFloat("_Ztest",(float)UnityEngine.Rendering.CompareFunction.Always);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
