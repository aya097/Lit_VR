using System.Collections;
using System.Collections.Generic;
using R3;
using Unity.VisualScripting;
using UnityEngine;

[ExecuteAlways]
public class StageEffectorMono : MonoBehaviour
{
    [Range(0, 1)]
    public float LightValue;

    [SerializeField] List<Material> materials;

    void Start()
    {
        // Observable.EveryValueChanged()
        // .Subscribe()
        // .AddTo(this);
    }

    void Update()
    {
        // fog
        RenderSettings.fogDensity = (LightValue < 0.5f) ? 0.1f * (1 - LightValue * 2) : 0f;
        foreach (var material in materials)
        {
            material.SetFloat("_LightValue", LightValue);
        }
    }
}
