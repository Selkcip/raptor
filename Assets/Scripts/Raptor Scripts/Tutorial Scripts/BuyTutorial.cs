using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BuyTutorial : MonoBehaviour {
	public UILabel textBox;

	//Room 1
	List<string> movement = new List<string>();//0


	List<List<string>> textLists = new List<List<string>>();
	List<string> currentList;
	int index = 0;

	// Use this for initialization
	void Start() {
		movement.Add("You can buy consumable weapons and upgrades by checking the boxes on the right and clicking the BUY button in the lower right corner.");
		movement.Add("You can also spend your money to lower your notoriety by clicking on the BRIBE button. ");
		movement.Add("When you buy an upgrade, a delivery ship containing one of your upgrades will spawn and a cursor around your ship appears indicating where you can find it.");
		movement.Add("Once you find the ship, you can board it and find your upgrade. ");
		movement.Add("If you do not retrieve your upgrade before leaving, you will have to buy it again.");

		currentList = movement;
		textBox.text = currentList[0];
	}

	// Update is called once per frame
	void Update() {
		if(Input.GetKeyDown(KeyCode.Return) && index < currentList.Count - 1) {
			index++;
			/*if(index > currentList.Count - 1) {
				index = 0;
			}*/
			textBox.text = currentList[index];
		}
		else if(Input.GetKeyDown(KeyCode.Backspace) && index > 0) {
			index--;
			textBox.text = currentList[index];
		}
	}
}
