using UnityEngine;
using System.Collections;

public class SpaceEMPWave : SpaceExplosion {

	protected override void OnTriggerEnter2D(Collider2D col) {
		if(col.gameObject.GetComponent<PlayerShipController>() == null) {
			//Destroy(col.gameObject);
			col.transform.SendMessage("Stun", new Damage(damage, transform.position), SendMessageOptions.DontRequireReceiver);
		}
	}
}
