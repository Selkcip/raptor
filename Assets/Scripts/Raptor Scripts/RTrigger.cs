using UnityEngine;
using System.Collections;

public class RTrigger : MonoBehaviour {

	public GameObject[] targets;
	public GameObject activator;

	// Use this for initialization
	void Start () {
		//activator = GameObject.Find("player");
	}
	
	// Update is called once per frame
	void Update () {
		if(collider.gameObject == activator){
			foreach(GameObject target in targets){
				target.SendMessage("activate", true);
			}
		}
	}
}
