using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class TestCameraAnimation : MonoBehaviour
{
    void Start()
    {
        var sequence = DOTween.Sequence();
        sequence.Append(transform.DORotate(new Vector3(30, 70, 0), 2f));
    }
}
