using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MaterialColorizer : MonoBehaviour {
	public List<Material> mats = new List<Material>();
	public List<Color> colors = new List<Color>();

	// Use this for initialization
	void Start () {
		foreach(Material mat in mats) {
			mat.color = colors[Random.Range(0, colors.Count)];
		}
	}
}
