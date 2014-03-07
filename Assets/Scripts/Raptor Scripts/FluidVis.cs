using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class FluidVis : MonoBehaviour {

	public int resolution = 10;
	public float fieldSize = 1;
	public float particleSize = 2;
	public string fluidType = "heat";
	public float fluidScale = 0.25f;
	public float maxHeat = 10;
	public float viewDis = 20;
	public int updateStepSize = 10;

	ParticleSystem.Particle[] points;

	Mesh mesh;
	Vector3[] vertices;
	Color[] colors;

	// Use this for initialization
	void Start() {
		mesh = GetComponent<MeshFilter>().mesh;
		vertices = mesh.vertices;
		colors = new Color[vertices.Length];

		/*for(int i = 0; i < vertices.Length; i++) {
			colors[i] = Color.Lerp(Color.red, Color.green, vertices[i].z);
		}*/

		mesh.colors = colors;

		/*points = new ParticleSystem.Particle[resolution * resolution * resolution];

		float stepSize = fieldSize / resolution;
		float halfRes = resolution / 2;

		int x, y, z;
		int i = 0;*/
		/*for(x = 0; x < resolution; x++) {
			for(y = 0; y < resolution; y++) {
				for(z = 0; z < resolution; z++) {
					Vector3 pos = new Vector3((x - halfRes) * stepSize, (y-halfRes) * stepSize, (z-halfRes) * stepSize);
					points[i].position = pos;
					points[i].color = new Color(1,1,1);
					points[i++].size = 0;
				}
			}
		}*/
	}

	int startIndex = 0;
	// Update is called once per frame
	void Update() {
		for(int i = startIndex; i < vertices.Length; i += updateStepSize) {
			Vector3 pos = transform.TransformPoint(vertices[i]);
			RaycastHit hit;
			Vector3 dir = (pos - Camera.main.transform.position).normalized;
			if(!Physics.Raycast(pos, dir, out hit, viewDis)) {
				hit.distance = viewDis;
				hit.point = pos + dir * viewDis;
			}
			ShipGridFluid heat;
			ShipGrid.GetPosI(hit.point).fluids.TryGetValue(fluidType, out heat);
			if(heat != null) {
				//points[i].size = particleSize * Mathf.Floor(heat.level) * fluidScale;
				colors[i] = Color.Lerp(colors[i], Color.Lerp(Color.black, Color.red, heat.level / maxHeat), 0.5f);
			}
			else {
				colors[i] = colors[i] = Color.Lerp(colors[i], Color.black, 0.5f);
			}
			//colors[i] = Color.Lerp(Color.red, Color.green, hit.distance/viewDis);
		}
		mesh.colors = colors;

		startIndex = (startIndex + 1) % updateStepSize;

		/*particleSystem.GetParticles(points);
		for(int i = 0; i < points.Length; i++) {
			Vector3 pos = points[i].position;
			//points[i].color = new Color(x, y, z);
			ShipGridFluid heat;
			ShipGrid.GetPosI(transform.TransformPoint(pos)).fluids.TryGetValue(fluidType, out heat);
			if(heat != null) {
				points[i].size = particleSize*Mathf.Floor(heat.level) * fluidScale;
			}
		}
		particleSystem.SetParticles(points, points.Length);*/
	}
}
