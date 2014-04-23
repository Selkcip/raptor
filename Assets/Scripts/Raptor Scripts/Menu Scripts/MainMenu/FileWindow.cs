using UnityEngine;
using System.Collections;

public class FileWindow : MonoBehaviour {

	private UILabel name;
	private UILabel map;
	private UILabel notoriety;
	private UILabel money;
	

	// Use this for initialization
	void Start () {
		name = GameObject.Find("Input Label").GetComponent<UILabel>();
		name.text = "Click to enter name here";

		map = GameObject.Find("Map").GetComponent<UILabel>();
		map.text = "Map Completion: " + RaptorInteraction.mapAmountAcquired + "%";

		notoriety = GameObject.Find("Notoriety").GetComponent<UILabel>();
		notoriety.text = "Notoriety: $" + RaptorInteraction.notoriety;

		money = GameObject.Find("Money").GetComponent<UILabel>();
		money.text = "Money: $" + RaptorInteraction.money;
	}

	//Updates labels
	void UpdateWindow () {
		name.text = RaptorInteraction.name;
		map.text = "Map Completion: " + RaptorInteraction.mapAmountAcquired + "%";
		notoriety.text = "Notoriety: $" + RaptorInteraction.notoriety;
		money.text = "Money: $" + RaptorInteraction.money;
	}
}
