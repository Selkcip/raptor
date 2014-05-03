using UnityEngine;
using System.Collections;

public class ExitBuyMenu : MonoBehaviour {
	public GameObject shipHUD;
	public GameObject buyMenu;

	void OnClick() {
		shipHUD.SetActive(true);
		Time.timeScale = 1;
		BuyMenu.buying = false;
		buyMenu.gameObject.SetActive(false);
	}
}
