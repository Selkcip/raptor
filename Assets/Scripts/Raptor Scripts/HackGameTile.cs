using UnityEngine;
using System.Collections;

public class HackGameTile : MonoBehaviour {
	public int value = 1;
	public Vector3 pos = new Vector3();
	public float moveTime = 0.25f;
	public HackGameTile mergeTarget;
	//public Vector3 vel;

	// Use this for initialization
	void Start () {
	
	}

	public void Merge(HackGameTile tile) {
		//print("merging");
		//value += tile.value;
		Destroy(tile.gameObject);
	}
	
	// Update is called once per frame
	void Update () {
		Vector3 diff = pos - transform.position;
		if(diff.magnitude > 0.01f) {
			transform.position += diff * Time.deltaTime / moveTime;
		}
		else {
			transform.position = pos;
			if(mergeTarget != null) {
				mergeTarget.Merge(this);
			}
		}
	}
}
