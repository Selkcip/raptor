using UnityEngine;
using System.Collections;

public class FireLaser : MonoBehaviour {
	int counter = 0;
	bool firing = false;
	// Use this for initialization
	void Start () {
		this.gameObject.particleSystem.Stop();
	}

	public void StartFiring() {
		StartCoroutine("FireLaserAuto");
	}

	IEnumerator FireLaserAuto() {
		yield return new WaitForSeconds(6.0f);
		FiringLaser();
		while(true) {
			yield return new WaitForSeconds(6.0f);
			FiringLaser();
		}
	}

	public void FiringLaser() {
		firing = true;
		this.gameObject.particleSystem.Play();
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/ExplosionAndWeapons/BFG_Laser_Shot"), SoundManager.SoundType.Sfx, this.gameObject);
		
		//Makes short shot vs beam
		//StartCoroutine("StopLaserParticles");
	}

	/*IEnumerator StopLaserParticle() {
		while (counter <= 10){
			counter++;
			yield return null;
		}
		this.particleSystem.Stop();
		firing = false;
		counter = 0;
	}*/

	// Update is called once per frame
	/*void Update () {
		//if (firing) counter++;
		if(Input.GetKeyDown(KeyCode.T)) {
			FiringLaser();
			//firing = true;
		}
		/*if(counter > 10) {
			this.particleSystem.Stop();
			firing = false;
			counter = 0;
		}
	}*/
}
