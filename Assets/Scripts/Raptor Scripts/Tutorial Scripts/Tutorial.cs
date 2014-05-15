using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Tutorial : MonoBehaviour {

	public UILabel textBox;

	//Room 1
	List<string> movement = new List<string>();//0

	//Room 2
	List<string> attacking = new List<string>();//1
	List<string> notoriety = new List<string>();//2

	//Room 3
	List<string> lights = new List<string>();//3
	List<string> climbing = new List<string>();//4

	//Room 4
	List<string> traps = new List<string>();//5
	List<string> collectibles = new List<string>();//6

	//Room 5
	List<string> hacking = new List<string>();//7

	List<List<string>> textLists = new List<List<string>>();
	List<string> currentList;
	int index = 0;

	// Use this for initialization
	void Start () {
		//Room 1
		movement.Add("This tutorial is based around the default controls. You can change the key bindings at any time by pausing the game and going into the options.");
		movement.Add("Use WASD to move and the mouse to look around. ");
		movement.Add("Press SPACE to jump.");
		movement.Add("Moving while holding LEFT SHIFT will make you sprint. Sprinting makes your movement louder.");
		movement.Add("Pressing LEFT CTRL will make you crouch. Crouching allows you to move through tighter areas and makes your movement quieter.");
		movement.Add("The door to the next room is locked. Look around the room and find the key card to proceed.");
		textLists.Add(movement);

		//Room 2
		attacking.Add("This room has a civilian. He won’t attack but he will run away and activate an alarm if he sees or hears you.");
		attacking.Add("Sneak up on him and knock him out or kill him.");
		attacking.Add("Use LEFT CLICK to slash at him or RIGHT CLICK to pounce on him and knock him out.");
		attacking.Add("Holding E will make you eat the civilian which restores health and hides the body.");
		textLists.Add(attacking);

		notoriety.Add("Stealth is highly recommended when possible since killing an enemy will raise your notoriety.");
		notoriety.Add("Notoriety causes enemies to place traps while being more aggressive and the police to arrive quicker if you are discovered");
		notoriety.Add("Being caught by an enemy or having the alarm activate will also raise your notoriety but to a lesser extent.");
		notoriety.Add("The timer above indicates how long you have before enemies will notice your ship at the dock.");
		notoriety.Add("If that timer runs out or an alarm is activated, another timer will start which indicates how long before the police arrive.");
		textLists.Add(notoriety);

		//Room 3
		lights.Add("The lights are currently off in this room.");
		lights.Add("Dark rooms will lower the vision of enemies and cause them to move towards light switches.");
		lights.Add("Press F to toggle on your night vision and turn on the lights by finding a light switch on the wall.");
		textLists.Add(lights);

		climbing.Add("Pouncing on walls or ceilings will cause you to stick to them.");
		climbing.Add("You can pounce from wall to wall to climb rooms.");
		climbing.Add("Pressing SPACE while clinging will let you drop down.");
		climbing.Add("Use wall clinging to find a keycard.");
		textLists.Add(climbing);

		//Room 4
		traps.Add("There is a proximity mine on the ground.");
		traps.Add("For tutorial purposes, this is a dummy mine, but mines are one type of trap that can spawn if your notoriety is high.");
		traps.Add("Approach it and hold E to defuse it.");
		traps.Add("You can choose to keep it active (blue) so it will hurt enemies who walk over it or just turn it off (black) by pressing E once it is defused.");
		traps.Add("Other traps include tripwires, cameras and sentry guns, so be sure to look out for them if you are very notorious. ");
		textLists.Add(traps);

		collectibles.Add("There is now a collectible on the floor.");
		collectibles.Add("Collectibles can be picked up by pressing E and dropped by pressing R.");
		collectibles.Add("Collectibles will distract guards and enemies for a while, but any collectibles you keep when you escape a ship will be converted to money.");
		collectibles.Add("Money can be used to lower your notoriety or buy upgrades while in space.");
		textLists.Add(collectibles);

		//Room 5
		hacking.Add("This room has a map terminal");
		hacking.Add("Sometimes getting to a terminal may be too risky to your survival, but your primary goal is to find one, hack it for map data, and escape.");
		hacking.Add("Go to the terminal and press E to begin hacking.");
		hacking.Add("On this screen, use WASD to move tiles around and combine them.");
		hacking.Add("Combining tiles will give you map data.");
		hacking.Add("Press SPACE or E to stop hacking.");
		hacking.Add("Try to combine as many tiles as you can. The meter indicates how much more data you can steal.");
		hacking.Add("If you try to steal more data while the meter is full, you will activate the alarm.");
		hacking.Add("When you are done hacking, return to your ship in the first room, and press E to complete the tutorial.  ");
		textLists.Add(hacking);

		currentList = textLists[0];
		textBox.text = currentList[index];
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(KeyCode.Return)) {
			index++;
			if(index > currentList.Count - 1) {
				index = 0;
			}
			textBox.text = currentList[index];
		}
	}

	void ChangeList(int listIndex) {
		index = 0;
		currentList = textLists[listIndex];
		textBox.text = currentList[index];
	}
}
