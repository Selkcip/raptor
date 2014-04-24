using UnityEngine;
using System.Collections;

public class BloodSplatter : MonoBehaviour {
	public int chance = 50;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	private ParticleSystem.CollisionEvent[] collisionEvents = new ParticleSystem.CollisionEvent[16];
	void OnParticleCollision(GameObject other) {
		// adjust array length
		int safeLength = particleSystem.safeCollisionEventSize;
		if (collisionEvents.Length < safeLength) {
			collisionEvents = new ParticleSystem.CollisionEvent[safeLength];
		}
		// get collision events for the gameObject that the script is attached to
		int numCollisionEvents = particleSystem.GetCollisionEvents(other, collisionEvents);
		// apply some force to RigidBody components
		for (var i = 0; i < numCollisionEvents; i++) {
			if(Random.Range(0, 100) > 100 - chance) {
				Vector3 pos = collisionEvents[i].intersection;
				Vector3 dir = collisionEvents[i].velocity;
				Collider collider = collisionEvents[i].collider;
				DecalSystem decals = DecalSystem.instance;
				if(decals != null) {
					decals.CreateDecal(pos, dir, collider, 1);
				}
			}
		}
	}
}
