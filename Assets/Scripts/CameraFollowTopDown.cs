using UnityEngine;
using System.Collections;

public class CameraFollowTopDown : MonoBehaviour {

    public Transform player;
    public float height;

	// Use this for initialization
	void Start() {
        //transform.localEulerAngles = new Vector3(0f, 0f, 0f);
	}
	
	// Update is called once per frame
	void Update() {
        transform.position = player.transform.position;

        transform.position += new Vector3(0, 0, -height);
	}
}
