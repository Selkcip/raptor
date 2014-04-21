using UnityEngine;
using System.Collections;

public class Pause : MonoBehaviour {
	private GameObject hud;
	private RaptorInteraction player;
	private Transform pausePanel;
	private GameOver gameOver;

	private UILabel notoriety;
	private UILabel money;
	private UILabel map;

	public static bool paused;

	// Use this for initialization
	void Start () {
		hud = GameObject.Find("HUD");
		player = GameObject.Find("Player").GetComponent<RaptorInteraction>();

		notoriety = GameObject.Find("Notoriety").GetComponent<UILabel>();
		money = GameObject.Find("Money").GetComponent<UILabel>();
		map = GameObject.Find("Map").GetComponent<UILabel>();

		pausePanel = transform.FindChild("Panel - Pause");
		pausePanel.gameObject.SetActive(false);

		gameOver = GameObject.Find("GameOver").GetComponent<GameOver>();
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(KeyCode.Escape) && !gameOver.gameOver) {
			if(!paused) {
				PauseMenu();
			}
			else {
				Unpause();
			}

		}
	}

	public void PauseMenu() {
		Time.timeScale = 0;
		pausePanel.gameObject.SetActive(true);
		hud.SetActive(false);
		paused = true;
		LockMouse.lockMouse = false;

		notoriety.text = "Notoriety: " + RaptorInteraction.notoriety;
		money.text = "Money: $" + RaptorInteraction.money;
		map.text = "Map Completion: " + RaptorInteraction.mapAmountAcquired + "%";
	}

	public void Unpause() {
		Time.timeScale = 1;
		hud.SetActive(true);
		LockMouse.lockMouse = true;
		paused = false;
		pausePanel.gameObject.SetActive(false);
	}

}
