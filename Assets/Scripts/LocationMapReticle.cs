using UnityEngine;
using System.Collections;

public class LocationMapReticle : MonoBehaviour {

	public Transform spinner;
	//public LocationMapReticleScreen panel;
	public float fadeTime = 5;
	public bool fades = true;
	public Color color;
	private float fade = 0;
	private Location m_location;

	public Location location { get { return m_location; }
		set {
			m_location = value;
		}
	}

	public void Show() {
		fade = fadeTime;
	}

	// Use this for initialization
	void Start() {

	}

	// Update is called once per frame
	void Update() {
		fade = fades ? Mathf.Max(0, fade - 1.0f) : fadeTime;
		Color newColor = color;
		newColor.a = fade / fadeTime;
		if(spinner != null) {
			//spinner.renderer.enabled = fade > 0;
			spinner.renderer.material.color = newColor;
		}

		transform.LookAt(Camera.main.transform);
		if(spinner != null){
			spinner.Rotate(new Vector3(0, 0, 0.1f));
		}
	}
}
