using UnityEngine;
using System.Collections;

public class ShipHUD : MonoBehaviour {

	public UISlider health;
	public UISlider cloak;
	public UILabel spacecowboys;

	private PlayerShipController player;

	// Use this for initialization
	void Start () {
		player = GameObject.Find("PlayerShip").GetComponent<PlayerShipController>();

		LockMouse.lockMouse = false;
	}
	
	// Update is called once per frame
	void Update() {
		health.value = player.health / player.maxHealth;
		cloak.value = player.cloakCharge;

		spacecowboys.text = "Space Cowboys: " + PlayerShipController.consumables.Count;
	}
}
