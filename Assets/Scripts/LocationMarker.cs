using UnityEngine;
using System.Collections;

public class LocationMarker : MonoBehaviour {

	public Location location;
	public GameObject propObject;

	// Use this for initialization
	void Start() {
		gameObject.layer = LayerMask.NameToLayer("StarMap");

		for(int i = 0; i < Random.Range(0, 5); i++) {
			GameObject prop = (GameObject)GameObject.Instantiate(propObject);
			prop.transform.parent = transform;
			if(prop.GetComponent<LocationProp>().randomPose) {
				prop.transform.localPosition = new Vector3(UnityEngine.Random.Range(-0.5f, 0.5f), UnityEngine.Random.Range(-0.5f, 0.5f), UnityEngine.Random.Range(-0.5f, 0.5f));
			}
		}
	}

	// Update is called once per frame
	void Update() {
		transform.Rotate(new Vector3(0, 0.25f, 0));
	}
}
