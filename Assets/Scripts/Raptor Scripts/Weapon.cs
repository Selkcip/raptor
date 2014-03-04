using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum WeaponType { projectile, melee }

public class Weapon : MonoBehaviour {

	public WeaponType type;
	public float fireRate = 0.25f;
	public int clipSize = 15;
	public int ammo = 60;
	public float reloadTime = 1;
	public Transform muzzle;
	public GameObject projectile;

	private float fireCoolDown = 0;
	private int clip;

	// Use this for initialization
	void Start() {
		clip = clipSize;
		ammo -= clipSize;
	}

	public bool Reload() {
		fireCoolDown = reloadTime;
		int newClip = Mathf.Min(Mathf.Max(0, clipSize-clip), ammo);
		clip += newClip;
		ammo -= newClip;
		return clip > 0;
	}

	public bool Use() {
		if(clip > 0) {
			if(fireCoolDown <= 0) {
				fireCoolDown = fireRate;
				if(muzzle != null && projectile != null) {
					clip--;
					Instantiate(projectile, muzzle.position, muzzle.rotation);
				}
			}
			return true;
		}
		Reload();
		return false;
	}

	public void Drop() {
		rigidbody.isKinematic = false;
		transform.parent = null;
		collider.enabled = true;
	}

	public void PickUp() {
		rigidbody.isKinematic = true;
		collider.enabled = false;
	}

	// Update is called once per frame
	void Update() {
		fireCoolDown = Mathf.Max(0, fireCoolDown - Time.deltaTime);
	}
}
