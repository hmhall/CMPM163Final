using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class RenderEffectFastForward : MonoBehaviour
{
    public Shader FastForward;
    private Material screenMat;

    private void Awake()
    {
        screenMat = new Material(FastForward);
    }

    private void OnEnable()
    {
        screenMat = new Material(FastForward);

    }
    // Start is called before the first frame update
    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!FastForward && !FastForward.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        Graphics.Blit(sourceTexture, destTexture, screenMat);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            GetComponent<PostProcess>().enabled = true;
            GetComponent<Pixelation>().enabled = true;
            GetComponent<PostBlur>().enabled = true;
            this.enabled = false;

        }
        if (Input.GetKeyDown(KeyCode.Escape))
            Application.Quit();
    }

    void OnDisable()
    {
        if (screenMat)
        {
            DestroyImmediate(screenMat);
        }
    }
}
