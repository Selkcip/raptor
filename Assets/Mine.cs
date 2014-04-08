using UnityEngine;
using System.Collections;

public class Mine : MonoBehaviour {

	public float damage = 100f;
	public float playerDamage = 50f;
	
	public bool hacked = false;
	public bool activated = true;

	// Use this for initialization
	void Start () {

	}

	void OnTriggerEnter(Collider other) {
		if(!hacked && other.tag == "Player") {
			Explosion(other.transform, playerDamage);
		}
		else if(hacked && other.tag == "enemy") {
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
			RaptorHUD.defuseTime += 0.25f * Time.deltaTime;
			if(RaptorHUD.defuseTime >= 1.0f) {
				hacked = true;
			}
		}
		else if(hacked) {
			activated = !activated;
		}
		//switch a light on the mine to indicate on or off
	}
}
