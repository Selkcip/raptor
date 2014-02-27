using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class Door : MonoBehaviour {
	public Room[] rooms;
	[SerializeField] private Transform LeftDoor;
	[SerializeField] private Transform RightDoor;
	private bool m_opened = false;
	[SerializeField]
	protected bool m_locked = false;

	public bool opened { get { return m_opened; } }
	public bool locked { get { return m_locked; } set { m_locked = value; } }

	void OnTriggerEnter(Collider other) {
		if(!m_locked) {
			if(other.tag == "Player") {
				OpenDoor();
			}
		}
	}

	public virtual void LockDoor() {
		m_locked = true;
	}

	public virtual void UnlockDoor() {
		m_locked = false;
	}

	public virtual Room GetNeighbor(Room current) {
		return rooms[0] == current ? rooms[1] : rooms[0];
	}

	void OnTriggerExit(Collider other) {
		if(other.tag == "Player") {
			CloseDoor();
		}
	}

	// These Functions should animate the doors open and closed.
	public void OpenDoor() {
		if(m_opened == false)
			SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_2"), SoundManager.SoundType.Sfx, this.gameObject);
		m_opened = true;
        HOTween.To(LeftDoor, 0.5f, "localPosition", new Vector3(1.051959f, 0f, 0f));
        HOTween.To(RightDoor, 0.5f, "localPosition", new Vector3(-1.051959f, 0f, 0f));
	}

	public void CloseDoor() {
		if(m_opened == true)
			SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Door_Slide_1"), SoundManager.SoundType.Sfx, this.gameObject);
		m_opened = false;
		HOTween.To(LeftDoor, 0.5f, "localPosition", new Vector3(-0f, 0f, -0f));
		HOTween.To(RightDoor, 0.5f, "localPosition", new Vector3(0f, 0f, -0f));
	}
}
