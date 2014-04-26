using UnityEngine;
using System.Collections;

public class ExitBuyMenu : MonoBehaviour {
	public GameObject shipHUD;
	public GameObject buyMenu;

	void OnClick() {
		shipHUD.SetActive(true);
		buyMenu.gameObject.SetActive(false);
	}
}
