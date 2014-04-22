using UnityEngine;
using System.Collections;

public class DeliveryShip : MonoBehaviour {
	public float speed = 1;
	public Upgrade upgrade;

	Transform playerShip;

	// Use this for initialization
	void Start () {
		playerShip = GameObject.Find("PlayerShip").transform;
	}
	
	// Update is called once per frame
	void Update () {
		//rigidbody2D.
	}
}
