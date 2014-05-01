using UnityEngine;
using System.Collections;

public class ShopButton : MonoBehaviour {
	public GameObject buyMenu;
	public GameObject shipHUD;

	void OnClick() {
		BuyMenu.buying = true;
		buyMenu.SetActive(true);
		Time.timeScale = 0;
		shipHUD.gameObject.SetActive(false);
	}
}
