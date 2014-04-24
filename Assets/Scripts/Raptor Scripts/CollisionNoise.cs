using UnityEngine;
using System.Collections;

public class CollisionNoise : MonoBehaviour {
	public float minSpeed = 0.75f;
	public float noise = 20;
	public float noiseLifeTime = 0.01f;
	public float noiseFlowRate = 0.9f;
	AudioSource sound;

	// Use this for initialization
	void Start () {
	
	}

	void OnCollisionStay(Collision col) {
		float speed = col.relativeVelocity.magnitude;
		//print(speed);
		if(speed > minSpeed) {
			ShipGrid.AddFluidI(transform.position, "noise", noise * speed, noiseLifeTime, noiseFlowRate);
			if(sound == null) {
				sound = SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/Lasers/laser3"), SoundManager.SoundType.Sfx, gameObject);
			}
		}
	}
}
