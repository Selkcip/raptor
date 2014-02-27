using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class FireZone : MonoBehaviour {
	public bool zoneOnFire = false;
	public int maxEmitters = 20;
	public int zoneRadius = 3;
	public GameObject fireEmitter;
	public List<Fire> fireEmitterList = new List<Fire>();
	public Room room; //set this in the editor


	// Use this for initialization
	void Start () {
		room.fireZones.Add(this);
		transform.parent = room.transform;
		makeEmitters();
		zoneOnFire = true;
	}
	
	// Update is called once per frame
	void Update () {
		//debug thingy
		/*
		if(Input.GetKeyDown(KeyCode.F)) {
			room.fireZones[0].fireEmitterList[0].ToggleFire(true);
			room.fireZones[0].zoneOnFire = true;
			room.fireZones[0].StartCoroutine("SpreadFire");
			print("fire pls");
		}
		 * */
			//StartFire(0);

		CheckZone();
		if(zoneOnFire) {
			SpreadToZone();
		}
	}

	void OnDrawGizmos() {
		Gizmos.DrawWireSphere(transform.collider.bounds.center, zoneRadius);
	}

	void makeEmitters() {
		for(int i = 0; i < maxEmitters; i++) {
			Vector3 randomPoint = new Vector3(collider.bounds.center.x + Random.Range(-collider.bounds.size.x / 2, collider.bounds.size.x / 2),
										collider.bounds.center.y,
										collider.bounds.center.z + Random.Range(-collider.bounds.size.z / 2, collider.bounds.size.z / 2));

			GameObject fireObj = Instantiate(fireEmitter, randomPoint, Quaternion.Euler(Vector3.zero)) as GameObject;
			
			fireEmitterList.Add(fireObj.GetComponent<Fire>());
			fireObj.transform.parent = gameObject.transform;
			fireEmitterList[i].room = room;
		}
	}

	//checks if a zone is completely extinguished
	void CheckZone() {
		foreach(Fire emitter in fireEmitterList) {
			if(emitter.onFire) {
				zoneOnFire = true;
				return;
			}
		}
		zoneOnFire = false;
	}

	void SpreadToZone() {
		foreach(Fire emitter in fireEmitterList) {
			if(!emitter.onFire) {
				return;
			}
		}

		foreach(FireZone zone in room.fireZones) {
			if(zone.zoneOnFire || zone == this) {
				continue;
			}

			if (Vector3.Distance(transform.collider.bounds.center, zone.transform.collider.bounds.center)
				< (zoneRadius + zone.zoneRadius)) {
					zone.StartFire(0);
			}
		}

	}

	void StartFire(int i) {
		fireEmitterList[i].ToggleFire(true);
		zoneOnFire = true;
		StartCoroutine("SpreadFire");
	}

	IEnumerator SpreadFire() {
		while(zoneOnFire) {
			foreach(Fire emitter in fireEmitterList) {
				yield return new WaitForSeconds(1.0f);
				if(!zoneOnFire) {
					break;
				}
				emitter.ToggleFire(true);
			}
		}
	}
}