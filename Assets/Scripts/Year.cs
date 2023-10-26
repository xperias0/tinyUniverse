using System;
using System.Collections;
using System.Collections.Generic;
using Michsky.MUIP;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Year : MonoBehaviour
{
    // Start is called before the first frame update
    public static int currentYear;
    public GameObject yearSlider;
    private Slider _sliderManager;
    public GameObject yearText;
    private void Start()
    {
        currentYear = 2023;
        _sliderManager = yearSlider.GetComponent<Slider>();
    }




    public void setYear()
    {
        float yearT = _sliderManager.value;
        currentYear = (int)yearT;
        print("Cur: " + currentYear);
    }

    public void confirmYear()
    {
        yearText.GetComponent<TMP_Text>().SetText(currentYear.ToString());
        yearText.GetComponent<Animator>().SetTrigger("yearOut");
    }
}
