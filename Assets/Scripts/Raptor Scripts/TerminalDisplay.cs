using UnityEngine;
using System.Collections;

public class TerminalDisplay : MonoBehaviour {

	public MapTerminal terminal;
	public UISlider transferBar;
	public UISlider alarmBar;


	// Use this for initialization
	void Start() {
	}

	// Update is called once per frame
	void Update() {
		transferBar.value = terminal.mapRemaining;
		alarmBar.value = terminal.timeRemaining;
	}
}
