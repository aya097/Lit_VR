using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class TestCameraAnimation : MonoBehaviour
{
    void Start()
    {
        var sequence = DOTween.Sequence();
        Vector3 position = transform.position;
        // 視点を変える
        sequence.Append(transform.DORotate(new Vector3(-25, 70, 0), 1.5f));
        sequence.Append(transform.DORotate(new Vector3(-25, -70, 0), 2f));
        sequence.Append(transform.DORotate(new Vector3(0, 0, 0), 1.5f));

        // スロープ直前まで移動
        sequence.AppendInterval(0.5f);
        sequence.Append(transform.DORotate(new Vector3(0, 60, 0), 0.8f));
        position += new Vector3(3 * 1.732f, 0, 3);
        sequence.Append(transform.DOMove(position, 2f));

        // スロープのぼる
        sequence.Append(transform.DORotate(new Vector3(0, 0, 0), 0.8f));
        position += new Vector3(0, 3f, 10);
        sequence.Append(transform.DOMove(position, 3f));

        // 周りを見回す
        sequence.Append(transform.DORotate(new Vector3(-25, 70, 0), 1.5f));
        sequence.Append(transform.DORotate(new Vector3(0, -100, 0), 2f));
        sequence.Append(transform.DORotate(new Vector3(0, 100, 0), 3f));
        sequence.Append(transform.DORotate(new Vector3(0, -20, 0), 1.5f));
    }
}
