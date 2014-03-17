using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class FluidVis : MonoBehaviour {

	public int resolution = 10;
	//public float fieldSize = 1;
	//public float particleSize = 2;
	public string fluidType = "heat";
	public float fluidScale = 0.25f;
	public float maxHeat = 10;
	public float viewDis = 20;
	public int updateStepSize = 10;
	public bool smooth = false;

	private int currentFluid = 0;

	ParticleSystem.Particle[] points;

	int size;
	Color[] pixels;
	Texture2D fluidTex;

	// Use this for initialization
	void Start() {
		ShipGrid.fluids.Add(fluidType);

		fluidTex = new Texture2D(resolution, resolution);
		fluidTex.wrapMode = TextureWrapMode.Clamp;
		if(!smooth) {
			fluidTex.filterMode = FilterMode.Point;
		}
		pixels = fluidTex.GetPixels();
		//print(pixels.Length);
	}

	int startIndex = 0;
	// Update is called once per frame
	void Update() {
		float scroll = Input.GetAxis("Mouse ScrollWheel");
		if(scroll > 0){
			currentFluid++;
		}else if(scroll < 0){
			currentFluid--;
		}
		currentFluid += ShipGrid.fluids.Count;
		currentFluid %= Mathf.Max(1, ShipGrid.fluids.Count);
		currentFluid = Mathf.Min(currentFluid, ShipGrid.fluids.Count - 1);

		fluidType = ShipGrid.fluids[currentFluid];

		float posStep = 1.0f / resolution;
		//for(int x = 0; x < resolution; x++) {
			//for(int y = 0; y < resolution; y++) {
		for(int i = startIndex; i < pixels.Length; i += updateStepSize) {
			int x = (i % resolution);
			int y = (i / resolution);
				Ray ray = Camera.main.ViewportPointToRay(new Vector3(x * posStep, y * posStep, 0));
				RaycastHit hit;
				if(!Physics.Raycast(ray.origin, ray.direction, out hit, viewDis)) {
					hit.distance = viewDis;
					hit.point = ray.origin + ray.direction * viewDis;
				}
				float stepSize = 1.0f;
				int steps = (int)Mathf.Floor(hit.distance / stepSize);
				float heatSum = 0;
				ShipGridFluid heat;
				for(int j = 0; j < steps; j++) {
					ShipGrid.GetPosI(ray.origin + ray.direction * (j * stepSize)).fluids.TryGetValue(fluidType, out heat);
					if(heat != null) {
						heatSum += heat.level;
					}
					else {
						//colors[i] = colors[i] = Color.Lerp(colors[i], Color.black, 0.5f);
					}
				}
				ShipGrid.GetPosI(hit.point).fluids.TryGetValue(fluidType, out heat);
				if(heat != null) {
					heatSum += heat.level;
				}
				heatSum /= steps + 1;
				pixels[i] = Color.Lerp(pixels[i], Color.Lerp(Color.black, Color.red, Mathf.Pow(heatSum / maxHeat, 2)), 0.5f);
				//colors[i] = Color.Lerp(colors[i], Color.Lerp(Color.black, Color.red, Mathf.Pow(heatSum / maxHeat, 2)), 0.5f);
				//int x = i % size;
				//int y = i / size;
				//fluidTex.SetPixel(x, y, color);
			//}
		}
		startIndex = (startIndex + 1) % updateStepSize;

		fluidTex.SetPixels(pixels);
		fluidTex.Apply();
		EdgeDetectEffectNormals.fluidTex = fluidTex;
	}
}
