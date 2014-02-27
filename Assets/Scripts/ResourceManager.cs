using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ResourceManager : MonoBehaviour {

	public int scrap = 100;
	public int fuel;
	public Dictionary<string, int> scrapValues;

	private static ResourceManager s_instance;

	public static ResourceManager instance {
		get {
			if(s_instance == null) {
				GameObject go = new GameObject("ResourceManager");
				s_instance = go.AddComponent<ResourceManager>();
			}
			return s_instance;
		}
	}

	public static void AddScrap(int _scrap) {
		instance.scrap += _scrap;
	}

	// Use this for initialization
	void Awake () {
		scrapValues = new Dictionary<string, int>();
		
		scrapValues.Add("Wrench", 1);
		scrapValues.Add("Gas Mask", 5);
		scrapValues.Add("Fire Extinguisher", 10);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
