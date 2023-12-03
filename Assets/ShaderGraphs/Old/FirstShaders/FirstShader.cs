using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FirstShader : MonoBehaviour
{

    [SerializeField] private Material material;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            material.SetColor("_Color", Color.green);
        }
    }
}
