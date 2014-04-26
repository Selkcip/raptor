using UnityEngine;
using System.Collections;

public class GameOver : MonoBehaviour {

	private GameObject hud;
	private RaptorInteraction player;
	private GameObject playerShip;
	private Transform gameOverPanel;

	private float health;

	public bool gameOver = false;
	// Use this for initialization
	void Start () {
		hud = GameObject.Find("HUD");
		if(hud == null) {
			hud = GameObject.Find("Ship HUD");
		}
		if(GameObject.Find("Player") != null){
			player = GameObject.Find("Player").GetComponent<RaptorInteraction>();
			health = player.health;
		}
		else {
			playerShip = GameObject.Find("PlayerShip");
			health = playerShip.GetComponent<PlayerShipController>().health;
		}

		gameOverPanel = transform.FindChild("Panel - GameOver");
		gameOverPanel.gameObject.SetActive(false);
	}
	
	// Update is called once per frame
	void Update () {
		if(health <= 0 && !gameOver) {
			StartCoroutine("GameOverPanel", 5);
		}
		
	}

	IEnumerator GameOverPanel(int seconds) {

		yield return new WaitForSeconds(seconds);
		

		Time.timeScale = 0;
		gameOverPanel.gameObject.SetActive(true);
		if(hud != null) {
			hud.SetActive(false);
		}
		Pause.paused = true;
		gameOver = true;
		LockMouse.lockMouse = false;
	}
}
