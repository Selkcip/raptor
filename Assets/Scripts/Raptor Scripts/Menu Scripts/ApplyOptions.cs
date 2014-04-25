using UnityEngine;
using System.Collections;

public class ApplyOptions : MonoBehaviour {

	public GameObject optionsMenu;

	void OnClick() {
		optionsMenu.SendMessage("Apply", SendMessageOptions.DontRequireReceiver);
		//optionsMenu.SetActive(false);
	}
}
