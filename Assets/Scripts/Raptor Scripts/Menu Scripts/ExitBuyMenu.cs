using UnityEngine;
using System.Collections;

public class ExitBuyMenu : MonoBehaviour {
	public GameObject shipHUD;

	void OnClick() {
		shipHUD.SetActive(true);
		gameObject.transform.root.gameObject.SetActive(false);
	}
}
