using UnityEngine;
using System.Collections;

public class SpaceCowboy : SpaceBomb {
	public float speed = 1;
	
	protected override void Update () {
		base.Update();
		if(!attached) {
			transform.position += transform.up * speed;
		}
	}
}
