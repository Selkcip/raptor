using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class RandomHeadwear : MonoBehaviour {
	public List<GameObject> headWear = new List<GameObject>();

	// Use this for initialization
	void Start () {
		int keep = Random.Range(0, headWear.Count);
		for(int i = 0; i < headWear.Count; i++) {
			if(i != keep) {
				headWear[i].SetActive(false);
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
