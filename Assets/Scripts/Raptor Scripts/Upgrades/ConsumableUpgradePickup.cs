using UnityEngine;
using System.Collections;

public class ConsumableUpgradePickup : CollectibleUpgrade {
	public ConsumableUpgrade upgradePrefab;

	public override void Apply(RaptorInteraction player) {
		PlayerShipController.AddConsumable(upgradePrefab);
	}
}
