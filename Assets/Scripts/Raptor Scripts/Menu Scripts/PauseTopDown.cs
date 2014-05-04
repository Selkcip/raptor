using UnityEngine;
using System.Collections;

public class PauseTopDown : MonoBehaviour {
	private GameObject hud;
	private Transform pausePanel;
	private GameOverTopdown gameOver;

	private UILabel name;
	private UILabel notoriety;
	private UILabel money;
	private UILabel map;

	public static bool paused;
	public GameObject optionsWindow;

	// Use this for initialization
	void Start() {
		hud = GameObject.Find("HUD");
		if(hud == null) {
			hud = GameObject.Find("Ship HUD");
		}

		name = GameObject.Find("Name").GetComponent<UILabel>();
		notoriety = GameObject.Find("Notoriety").GetComponent<UILabel>();
		money = GameObject.Find("Money").GetComponent<UILabel>();
		map = GameObject.Find("Map").GetComponent<UILabel>();

		pausePanel = transform.FindChild("Panel - Pause");
		pausePanel.gameObject.SetActive(false);

		gameOver = GameObject.Find("GameOver").GetComponent<GameOverTopdown>();
	}

	// Update is called once per frame
	void Update() {
		if(Input.GetKeyDown(KeyCode.Escape) && !gameOver.gameOver && !BuyMenu.buying) {
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
		if(hud != null) {
			hud.SetActive(false);
		}
		paused = true;
		LockMouse.lockMouse = false;

		name.text = RaptorInteraction.name;
		notoriety.text = "Notoriety: " + (int)RaptorInteraction.notoriety;
		money.text = "Money: $" + RaptorInteraction.money;
		map.text = "Map Completion: " + (int)(RaptorInteraction.mapAmountAcquired * 100) + "%";
	}

	public void Unpause() {
		Time.timeScale = 1;
		if(hud != null) {
			hud.SetActive(true);
		}
		LockMouse.lockMouse = true;
		paused = false;
		pausePanel.gameObject.SetActive(false);
		optionsWindow.SetActive(false);
	}

}
