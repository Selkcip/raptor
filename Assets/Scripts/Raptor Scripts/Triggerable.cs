using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Triggerable : MonoBehaviour {

	public bool isTriggered = false;
	public Triggerable[] triggers;
	public bool or;
	private bool result;
	public List<Triggerable> triggerList = new List<Triggerable>();

	void addTrigger(Triggerable trigger){
		if(trigger){
			triggerList.Add(trigger);
		}
	}

	// Use this for initialization
	void Start () {
		foreach(Triggerable trigger in triggerList){
			addTrigger(trigger);
		}
	}
	
	// Update is called once per frame
	void Update () {
		result = !or;
		int triggerCount = 0;
		foreach(Triggerable trigger in triggerList){
			if (trigger){
				triggerCount++;
				 if(trigger.isTriggered == or){
					result = !result;
					break;
				}
			}
		}
	
		if (triggerCount > 0 && result != isTriggered){
			isTriggered = result;
			//gameObject.SendMessage("activate", isTriggered, SendMessageOptions.DontRequireReceiver);
		}
	
		gameObject.SendMessage("activate", isTriggered, SendMessageOptions.DontRequireReceiver);
	}
}
