using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Explosion : Triggerable {

	public float force = 10;
	public float forceLifeTime = 0.01f;
	public float forceFlowRate = 0.9f;
	public float damage = 10;
	public float damageLifeTime = 0.0001f;
	public float damageFlowRate = 0.5f;
	public new bool explodeOnStart = false;

	void Start() {
		if(explodeOnStart) {
			Activate(true);
		}
	}

	public void Activate(bool triggered) {
		if(triggered) {
			ShipGrid.AddFluidI(transform.position, "pressure", force, forceLifeTime, forceFlowRate);
			ShipGrid.AddFluidI(transform.position, "damage", damage, damageLifeTime, damageFlowRate);
			if(particleSystem != null) {
				particleSystem.Play();
			}
			SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/Explosions/explosion1"), SoundManager.SoundType.Sfx, gameObject);
		}
	}
}
