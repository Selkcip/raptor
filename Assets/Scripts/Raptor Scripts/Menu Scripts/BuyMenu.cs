using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Upgrade {
	public int price;
	public int level;
	public bool addedToTotal;
	public UILabel priceLabel;
	public UIToggle checkbox;
	public string listing;
	public string name;

	public Upgrade(int p, string label, string box) {
		price = p;
		name = label;

		priceLabel = GameObject.Find(label).GetComponent<UILabel>();
		checkbox = GameObject.Find(box).GetComponent<UIToggle>();

		level = 1;
		addedToTotal = false;

		listing = priceLabel.text;
		priceLabel.text += price;
	}
}

public class BuyMenu : MonoBehaviour {

	int total = 0;
	UILabel totalLabel;
	UILabel moneyLabel;
	List<Upgrade> upgrades = new List<Upgrade>();
	List<Upgrade> purchases = new List<Upgrade>();

	UIButton buyButton;

	UILabel itemLabel;
	UILabel trackingLabel;
	UILabel statusLabel;

	// Use this for initialization
	void Start () {
		totalLabel = GameObject.Find("Total").GetComponent<UILabel>();
		moneyLabel = GameObject.Find("Money").GetComponent<UILabel>();

		itemLabel = GameObject.Find("Item Listing").GetComponent<UILabel>();
		trackingLabel = GameObject.Find("Tracking Listing").GetComponent<UILabel>();
		statusLabel = GameObject.Find("Status Listing").GetComponent<UILabel>();

		buyButton = GameObject.Find("Button - Buy").GetComponent<UIButton>();

		upgrades.Add(new Upgrade(200, "Health", "Health Buy"));
		upgrades.Add(new Upgrade(200, "Attack", "Attack Buy"));
		upgrades.Add(new Upgrade(999999, "Space Cowboy", "Space Cowboy Buy"));
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
				itemLabel.text = itemLabel.text + upgrade.name + " " + upgrade.level + "\n";
				statusLabel.text = statusLabel.text + "Processing\n";

				//Raise prices
				upgrade.level++;
				upgrade.price *= upgrade.level;
				upgrade.priceLabel.text = upgrade.listing + upgrade.price; 
			}
		}

		UpdateOrders();
	}

	void UpdateOrders() {

	}
}
