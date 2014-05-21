using UnityEngine;
using System.Collections;

public class SpaceMenuAccelerator : MonoBehaviour {
	public Vector2 velocity = new Vector2(1,1);

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		rigidbody2D.velocity = velocity;
	}
}
