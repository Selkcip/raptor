using UnityEngine;
using System.Collections;

public class PainIndicator : MonoBehaviour {
	public float life = 1;
	public Vector3 dir;

	// Use this for initialization
	void Start () {
		transform.LookAt(Camera.main.transform, dir);
	}
	
	// Update is called once per frame
	void Update () {
		life -= Time.deltaTime;
		if(life <= 0) {
			Destroy(gameObject);
		}
	}
}
