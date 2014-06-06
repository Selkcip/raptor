using UnityEngine;
using System.Collections;

public class CreditsButton : MonoBehaviour {
	public GameObject menu;
	public GameObject credits;

	void OnClick() {
		credits.SendMessage("Restart", SendMessageOptions.DontRequireReceiver);
		menu.SetActive(false);
		credits.SetActive(true);
	}
}
