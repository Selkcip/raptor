using UnityEngine;
using System.Collections;

public class ShopButton : MonoBehaviour {
	public GameObject buyMenu;
	public GameObject shipHUD;

	void OnClick() {
		buyMenu.SetActive(true);
		shipHUD.gameObject.SetActive(false);
	}
}
