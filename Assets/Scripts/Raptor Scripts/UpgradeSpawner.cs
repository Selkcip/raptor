using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UpgradeSpawner : MonoBehaviour {
	public static List<CollectibleUpgrade> upgrades = new List<CollectibleUpgrade>();
	static bool upgradeSpawned = false;

	// Use this for initialization
	void Start () {
		upgradeSpawned = false;
	}

	void Update() {
		if(upgrades.Count > 0 && !upgradeSpawned) {
			if(Random.Range(0f, 1f) >= 0.5f) {
				CollectibleUpgrade upgrade = (CollectibleUpgrade)Instantiate(upgrades[0], transform.position, transform.rotation);
				upgrades.Remove(upgrades[0]);
				upgradeSpawned = true;
			}
		}
		else {
			Destroy(gameObject);
		}
	}
}
