using UnityEngine;
using System.Collections;

public class DeliveryShip : MonoBehaviour {
	public float speed = 1;
	public TaggedTriggerable dock;

	public float health = 100;

	Transform playerShip;

	// Use this for initialization
	void Start () {
		playerShip = GameObject.Find("PlayerShip").transform;
		transform.eulerAngles = new Vector3(0, 0, Random.Range(0f, 360f));
		/*SceneTransition transition = GameObject.FindObjectOfType<SceneTransition>();
		if(transition != null) {
			transition.triggerList.Add(dock);
		}*/
	}
	
	// Update is called once per frame
	void Update () {
		rigidbody2D.velocity = transform.up * speed;
	}

	public void Hurt(Damage damage) {
		health -= damage.amount;
	}
}
