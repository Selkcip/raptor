using UnityEngine;
using System.Collections;

public class FireRateController : MonoBehaviour {

	float rate;
	Vector3 scale;

	// Use this for initialization
	void Start () {
		rate = this.particleSystem.emissionRate;
		scale = this.transform.localScale;
		this.particleSystem.emissionRate = scale.x * scale.y * scale.z * rate;
	}

	public void StartFire() {
		this.particleSystem.Play();
		foreach(Transform child in transform) {
			child.particleSystem.Play();
		}
	}

	public void KillFire() {
		this.particleSystem.Stop();
		foreach(Transform child in transform) {
			child.particleSystem.Stop();
		}
	}
	
	// Update is called once per frame
	void Update () {
		/*if(Input.GetKeyDown(KeyCode.T)) {
			StartFire();
		}
		else if(Input.GetKeyDown(KeyCode.Y)) {
			KillFire();
		}
		 * */
	}
}
