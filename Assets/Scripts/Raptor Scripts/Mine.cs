using UnityEngine;
using System.Collections;

public class Mine : MonoBehaviour {

	public float damage = 100f;
	public float playerDamage = 50f;
	
	public bool hacked = false;
	public bool activated = true;

	private Transform center;

	// Use this for initialization
	void Start () {
		center = transform.FindChild("center");
	}

	void OnTriggerEnter(Collider other) {
		if(!hacked && other.tag == "Player") {
			Explosion(other.transform, playerDamage);
		}
		else if(hacked && other.tag == "enemy" && activated) {
			Explosion(other.transform, damage);
		}
	}

	void Explosion(Transform other, float damageValue) {
		other.transform.SendMessageUpwards("Hurt", damageValue, SendMessageOptions.DontRequireReceiver);
		ShipGrid.AddFluidI(transform.position, "pressure", 200f, 1f, 0.01f);
		Destroy(gameObject);
		//add sound and explosion effect
	}

	public void Use() {
		//make an upgrade for dis shit
		if(!hacked) {
			RaptorInteraction.defusing = true;

			if(RaptorHUD.defuseTime >= 1.0f) {
				hacked = true;
				center.renderer.material.color = Color.blue;
			}
		}
		else if(hacked) {
			if(Input.GetKeyDown(KeyCode.E)) {
				activated = !activated;
				if(activated) {
					center.renderer.material.color = Color.black;
				}
				else {
					center.renderer.material.color = Color.blue;
				}
			}
		}
	}
}
