using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CopSpawner : MonoBehaviour {

	public GameObject copPrefab;
	public List<Transform> rooms;
	//public int copCount = 4;
	public float spawnRate = 1;
	public float notorietyStep = 8000;

	float spawnTime = 0;
	int copPerRoom = 0;
	int spawned = 0;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		spawnTime -= Time.deltaTime;
		if(Timer.pTime <= 0) {
			if(copPerRoom <= 0) {
				copPerRoom = Mathf.Min(5, Mathf.Max(1, Mathf.FloorToInt(RaptorInteraction.notoriety / notorietyStep)));
			}
			if(rooms.Count > 0 && spawnTime <= 0) {
				Transform room = rooms[0];
				spawned++;
				if(spawned >= copPerRoom) {
					rooms.Remove(room);
					spawned = 0;
				}
				GameObject copObj = (GameObject)GameObject.Instantiate(copPrefab, transform.position, transform.rotation);
				Cop cop = copObj.GetComponent<Cop>();
				cop.room = room;
				spawnTime = spawnRate;
			}
		}
	}
}
