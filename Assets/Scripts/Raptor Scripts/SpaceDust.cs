using UnityEngine;
using System.Collections;

public class SpaceDust : MonoBehaviour {
	PlayerShipController ship;

	// Use this for initialization
	void Start () {
		ship = FindObjectOfType<PlayerShipController>();
	}
	
	// Update is called once per frame
	void LateUpdate () {
		if(ship != null && particleSystem != null) {
			Vector2 vel = ship.rigidbody2D.velocity;
			//float speed = vel.magnitude;
			//particleSystem.startSpeed = speed;
			//transform.localEulerAngles = new Vector3(0, Mathf.Atan2(vel.x,vel.y)*Mathf.Rad2Deg, 0);
			ParticleSystem.Particle[] parts = new ParticleSystem.Particle[particleSystem.particleCount];
			particleSystem.GetParticles(parts);
			for(int i = 0; i < parts.Length; i++) {
				parts[i].velocity = -vel;
			}
			particleSystem.SetParticles(parts, parts.Length);
		}
	}
}
