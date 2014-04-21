using UnityEngine;
using System.Collections;

public class ShopButton : MonoBehaviour {
	public GameObject buyMenu;

	void OnClick() {
		buyMenu.SetActive(true);
		gameObject.transform.root.gameObject.SetActive(false);
	}
}
