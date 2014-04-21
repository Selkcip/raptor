using UnityEngine;
using System.Collections;

public class Pause : MonoBehaviour {
	private GameObject hud;
	private RaptorInteraction player;

	private UILabel notoriety;
	private UILabel money;
	private UILabel map;

	// Use this for initialization
	void Start () {
		hud = GameObject.Find("HUD");
		player = GameObject.Find("Player").GetComponent<RaptorInteraction>();

		notoriety = GameObject.Find("Notoriety").GetComponent<UILabel>();
		money = GameObject.Find("Money").GetComponent<UILabel>();
		map = GameObject.Find("Map").GetComponent<UILabel>();
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(KeyCode.Escape)) {
			Unpause();

		}

		notoriety.text = "Notoriety: " + RaptorInteraction.notoriety;
		money.text = "Money: $" + RaptorInteraction.money;
		map.text = "Map Completion: " + RaptorInteraction.mapAmountAcquired + "%";
	}

	public void Unpause() {
		//Time.timeScale = 1;
		hud.SetActive(true);
		LockMouse.lockMouse = true;
		Time.timeScale = 1;
		player.paused = false;
		player.toggleRotator(true);
		gameObject.SetActive(false);
	}

}
