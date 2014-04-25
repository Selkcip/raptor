using UnityEngine;
using System.Collections;

public class ToggleMenu : MonoBehaviour {
	public GameObject menu;
	public bool on;

	void OnClick() {
		menu.SetActive(on);
	}
}
