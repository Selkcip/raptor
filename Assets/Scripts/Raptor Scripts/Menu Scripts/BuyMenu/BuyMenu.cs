using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Upgrade {
	public int price;
	public int startLevel;
	public int max;
	public int increment;

	public bool addedToTotal;
	public UILabel priceLabel;
	public UIToggle checkbox;
	public string listing;
	public string name;
	public string prefabName;

	public Upgrade(int p, string label, string box, string prefabName, int startLevel, int inc, int max) {
		price = p;
		name = label;
		this.prefabName = prefabName;
		this.startLevel = startLevel;
		this.max = max;

		priceLabel = GameObject.Find(label).GetComponent<UILabel>();
		checkbox = GameObject.Find(box).GetComponent<UIToggle>();
		checkbox.value = false;

		increment = inc; 
		addedToTotal = false;

		listing = priceLabel.text;
		priceLabel.text += "$" + price;
	}

	public int GetPrice(int stat) {
		if(startLevel == 0) {
			return price;
		}

		int multiplier = (stat / increment) - startLevel;
		if(multiplier <= 0) {
			return price;
		}
		return price * 2 * multiplier;
	}
}

public class BuyMenu : MonoBehaviour {

	public static bool buying = false;

	int total = 0;
	UILabel totalLabel;
	UILabel moneyLabel;
	List<Upgrade> upgrades = new List<Upgrade>();
	List<Upgrade> purchases = new List<Upgrade>();

	Dictionary<string, int> stats = new Dictionary<string,int>();

	UIButton buyButton;

	// Use this for initialization
	void Start () {
		totalLabel = GameObject.Find("Total").GetComponent<UILabel>();
		moneyLabel = GameObject.Find("Money").GetComponent<UILabel>();

		buyButton = GameObject.Find("Button - Buy").GetComponent<UIButton>();

		upgrades.Add(new Upgrade(2000, "Health", "Health Buy", "Health Upgrade", 2, 50, 10));
		stats.Add("Health", (int) RaptorInteraction.maxHealth);

		upgrades.Add(new Upgrade(2000, "Attack", "Attack Buy", "Attack Upgrade", 2, 10, 5));
		stats.Add("Attack", (int)RaptorInteraction.attack);

		upgrades.Add(new Upgrade(2000, "Stealth", "Stealth Buy", "Stealth Upgrade", 6, 30, 10));
		stats.Add("Stealth", (int)RaptorInteraction.stealthTime);

		upgrades.Add(new Upgrade(100000, "EMP", "EMP Buy", "Space EMP Upgrade", 0, 1, 0));
		stats.Add("EMP", PlayerShipController.consumables.Count);

		upgrades.Add(new Upgrade(100000, "Mine", "Mine Buy", "Space Mine Upgrade", 0, 1, 0));
		stats.Add("Mine", PlayerShipController.consumables.Count);

		upgrades.Add(new Upgrade(100000, "Space Cowboy", "Space Cowboy Buy", "Space Cowboy Upgrade", 0, 1, 0));
		stats.Add("Space Cowboy", PlayerShipController.consumables.Count);

		foreach(Upgrade upgrade in upgrades) {
			int stat;
			stats.TryGetValue(upgrade.name, out stat);
			upgrade.priceLabel.text = upgrade.listing + "$" + upgrade.GetPrice(stat);

			if(upgrade.startLevel != 0 && stat / upgrade.increment >= upgrade.max) {
				upgrade.priceLabel.text = upgrade.listing + "Sold Out";
				continue;
			}

			foreach(CollectibleUpgrade collectible in UpgradeSpawner.upgrades) {
				if(upgrade.prefabName == collectible.name) {
					upgrade.priceLabel.text = upgrade.listing + "Sold Out";
					upgrade.checkbox.enabled = false;
				}
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		//Adjust total based on what has been selected
		foreach(Upgrade upgrade in upgrades) {
			if(upgrade.checkbox.value && !upgrade.addedToTotal) {
				total += upgrade.price;
				upgrade.addedToTotal = true;
			}
			else if(!upgrade.checkbox.value && upgrade.addedToTotal) {
				total -= upgrade.price;
				upgrade.addedToTotal = false;
			}
		}
	
		totalLabel.text = "Total: $" + total;
		moneyLabel.text = "Money: $" + RaptorInteraction.money;

		//prevent the player from buying stuff they can't afford
		if(RaptorInteraction.money < total || total <= 0) {
			buyButton.isEnabled = false;
		}
		else if (!buyButton.isEnabled){
			buyButton.isEnabled = true;
		}
	}

	void BuyUpgrades() {
		RaptorInteraction.money -= total;

		foreach(Upgrade upgrade in upgrades) {
			if(upgrade.checkbox.value) {
				upgrade.checkbox.value = false;
				upgrade.addedToTotal = false;
				total -= upgrade.price;

				//add it to purchases
				purchases.Add(upgrade);

				UpgradeSpawner.upgrades.Add(Resources.Load<CollectibleUpgrade>("Prefabs/Upgrades/" + upgrade.prefabName));
				UpgradeSpawner.upgrades[UpgradeSpawner.upgrades.Count - 1].name = upgrade.prefabName;

				//Raise prices
				upgrade.priceLabel.text = upgrade.listing + "Sold Out";
				upgrade.checkbox.enabled = false;
			}
		}
	}
}
