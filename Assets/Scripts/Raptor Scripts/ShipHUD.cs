using UnityEngine;
using System.Collections;

public class ShipHUD : MonoBehaviour {

	private UILabel notoriety;
	private UILabel money;
	private UILabel map;


	// Use this for initialization
	void Start () {
		notoriety = GameObject.Find("NotorietyLabel").GetComponent<UILabel>();
		money = GameObject.Find("MoneyLabel").GetComponent<UILabel>();
		map = GameObject.Find("MapLabel").GetComponent<UILabel>();
	}
	
	// Update is called once per frame
	void Update () {
		notoriety.text = "Notoriety: " + RaptorInteraction.notoriety;
		money.text = "Money: $" + RaptorInteraction.money;
		map.text = "Map Completion: " + RaptorInteraction.mapAmountAcquired + "%";
	}
}
