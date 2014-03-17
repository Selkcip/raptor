﻿using UnityEngine;
using System.Collections;

public class ShipBullet : MonoBehaviour {

	public float time; // life time of the bullet

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		time -= Time.deltaTime;
		if (time < 0)
			Destroy(this.gameObject);
	}
}