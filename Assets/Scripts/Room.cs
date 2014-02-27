using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Room : MonoBehaviour {
	public LightManager[] lightManagers;
	public Door[] doors;
	//public TravelTube[] Tubes;
	public List<FireZone> fireZones = new List<FireZone>();
	public AudioClip fireAudio;

	public float maxAir;
	public Rect mapBounds;

	//[HideInInspector]
	public float air;
	[HideInInspector]
	public float heat;
	//[HideInInspector]
	public int fires = 0;
	public static float maxHeat = 100;
	public static int maxFires = 5;
	private int oldFireCount = 0;

	private float airStaleRate = 0.01f;
	private bool vented = false;
	public BoxCollider roomTrigger;

	public Incident[] incidents;

	private Bounds GetBounds(Transform trans, Bounds bounds) {
		if(trans.renderer != null) {
			bounds.Encapsulate(trans.renderer.bounds);
		}
		for(int i = 0; i < trans.childCount; i++) {
			Transform child = trans.GetChild(i);
			bounds = GetBounds(child, bounds);
		}
		return bounds;
	}

	// Use this for initialization
	void Start () {
		Ship.instance.rooms.Add(this);

		air = maxAir;
		//needs to be changed around with when we have actual rooms
		/*roomTrigger = gameObject.AddComponent<BoxCollider>();
		roomTrigger.isTrigger = true;
		Bounds bounds =  new Bounds(transform.position, new Vector3(1,1,1));
		bounds = GetBounds(transform, bounds);
		roomTrigger.center = bounds.center - transform.position;
		roomTrigger.size = bounds.size;*/
	}
	
	// Update is called once per frame
	void Update () {
		vented = (air / maxAir > 0.75) ? false : vented; // If vented the room should be locked
		air = Mathf.Max(0, air - airStaleRate);

		if(fires > oldFireCount) {
			if(oldFireCount < 1) {
				if(fireAudio != null) {
					SoundManager.instance.Play2DSound(fireAudio, SoundManager.SoundType.Dialogue);
				}
			}
			oldFireCount = fires;
			//DisplayPanel.ShowMessage("A fire is spreading in the " + name + " room.");
		}

		/*
		if(vented || fires > maxFires) {
			lockDoors();
		}
		else {
			unlockDoors();
		}
		 */
	}

	public void lockDoors() {
		foreach(Door door in doors) {
			door.LockDoor();
		}
	}

	public void unlockDoors() {
		foreach(Door door in doors) {
			door.UnlockDoor();
		}
	}

	public void Damage(float damage) {
		/*damage = ShieldGenerator.ReduceDamage(damage);
		foreach(ShipSystem system in Ship.instance.shipSystems) {
			system.Damage(damage);
		}
		foreach(Incident incident in incidents) {
			incident.Damage(damage);
		}*/
	}

	public void ventRoom() {
		// This should probably take time and we should make air flow between rooms so that connected rooms with open doors will also be vented
		air = 0;
		vented = true;
	}

	void OnTriggerEnter(Collider other) {
		if(other.name == "Player") {
			other.GetComponent<PlayerInteraction>().playerRoom = this;
		}
		else if(other.GetComponent<Fire>() != null) {
			other.GetComponent<Fire>().room = this;
		}
	}
}
