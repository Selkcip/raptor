﻿using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class RaptorDoor : Triggerable {
	public float closeAfter = 5;
	private float openTime = 0;
	public int keyCardsToUnlock = 1;
	public bool locksRandomly = true;
	public float notorietyToLock = 10000;
	public bool guardsCanUnlock = true;
	public bool openOnTrigger = true;
	public bool openOnTriggerable = true;
	public int keysUsed = 0;

	public Vector3 leftOpenDir = new Vector3(-1.5f, 0, 0);
	public Vector3 rightOpenDir = new Vector3(1.5f, 0, 0);
	[SerializeField]
	private Transform LeftDoor;
	[SerializeField]
	private Transform RightDoor;

	public bool isOpen = false;
	public bool isLocked = false;

	private bool tweening = false;//Prevents the doors from tweening while tweening, dawg.

	void Start() {
		notorietyToLock = locksRandomly ? Random.Range(RaptorInteraction.minTrapNotoriety, RaptorInteraction.maxTrapNotoriety) : notorietyToLock;
	}

	public void LockDoor(bool locked) {
		isLocked = locked;
		if(isOpen && locked) {
			CloseDoor();
		}
	}

	public void Unlock(int keyCount) {
		keysUsed = keyCount;
		if(keyCount >= keyCardsToUnlock) {
			LockDoor(false);
		}
	}

	//Testing only
	protected override void Update() {
		base.Update();
		if(isOpen && !tweening) {
			openTime += Time.deltaTime;
			if(openTime >= closeAfter) {
				openTime = 0;
				CloseDoor();
			}
		}

		if(keyCardsToUnlock > 0 && RaptorInteraction.notoriety >= notorietyToLock) {
			LockDoor(true);
		}

		/*if(Input.GetKeyDown(KeyCode.L)) {
			OpenDoor();
		}

		else if (Input.GetKeyDown(KeyCode.K)){
			CloseDoor();
		}
		else if(Input.GetKeyDown(KeyCode.J)) {
			LockDoor(!isLocked);
			print(isLocked);
		}*/
	}

	void OnTriggerStay(Collider other) {
		if(openOnTrigger) {
			bool wasLocked = isLocked;
			other.SendMessageUpwards("UnlockDoor", this, SendMessageOptions.DontRequireReceiver);
			OpenDoor();
			isLocked = wasLocked;
		}
	}

	// These Functions should animate the doors open and closed.
	public void OpenDoor(bool forceOpen = false) {
		openTime = 0;
		if(!isOpen && !tweening) {
			if(!isLocked || keyCardsToUnlock <= 0 || forceOpen) {
				isOpen = true;
				tweening = true;
				SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_2"), SoundManager.SoundType.Sfx, this.gameObject);
				HOTween.To(LeftDoor, 1.0f, new TweenParms().Prop("localPosition", leftOpenDir, true));
				HOTween.To(RightDoor, 1.0f, new TweenParms().Prop("localPosition", rightOpenDir, true).OnComplete(Complete));

				UpdateGrid();
			}
		}
	}

	public void CloseDoor() {
		if(isOpen && !tweening) {
			SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_1"), SoundManager.SoundType.Sfx, this.gameObject);
			isOpen = false;
			tweening = true;
			HOTween.To(LeftDoor, 1.0f, new TweenParms().Prop("localPosition", -leftOpenDir, true));
			HOTween.To(RightDoor, 1.0f, new TweenParms().Prop("localPosition", -rightOpenDir, true).OnComplete(Complete));
		}
	}

	public void Activate(bool triggered) {
		if(triggered) {
			if(openOnTriggerable) {
				OpenDoor(true);
			}
			else {
				CloseDoor();
			}
		}
	}

	void Complete() {
		tweening = false;
		UpdateGrid();
	}

	void UpdateGrid() {
		ShipGrid.UpdateRegionLinksI(collider.bounds);
	}
}
