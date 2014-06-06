using UnityEngine;
using System.Collections;

public class ToggleMenu : MonoBehaviour {
	public GameObject menu;
	public bool on;

	void OnClick(){
		if(!on) {
			menu.SendMessage("Close", SendMessageOptions.DontRequireReceiver);
		}
		else if (on) {
			menu.SetActive(on);
			menu.SendMessage("Restart", SendMessageOptions.DontRequireReceiver);
		}
		menu.SetActive(on);
	}
}
