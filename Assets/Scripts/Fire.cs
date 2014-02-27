using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Fire: MonoBehaviour {

	public bool onFire = false;
	public float airConsumption = 1.0f;
	public float maxHealth;
	public Room room;

	[HideInInspector]
	public float health;

	private float extinguishedCoolDown = 10.0f;//How long fire must wait before it can start again

	private bool reignitable = true;

	void Start () {
		maxHealth = 4f;
		health = maxHealth;

		ToggleFire(false);
	}
	
	void Update () {
		//Visual Debug stuff replace it later
		if(onFire){
			room.air -= airConsumption* Time.deltaTime;
			if (room.air <= 0){
				ToggleFire(false);
				room.fires--;
			}

			if(health <= 0) {
				ToggleFire(false);
				room.fires--;
				StartCoroutine("ExtinguishCoolDown");
			}
		}
	}

	IEnumerator ExtinguishCoolDown() {
		yield return new WaitForSeconds(extinguishedCoolDown);

		reignitable = true;
	}

	public void ToggleFire(bool toggle) {
		if(reignitable || !toggle) {
			gameObject.particleSystem.enableEmission = toggle;
			gameObject.audio.enabled = toggle;

			foreach(Transform child in transform) {
				if(child.particleSystem != null) {
					child.particleSystem.enableEmission = toggle;
				}
			}
			onFire = toggle;

			if(toggle) {
				reignitable = false;
				health = maxHealth;
				room.fires++;
			}
		}
	}
}