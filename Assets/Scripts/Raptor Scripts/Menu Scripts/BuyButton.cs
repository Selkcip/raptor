using UnityEngine;
using System.Collections;

public class BuyButton : MonoBehaviour {
	GameObject menu;

	void Start() {
		menu = GameObject.Find("Buy Menu");//.GetComponent<BuyMenu>();
	}

	void OnClick() {
		menu.SendMessage("BuyUpgrades", SendMessageOptions.DontRequireReceiver);
	}
}
