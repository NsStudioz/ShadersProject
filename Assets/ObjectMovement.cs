using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class ObjectMovement : MonoBehaviour
{

    [SerializeField] float timer = 0;
    [SerializeField] float timerThreshold = 0;
    [SerializeField] bool isFloatingUp = false;
    [SerializeField] float _timer = 0;

    void Start()
    {
        timer = timerThreshold;
    }

}
