using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ShipTutorial : MonoBehaviour {
	public UILabel textBox;

	//Room 1
	List<string> movement = new List<string>();//0


	List<List<string>> textLists = new List<List<string>>();
	List<string> currentList;
	int index = 0;

	// Use this for initialization
	void Start () {
		movement.Add("This tutorial will cover the level selection mode.");
		movement.Add("If you escape a level while the ship is alerted, you will also have to escape police ships in this mode.");
		movement.Add("You can try to fight them off or you run away.");
		movement.Add("Press SPACEBAR to shoot your basic weapon.");
		movement.Add("Press E to fire your current consumable weapon.");
		movement.Add("Press R to cycle through your consumable weapons.");
		movement.Add("While combat is an option, destroying police ships will raise your notoriety.");
		movement.Add("You can use EMP Grenades or just run away in order to avoid raising your notoriety.");
		movement.Add("Once the police have stopped searching for you, you can save the game by pressing ESCAPE and pressing the Save button. (Saving is disabled for the tutorial)");
		movement.Add("To spend money, click on the SHOP button in the lower right corner.");
		movement.Add("Use A and D to rotate your ship.");
		movement.Add("Use W to move forward and S to move backward.");
		movement.Add("Use Q to activate your cloak.");
		movement.Add("If you approach a ship while uncloaked, they will shoot you. Cloaking allows you to get near ships safely. ");
		movement.Add("To board a ship, you must cloak and collide with the back of the ship. ");
		movement.Add("Find and board a ship to complete the tutorial and return to the Main Menu.");

		currentList = movement;
		textBox.text = currentList[0];
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetAxis("Mouse ScrollWheel") < 0 && index < currentList.Count - 1) {
			index++;
			/*if(index > currentList.Count - 1) {
				index = 0;
			}*/
			textBox.text = currentList[index];
		}
		else if(Input.GetAxis("Mouse ScrollWheel") > 0 && index > 0) {
			index--;
			textBox.text = currentList[index];
		}
	}
}
