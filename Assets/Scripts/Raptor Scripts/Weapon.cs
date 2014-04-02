using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum WeaponType { projectile, melee }

public class Weapon : ShipGridItem {

	public WeaponType type;
	public float fireRate = 0.25f;
	public int clipSize = 15;
	public int ammo = 60;
	public float reloadTime = 1;
	public Transform muzzle;
	public Light flashLight;
	public GameObject projectile;

	private float fireCoolDown = 0;
	public int clip;
	public bool dropped = false;

	// Use this for initialization
	void Start() {
		clip = clipSize;
		ammo -= clipSize;

		if(dropped) {
			Drop();
		}
		else {
			PickUp();
		}
	}

	public bool Reload() {
		fireCoolDown = reloadTime;
		clip = Mathf.Max(0, clip);
		int newClip = Mathf.Min(Mathf.Max(0, clipSize-clip), ammo);
		clip += newClip;
		ammo -= newClip;
		return clip > 0;
	}

	public bool Use(GameObject user) {
		if(user.tag == "enemy" && dropped) {
			Enemy enemy = user.GetComponent<Enemy>();
			if(enemy.weaponAnchor != null && enemy.weapon == null) {
				PickUp(enemy);
			}
		}
		else {
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
		}
		return false;
	}

	public void Drop() {
		dropped = true;
		rigidbody.isKinematic = false;
		transform.parent = null;
		collider.enabled = true;
		interestLevel = 0.01f;
		base.Update();
	}

	public void PickUp(Enemy enemy = null) {
		dropped = false;
		rigidbody.isKinematic = true;
		collider.enabled = false;
		interestLevel = 10000000;
		if(enemy != null) {
			enemy.weapon = this;
			enemy.carryingObject = true;
			transform.parent = enemy.weaponAnchor;
		}
		transform.localPosition = Vector3.zero;
		transform.localEulerAngles = Vector3.zero;
		if(cell != null) {
			cell.RemoveItem(this);
		}
	}

	// Update is called once per frame
	public override void Update() {
		fireCoolDown = Mathf.Max(0, fireCoolDown - Time.deltaTime);
	}
}
