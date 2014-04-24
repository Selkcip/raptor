using UnityEngine;
using System.Collections;

public class SpaceCowboyUpgrade : CollectibleUpgrade {

	public SpaceCowboy spaceCowboyPrefab;

	public override void Apply(RaptorInteraction player) {
		PlayerShipController.AddConsumable(spaceCowboyPrefab);
	}
}
