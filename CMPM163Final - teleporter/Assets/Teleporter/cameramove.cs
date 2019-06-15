using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameramove : MonoBehaviour
{
    float speed = 0.5f;
    private Vector3 mousepos = new Vector3(0, 0, 0);
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        mousepos = Input.mousePosition - mousepos;
        mousepos = new Vector3(-mousepos.y * 0.5f, mousepos.x * 0.5f, 0);
        mousepos = new Vector3(transform.eulerAngles.x + mousepos.x, transform.eulerAngles.y + mousepos.y, 0);
        transform.eulerAngles = mousepos;
        mousepos = Input.mousePosition;

        if (Input.GetAxis("Vertical") != 0)
        {
            transform.Translate(transform.forward * speed * Input.GetAxis("Vertical"));
        }
        if (Input.GetAxis("Horizontal") != 0)
        {
            transform.Translate(transform.right * speed * Input.GetAxis("Horizontal"));
        }
    }
}
