using UnityEngine;
using System.Collections;

public class PropRemover : MonoBehaviour {
	public float removeChance = 0.5f;

	// Use this for initialization
	void Start () {
		if(Random.Range(0f, 1f) >= removeChance) {
			Destroy(gameObject);
		}
	}
}
