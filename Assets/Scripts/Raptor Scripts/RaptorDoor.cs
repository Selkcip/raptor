﻿using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class RaptorDoor : MonoBehaviour {
	[SerializeField]
	private Transform LeftDoor;
	[SerializeField]
	private Transform RightDoor;

	private bool isOpen = false;
	private bool isLocked = false;

	private bool tweening = false;//Prevents the doors from tweening while tweening, dawg. 


	public void LockDoor(bool locked) {
		isLocked = locked;
		if(isOpen) {
			CloseDoor();
		}
	}

	//Testing only
	void Update() {
		if(Input.GetKeyDown(KeyCode.L)) {
			OpenDoor();
		}

		else if (Input.GetKeyDown(KeyCode.K)){
			CloseDoor();
		}
		else if(Input.GetKeyDown(KeyCode.J)) {
			LockDoor(!isLocked);
			print(isLocked);
		}
	}

	// These Functions should animate the doors open and closed.
	public void OpenDoor() {
		if(isLocked || isOpen || tweening) {
			return;
		}
		isOpen = true;
		tweening = true;
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_2"), SoundManager.SoundType.Sfx, this.gameObject);
		HOTween.To(LeftDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(-1.5f, 0f, 0f), true));
		HOTween.To(RightDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(1.5f, 0f, 0f), true).OnComplete(Complete));
	}

	public void CloseDoor() {
		if(!isOpen || tweening) {
			return;
		}
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_1"), SoundManager.SoundType.Sfx, this.gameObject);
		isOpen = false;
		tweening = true;
		HOTween.To(LeftDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(1.5f, 0f, 0f), true));
		HOTween.To(RightDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(-1.5f, 0f, 0f), true).OnComplete(Complete));
	}

	void Complete() {
		tweening = false;
	}
}
