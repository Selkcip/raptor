using UnityEngine;
using System.Collections;
using System;

public class LocationProp : MonoBehaviour {
	public enum Type { planet, station}

	public Type type;
	public float minScale = 1.0f;
	public float maxScale = 1.0f;
	public bool randomPose = false;

	// Use this for initialization
	void Start() {
		//type = (Type)UnityEngine.Random.Range(0, Enum.GetNames(typeof(Type)).Length);
		//renderer.material.mainTexture = (Texture)Resources.Load("PlanetTexture");
		//renderer.material.color = new Color(UnityEngine.Random.value, UnityEngine.Random.value, UnityEngine.Random.value);
		renderer.material.SetColor("_TintColor", new Color(UnityEngine.Random.value, UnityEngine.Random.value, UnityEngine.Random.value));
		transform.localScale *= UnityEngine.Random.Range(minScale, maxScale);
	}

	// Update is called once per frame
	void Update() {
		if(Camera.main != null) {
			transform.LookAt(Camera.main.transform);
		}
	}
}
