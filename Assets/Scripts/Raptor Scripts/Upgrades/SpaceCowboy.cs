using UnityEngine;
using System.Collections;

public class SpaceCowboy : SpaceBomb {
	public float speed = 1;
	
	protected override void Update () {
		if(timerLight != null) {
			timerLight.rate = 1 - fuse / fuseTime;
		}
		fuse += Time.deltaTime;
		if(fuse >= fuseTime) {
			Detonate();
		}
		if(!attached) {
			transform.position += transform.up * speed;
		}
	}
}
