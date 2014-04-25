using UnityEngine;
using System.Collections;

public class KeyButton : MonoBehaviour {

	public UILabel label;
	public string action;
	public bool posAxis = false;
	public bool negAxis = false;

	// Use this for initialization
	void Start () {
	}

	void Update() {
		if(posAxis) {
			label.text = RebindableInput.GetPositiveFromAxis(action).ToString();
		}
		else if(negAxis) {
			label.text = RebindableInput.GetNegativeFromAxis(action).ToString();
		}
		else {
			label.text = RebindableInput.GetKeyFromBinding(action).ToString();
		}
	}

	void OnClick() {
		if(posAxis) {
			RebindMenu.instance.RebindAxisPos(action);
		}
		else if(negAxis) {
			RebindMenu.instance.RebindAxisNeg(action);
		}
		else {
			RebindMenu.instance.RebindKey(action);
		}
	}
}
