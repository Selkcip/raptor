﻿using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class RaptorDoor : MonoBehaviour {
	public float openDis = 1.5f;
	[SerializeField]
	private Transform LeftDoor;
	[SerializeField]
	private Transform RightDoor;
	public float closeAfter = 5;
	private float openTime = 0;

	public bool isOpen = false;
	public bool isLocked = false;

	private bool tweening = false;//Prevents the doors from tweening while tweening, dawg. 


	public void LockDoor(bool locked) {
		isLocked = locked;
		if(isOpen) {
			CloseDoor();
		}
	}

	//Testing only
	void Update() {
		if(isOpen && !tweening) {
			openTime += Time.deltaTime;
			if(openTime >= closeAfter) {
				openTime = 0;
				CloseDoor();
			}
		}

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

	void OnTriggerEnter(Collider other) {
		OpenDoor();
	}

	// These Functions should animate the doors open and closed.
	public void OpenDoor() {
		if(isLocked || isOpen || tweening) {
			return;
		}
		isOpen = true;
		tweening = true;
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_2"), SoundManager.SoundType.Sfx, this.gameObject);
		HOTween.To(LeftDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(-openDis, 0f, 0f), true));
		HOTween.To(RightDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(openDis, 0f, 0f), true).OnComplete(Complete));

		Vector3 pos = transform.TransformPoint(0, 0, 2.5f);
		ShipGrid.UpdateCellLinksI(pos);
		pos.y += 1;
		ShipGrid.UpdateCellLinksI(pos);
		pos.y += 1;
		ShipGrid.UpdateCellLinksI(pos);
		pos.y += 1;
		ShipGrid.UpdateCellLinksI(pos);
	}

	public void CloseDoor() {
		if(!isOpen || tweening) {
			return;
		}
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_1"), SoundManager.SoundType.Sfx, this.gameObject);
		isOpen = false;
		tweening = true;
		HOTween.To(LeftDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(openDis, 0f, 0f), true));
		HOTween.To(RightDoor, 1.0f, new TweenParms().Prop("localPosition", new Vector3(-openDis, 0f, 0f), true).OnComplete(Complete));
	}

	void Complete() {
		tweening = false;
		Vector3 pos = transform.TransformPoint(0, 0, 2.5f);
		ShipGrid.UpdateCellLinksI(pos);
		pos.y += 1;
		ShipGrid.UpdateCellLinksI(pos);
		pos.y += 1;
		ShipGrid.UpdateCellLinksI(pos);
		pos.y += 1;
		ShipGrid.UpdateCellLinksI(pos);
	}
}
