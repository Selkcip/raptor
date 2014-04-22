using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class RebindMenu : MonoBehaviour {

	public RebindableData rebindableManager;

	List<RebindableKey> rebindKeys;
	List<RebindableAxis> rebindAxes;
	bool rebinding = false;
	bool rebindingAxPo = false;
	bool rebindingAxNe = false;
	string objToRebind = "";

	// Use this for initialization
	void Start () {
		rebindKeys = rebindableManager.GetCurrentKeys();
		rebindAxes = rebindableManager.GetCurrentAxes();
	}
	
	// Update is called once per frame
	void Update () {
		if(rebinding){
			if(Input.anyKeyDown){
				KeyCode reboundKey = FetchPressedKey();

				if(reboundKey == KeyCode.None) {
					List<KeyCode> otherKeys = new List<KeyCode>(){
						KeyCode.LeftAlt,
						KeyCode.RightAlt,
						KeyCode.LeftShift,
						KeyCode.RightShift,
						KeyCode.LeftControl,
						KeyCode.RightControl
					};
					foreach(KeyCode code in otherKeys) {
						if(Input.GetKeyDown(code)) {
							reboundKey = code;
							break;
						}
					}
				}

				if(rebindingAxPo || rebindingAxNe) {
					foreach(RebindableAxis axis in rebindAxes) {
						if(axis.axisName == objToRebind) {
							if(rebindingAxPo) {
								axis.axisPos = reboundKey;
							}
							else {
								axis.axisNeg = reboundKey;
							}
						}
					}
				}
				else {
					foreach(RebindableKey key in rebindKeys) {
						if(key.inputName == objToRebind) {
							key.input = reboundKey;
						}
					}
				}

				objToRebind = "";
				rebinding = false;
				rebindingAxPo = false;
				rebindingAxNe = false;
			}
		}
	}

	void RebindKey(string inputName) {
		rebinding = true;
		objToRebind = inputName;
	}

	void RebindAxisPos(string axisName) {
		rebinding = true;
		rebindingAxPo = true;
		objToRebind = axisName;
	}

	void RebindAxisNeg(string axisName) {
		rebinding = true;
		rebindingAxNe = true;
		objToRebind = axisName;
	}

	void SaveBindings() {
		rebindableManager.SaveKeys();
		rebindableManager.SaveAxes();
	}

	void LoadDefaults() {
		rebindableManager.ActivateDefaultKeys();
		rebindableManager.ActivateDefaultAxes();
		rebindKeys = rebindableManager.GetCurrentKeys();
		rebindAxes = rebindableManager.GetCurrentAxes();
		//make sure you refresh the gui with the default values
	}

	KeyCode FetchPressedKey() {
		int e = 330;
		for(int i = 0; i < e; i++) {
			if(i < 128 || i > 255) {
				KeyCode key = (KeyCode)i;
				if(Input.GetKeyDown(key)) {
					return key;
				}
			}
		}
		return KeyCode.None;
	}
}
