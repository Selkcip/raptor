using UnityEngine;
using System.Collections;

public class DeliveryShip : MonoBehaviour {
	public float speed = 1;
	public TaggedTriggerable dock;

	Transform playerShip;

	// Use this for initialization
	void Start () {
		playerShip = GameObject.Find("PlayerShip").transform;
		/*SceneTransition transition = GameObject.FindObjectOfType<SceneTransition>();
		if(transition != null) {
			transition.triggerList.Add(dock);
		}*/
	}
	
	// Update is called once per frame
	void Update () {
		//rigidbody2D.AddForce(transform.up * speed);
	}
}
