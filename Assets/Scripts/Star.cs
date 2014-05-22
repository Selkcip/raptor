using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Star : MonoBehaviour {

	public float minScale = 1.0f;
	public float maxScale = 1.0f;

	private List<Color> colors = new List<Color>();

	// Use this for initialization
	void Start() {
		colors.Add(new Color(1, 0.5f, 0));
		//colors.Add(Color.blue);
		colors.Add(Color.yellow);
		colors.Add(Color.white);
		colors.Add(new Color(1, 0.5f, 0.5f));
		colors.Add(new Color(0.5f, 0.5f, 1.0f));
		//type = (Type)UnityEngine.Random.Range(0, Enum.GetNames(typeof(Type)).Length);
		//renderer.material.mainTexture = (Texture)Resources.Load("PlanetTexture");
		//renderer.material.color = colors[Random.Range(0, colors.Count)];
		renderer.material.SetColor("_TintColor", colors[Random.Range(0, colors.Count)]);
		//renderer.material.color = new Color(UnityEngine.Random.value, UnityEngine.Random.value, UnityEngine.Random.value);
		transform.localScale *= UnityEngine.Random.Range(minScale, maxScale);
	}

	// Update is called once per frame
	void Update() {
		if(Camera.main != null) {
			transform.LookAt(Camera.main.transform);
		}
	}
}
