using UnityEngine;
using System.Collections;

public class ConfirmBribe : MonoBehaviour {
	public GameObject bribeMenu;

	void OnClick() {
		bribeMenu.SendMessage("Confirm", SendMessageOptions.DontRequireReceiver);
		bribeMenu.SetActive(false);
	}
}
