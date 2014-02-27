using UnityEngine;
using System.Collections;


[AddComponentMenu("Tools/FireExtinguisher")]
public class FireExtinguisher : EquipableObject {

	public GameObject bullet;
	public float bulletSpeed;
	public int maxAmmo = 100;

	//[HideInInspector]
	public int ammo = 100;

	public GameObject spawn;
	private bool shooting = false;

	public override void Start() {
		ammo = maxAmmo;
		StopAction();
		audio.loop = true;
		//this.audio.Pause();
	}

	// Update is called once per frame
	public override void Update() {
		if(shooting && ammo > 0) {
			if(!audio.isPlaying)
				audio.Play();
		}
		else {
			audio.Stop();
		}
	}

	IEnumerator Shoot() {
		while(shooting && ammo > 0) {
			GameObject projectile = Instantiate(bullet, spawn.transform.position, transform.rotation) as GameObject;
			projectile.rigidbody.velocity = -transform.forward * bulletSpeed;
			ammo--;
			yield return new WaitForSeconds(0.1f);
		}
	}

	public override void Equip(Transform tran) {
		transform.parent = tran;
		transform.localPosition = new Vector3(0.6986818f, -0.4490072f, 0.9410844f);
		transform.localRotation = Quaternion.Euler(new Vector3(6.265102f, 168.7135f, 97.3195f));
	}


	public override void Action() {
		//Ray ray = Camera.main.ScreenPointToRay(new Vector2(Screen.width / 2, Screen.height / 2));
		shooting = true;
		StartCoroutine("Shoot");
		
	}

	public override void StopAction() {
		shooting = false;
	}

	public override void DropTool() {
		shooting = false;
	}
}
