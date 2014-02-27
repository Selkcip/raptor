using UnityEngine;
using System.Collections;

public class PipePressure : Incident {

	//maybe it would be good to make this an ExplosionPipe, so that we can't have sets of arbitrary incidents...
	//...NAH.
	
	public Incident[] pipes;

	private float pressure = 0;
	public float maxPressure;

	// Use this for initialization
	void Start () {
	
	}
	
	public override void Activate() {

		foreach(Incident pipe in pipes) {
			pipe.Activate();
		}
	}

	// Update is called once per frame
	public override void Update () {

		int sealedPipes = 0;

		foreach(Incident pipe in pipes) {
			if(pipe.isSolved)
				sealedPipes++;
			//Debug.Log("Solved!");
		}

		if(sealedPipes == pipes.Length) {
			isSolved = true;
		} else {
			//we may want to make this not linear
			pressure += Time.deltaTime * sealedPipes;
			//Debug.Log("Pressure: " + pressure);

			if(pressure >= maxPressure) {
				pressure = 0;
				foreach(Incident pipe in pipes) {
						pipe.Reset();
				}
			}
		}
	}


	public override void Reset() {
		Activate();
		pressure = 0;
		isSolved = false;
	}
}
