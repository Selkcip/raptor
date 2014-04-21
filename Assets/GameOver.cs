﻿using UnityEngine;
using System.Collections;

public class GameOver : MonoBehaviour {

	private GameObject hud;
	private RaptorInteraction player;
	private Transform gameOverPanel;

	public bool gameOver = false;
	// Use this for initialization
	void Start () {
		hud = GameObject.Find("HUD");
		player = GameObject.Find("Player").GetComponent<RaptorInteraction>();

		gameOverPanel = transform.FindChild("Panel - GameOver");
		gameOverPanel.gameObject.SetActive(false);
	}
	
	// Update is called once per frame
	void Update () {
		if(player.health <= 0 && !gameOver) {
			StartCoroutine("GameOverPanel", 5);
		}
		
	}

	IEnumerator GameOverPanel(int seconds) {

		yield return new WaitForSeconds(seconds);
		

		Time.timeScale = 0;
		gameOverPanel.gameObject.SetActive(true);
		hud.SetActive(false);
		Pause.paused = true;
		gameOver = true;
		LockMouse.lockMouse = false;
	}
}
