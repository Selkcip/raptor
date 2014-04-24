using UnityEngine;
using System.Collections;

public class ShipDamageUpgrade : CollectibleUpgrade {
	public float damageIncrease = 10;

	public override void Apply(RaptorInteraction player) {
		PlayerShipController.damage += damageIncrease;
	}
}
