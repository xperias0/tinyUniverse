using System;
using System.Collections;
using System.Collections.Generic;
using Michsky.MUIP;
using UnityEngine;

public class GasCaculator : MonoBehaviour
{
    // Start is called before the first frame update
    [Range(0, 1)] public float gasValue;
    public GameObject gate;
    public GameObject GasSlider;
    private Material gateMaterial;
    private ProgressBar bar;
    void Start()
    {
        gateMaterial = gate.GetComponent<MeshRenderer>().material;
        bar = GasSlider.GetComponent<ProgressBar>();
    }

    private void Update()
    {
        setValue();
    }

    // Update is called once per frame
    public void setValue()
    {
        gateMaterial.SetFloat("_Alpha",gasValue);
        bar.currentPercent = gasValue * 100f;
    }
}
