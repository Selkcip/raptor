using UnityEngine;
using System.Collections;

public class EscapeShip : Triggerable {
	public float warmUpTime = 2;
	public float speed = 1;

	float warmUp = 0;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		base.Update();
		if(isTriggered) {
			warmUp += Time.deltaTime;
			if(warmUp > warmUpTime) {
				transform.position += transform.forward * speed;
			}
		}
	}
}
