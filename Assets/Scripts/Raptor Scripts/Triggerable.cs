using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Triggerable : MonoBehaviour {

	public bool isTriggered = false;
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
	}
	
	// Update is called once per frame
	protected virtual void Update () {
		result = !or;
		int triggerCount = 0;
		foreach(Triggerable trigger in triggerList){
			if (trigger != null){
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

		gameObject.SendMessage("Activate", isTriggered, SendMessageOptions.DontRequireReceiver);
	}
}
