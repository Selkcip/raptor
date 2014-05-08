using UnityEngine;
using System.Collections;

public class FlashingLight : MonoBehaviour {
	public float rate = 1;
	public Color lightColor = Color.white;

	float time = 0;
	Color initColor;

	// Use this for initialization
	void Start () {
		/*if(renderer != null) {
			initColor = renderer.material.color;
		}*/
		if(light != null) {
			light.color = lightColor;
		}
	}
	
	// Update is called once per frame
	void Update () {
		rate = Mathf.Max(0.0000000001f, rate);
		time += Time.deltaTime / rate;
		float cos = Mathf.Cos(time);
		if(renderer != null) {
			renderer.material.color = lightColor * cos;
		}
		if(light != null) {
			light.intensity = cos;
		}
	}
}
