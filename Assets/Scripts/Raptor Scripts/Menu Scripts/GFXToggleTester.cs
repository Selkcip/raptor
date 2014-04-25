using UnityEngine;
using System.Collections;

public class GFXToggleTester : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(KeyCode.Alpha1)) {
			if(GrapicsToggles.SSRQuality > 0) {
				GrapicsToggles.SSRQuality = -1;
			}
			else {
				GrapicsToggles.SSRQuality = 1;
			}
		}

		if(Input.GetKeyDown(KeyCode.Alpha2)) {
			if(GrapicsToggles.TiltShiftQuality >= 0) {
				GrapicsToggles.TiltShiftQuality = -1;
			}
			else {
				GrapicsToggles.TiltShiftQuality = 1;
			}
		}

		if(Input.GetKeyDown(KeyCode.Alpha3)) {
			if(GrapicsToggles.SSAOQuality >= 0) {
				GrapicsToggles.SSAOQuality = -1;
			}
			else {
				GrapicsToggles.SSAOQuality = 1;
			}
		}

		if(Input.GetKeyDown(KeyCode.Alpha4)) {
			if(GrapicsToggles.BloomQuality >= 0) {
				GrapicsToggles.BloomQuality = -1;
			}
			else {
				GrapicsToggles.BloomQuality = 1;
			}
		}

		if(Input.GetKeyDown(KeyCode.Alpha5)) {
			if(GrapicsToggles.AAQuality >= 0) {
				GrapicsToggles.AAQuality = -1;
			}
			else {
				GrapicsToggles.AAQuality = 0;
			}
		}

		if(Input.GetKeyDown(KeyCode.Alpha6)) {
			if(GrapicsToggles.GlowQuality >= 0) {
				GrapicsToggles.GlowQuality = -1;
			}
			else {
				GrapicsToggles.GlowQuality = 1;
			}
		}
	}
}
