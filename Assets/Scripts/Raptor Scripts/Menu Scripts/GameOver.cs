﻿using UnityEngine;
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

		player = GameObject.FindObjectOfType<RaptorInteraction>();//.Find("Player").GetComponent<RaptorInteraction>();

		gameOverPanel = transform.FindChild("Panel - GameOver");
		gameOverPanel.gameObject.SetActive(false);
	}
	
	// Update is called once per frame
	void Update () {
		if(player != null && player.health <= 0 && !gameOver) {
			StartCoroutine("GameOverPanel", 3);
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
