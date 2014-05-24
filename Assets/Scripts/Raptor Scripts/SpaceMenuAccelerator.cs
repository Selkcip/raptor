using UnityEngine;
using System.Collections;

public class SpaceMenuAccelerator : MonoBehaviour {
	public float speed = 10;

	// Use this for initialization
	void Start () {
		transform.eulerAngles = new Vector3(0, 0, Random.Range(0f, 360f));
	}
	
	// Update is called once per frame
	void Update () {
		rigidbody2D.velocity = transform.up * speed;
	}
}
