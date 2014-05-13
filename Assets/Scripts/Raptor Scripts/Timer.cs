using UnityEngine;
using System.Collections;

public class Timer : MonoBehaviour {

	public static float displayTime;//Displayed on HUD
	
	//Stealth timer
	public static float sTime;
	public static bool inStealth;

	//police timer
	public static float pTime; //time in seconds before police come
	public static float maxPTime = 180; //time in seconds before police come
	const float pAdjust = 20000f;	//cap on notoriety's effect on the timer
	public static bool policeArrived;
	
	// Use this for initialization
	void Start () {
		sTime = RaptorInteraction.stealthTime;
		pTime = maxPTime - 170 * Mathf.Min(RaptorInteraction.notoriety / pAdjust, 1);
		inStealth = true;
		policeArrived = false;

	}
	
	// Update is called once per frame
	void Update () {
		if(Mathf.Floor(sTime) > 0 && inStealth) {
			sTime -= Time.deltaTime;
			displayTime = sTime;
		}
		else if(Mathf.Floor(sTime) <= 0 || !inStealth) { //Police are coming
			Alarm.ActivateAlarms();
			inStealth = false;
			//turn off the ship shader
			pTime = Mathf.Max(0, pTime - Time.deltaTime);
			if(Mathf.Floor(pTime) > 0) {
				displayTime = pTime;
			}
			else if(Mathf.Floor(pTime) <= 0) {
				policeArrived = true;
			}
		}
	}

	public static void Reset(){
		sTime = RaptorInteraction.stealthTime;
		pTime = maxPTime - 170 * Mathf.Min(RaptorInteraction.notoriety / pAdjust, 1);
		print(pTime + "I STARTED");
		inStealth = true;
		policeArrived = false;
	}
}
