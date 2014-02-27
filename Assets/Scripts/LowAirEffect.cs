using UnityEngine;
using System.Collections;

public class LowAirEffect : MonoBehaviour {

	public float minAir = 100;
	public float maxIntensity = 50;
	public float fadeSpeed = 0.125f;

	private float intensity = 0;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		Room playerRoom = GameObject.Find("Player").GetComponent<PlayerInteraction>().playerRoom;
		if(playerRoom) {
			float air = playerRoom.air;
			if(GameObject.Find("Player").GetComponent<PlayerInteraction>().wearing) {
				air = minAir;
			}
			air = Mathf.Min(1, air/minAir);
			air = air != 0 ? Mathf.Max(0, 1 / (air * 200)) : 0;
			//air = Mathf.Pow(air, 2);
			//print(air);
			float newIntensity = Mathf.Max(0, air * maxIntensity);
			//newIntensity *= newIntensity;

			intensity += (newIntensity - intensity) * fadeSpeed;

			Vignetting vignette = camera.GetComponent<Vignetting>();
			vignette.intensity = intensity;
			vignette.blur = intensity/10;
		}
	}
}
