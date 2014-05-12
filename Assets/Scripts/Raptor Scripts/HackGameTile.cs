using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class HackGameTile : MonoBehaviour {
	public int value = 0;
	public Vector3 pos = new Vector3();
	public float moveTime = 0.25f;
	public HackGameTile mergeTarget;
	//public Vector3 vel;
	List<Color> colors = new List<Color>();

	// Use this for initialization
	void Start () {
		colors.Add(Color.magenta);
		colors.Add(Color.red);
		colors.Add(Color.yellow);
		colors.Add(Color.blue);
		colors.Add(Color.cyan);
		colors.Add(Color.green);
	}

	public void Merge(HackGameTile tile) {
		//print("merging");
		//value += tile.value;
		Destroy(tile.gameObject);
	}
	
	// Update is called once per frame
	void Update () {
		renderer.material.color = colors[value];
		/*Vector3 diff = pos - transform.position;
		if(diff.magnitude > 0.05f) {
			transform.position += diff * Time.deltaTime / moveTime;
		}
		else {
			transform.position = pos;
			if(mergeTarget != null) {
				mergeTarget.Merge(this);
			}
		}*/
	}
}
