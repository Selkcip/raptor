using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class FluidVis : MonoBehaviour {

	public int resolution = 10;
	public float fieldSize = 1;
	public float particleSize = 2;
	public string fluidType = "heat";
	public float fluidScale = 0.25f;

	ParticleSystem.Particle[] points;

	// Use this for initialization
	void Start() {
		points = new ParticleSystem.Particle[resolution * resolution * resolution];

		float stepSize = fieldSize / resolution;
		float halfRes = resolution / 2;

		int x, y, z;
		int i = 0;
		for(x = 0; x < resolution; x++) {
			for(y = 0; y < resolution; y++) {
				for(z = 0; z < resolution; z++) {
					Vector3 pos = new Vector3((x - halfRes) * stepSize, (y-halfRes) * stepSize, (z-halfRes) * stepSize);
					points[i].position = pos;
					points[i].color = new Color(x, y, z);
					points[i++].size = 0;
				}
			}
		}
	}

	// Update is called once per frame
	void Update() {
		for(int i = 0; i < points.Length; i++) {
			Vector3 pos = points[i].position;
			//points[i].color = new Color(x, y, z);
			ShipGridFluid heat;
			ShipGrid.GetPosI(transform.position + pos).fluids.TryGetValue(fluidType, out heat);
			if(heat != null) {
				points[i].size = particleSize*Mathf.Floor(heat.level) * fluidScale;
			}
		}
		particleSystem.SetParticles(points, points.Length);
	}
}
