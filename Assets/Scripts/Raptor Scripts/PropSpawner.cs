using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PropSpawner : MonoBehaviour {
	public int propCount = 0;
	public bool randomCount = false;
	public float spawnHeight = 1;
	public float spawnBorder = 0.1f;
	//public bool spawnInside = false;
	public List<GameObject> props = new List<GameObject>();

	public Bounds bounds;
	int maxTries;

	// Use this for initialization
	void Start () {
		propCount = randomCount ? Random.Range(0, propCount + 1) : propCount;
		maxTries = propCount * 3;

		bounds = new Bounds(transform.position, Vector3.zero);
		Collider[] colliders = gameObject.GetComponentsInChildren<Collider>();
		foreach(Collider col in colliders) {
			bounds.Encapsulate(col.bounds);
		}
	}
	
	// Update is called once per frame
	void Update () {
		if(maxTries > 0 && props.Count > 0 && propCount > 0) {
			maxTries--;

			GameObject prop = (GameObject)Instantiate(props[Random.Range(0, props.Count)]);
			prop.transform.parent = transform;
			Bounds propBounds = prop.collider.bounds;

			Vector3 propPos = bounds.extents;
			propPos -= new Vector3(propBounds.extents.x, 0, propBounds.extents.z);
			propPos -= new Vector3(spawnBorder, 0, spawnBorder);
			propPos.y += spawnHeight+prop.transform.position.y-propBounds.min.y;
			propPos.x *= Random.Range(-1f, 1f);
			propPos.z *= Random.Range(-1f, 1f);
			propPos += bounds.center;

			prop.transform.position = propPos;
			propBounds = prop.collider.bounds;

			float radius = new Vector2(propBounds.extents.x, propBounds.extents.z).magnitude;
			Vector3 top = new Vector3(0, propBounds.max.y - radius, 0);
			Vector3 bottom = new Vector3(0, propBounds.min.y + radius, 0);
			Debug.DrawLine(propBounds.center + top, propBounds.center + bottom);

			prop.SetActive(false);
			RaycastHit hit;
			if(Physics.CapsuleCast(propBounds.center + top, propBounds.center + bottom, radius, Vector3.down, out hit, 0.1f)) {
				Destroy(prop);
			}
			else {
				prop.SetActive(true);
				propCount--;
			}
		}
		else {
			this.enabled = false;
		}
	}
}
