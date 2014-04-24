using UnityEngine;
using System.Collections;

public class GrapicsToggles : MonoBehaviour {

	public static int SSRQuality {
		get {
			ScreenSpaceReflections effect = Camera.main.GetComponent<ScreenSpaceReflections>();
			if(effect != null && effect.enabled) {
				return effect.m_Downsampling;
			}
			return -1;
		}
		set {
			ScreenSpaceReflections effect = Camera.main.GetComponent<ScreenSpaceReflections>();
			if(effect != null) {
				if(value > 0) {
					effect.enabled = true;
					effect.m_Downsampling = value;
				}
				else {
					effect.enabled = false;
				}
			}
		}
	}

	public static int TiltShiftQuality {
		get {
			TiltShiftHdr effect = Camera.main.GetComponent<TiltShiftHdr>();
			if(effect != null && effect.enabled) {
				return (int)effect.quality;
			}
			return -1;
		}
		set {
			TiltShiftHdr effect = Camera.main.GetComponent<TiltShiftHdr>();
			if(effect != null) {
				if(value >= 0) {
					effect.enabled = true;
					effect.quality = (TiltShiftHdr.TiltShiftQuality)value;
				}
				else {
					effect.enabled = false;
				}
			}
		}
	}

	public static int GlowQuality {
		get {
			Glow11.Glow11 effect = Camera.main.GetComponent<Glow11.Glow11>();
			if(effect != null && effect.enabled) {
				return (int)effect.rerenderResolution;
			}
			return -1;
		}
		set {
			Glow11.Glow11 effect = Camera.main.GetComponent<Glow11.Glow11>();
			if(effect != null) {
				if(value >= 0) {
					effect.enabled = true;
					effect.rerenderResolution = (Glow11.Resolution)value;
				}
				else {
					effect.enabled = false;
				}
			}
		}
	}

	public static int AAQuality {
		get {
			AntialiasingAsPostEffect effect = Camera.main.GetComponent<AntialiasingAsPostEffect>();
			if(effect != null && effect.enabled) {
				return (int)effect.mode;
			}
			return -1;
		}
		set {
			AntialiasingAsPostEffect effect = Camera.main.GetComponent<AntialiasingAsPostEffect>();
			if(effect != null) {
				if(value >= 0) {
					effect.enabled = true;
					effect.mode = (AAMode)value;
				}
				else {
					effect.enabled = false;
				}
			}
		}
	}

	public static int SSAOQuality {
		get {
			SSAOEffect effect = Camera.main.GetComponent<SSAOEffect>();
			if(effect != null && effect.enabled) {
				return (int)effect.m_SampleCount;
			}
			return -1;
		}
		set {
			SSAOEffect effect = Camera.main.GetComponent<SSAOEffect>();
			if(effect != null) {
				if(value >= 0) {
					effect.enabled = true;
					effect.m_SampleCount = (SSAOEffect.SSAOSamples)value;
				}
				else {
					effect.enabled = false;
				}
			}
		}
	}

	public static int BloomQuality {
		get {
			Bloom effect = Camera.main.GetComponent<Bloom>();
			if(effect != null && effect.enabled) {
				return (int)effect.quality;
			}
			return -1;
		}
		set {
			Bloom effect = Camera.main.GetComponent<Bloom>();
			if(effect != null) {
				if(value >= 0) {
					effect.enabled = true;
					effect.quality = (Bloom.BloomQuality)value;
				}
				else {
					effect.enabled = false;
				}
			}
		}
	}

	/*static bool enableTiltShift {
		get {
			TiltShiftHdr effect = Camera.main.GetComponent<TiltShiftHdr>();
			if(effect != null) {
				return effect.enabled;
			}
			return false;
		}
		set {
			TiltShiftHdr effect = Camera.main.GetComponent<TiltShiftHdr>();
			if(effect != null) {
				effect.enabled = value;
			}
		}
	}

	static void ToggleSSR(bool enabled, float quality = 1) {
		ScreenSpaceReflections effect = Camera.main.GetComponent<ScreenSpaceReflections>();
		effect.m_Downsampling = (int)Mathf.Lerp(4, 1, quality);
		if(effect != null) {
			effect.enabled = enabled;
		}
	}

	static void ToggleTiltShift(bool enabled, TiltShiftHdr.TiltShiftQuality quality = TiltShiftHdr.TiltShiftQuality.Normal) {
		TiltShiftHdr effect = Camera.main.GetComponent<TiltShiftHdr>();
		effect.quality = quality;
		if(effect != null) {
			effect.enabled = enabled;
		}
	}

	static void ToggleGlow(bool enabled, Glow11.Resolution quality = Glow11.Resolution.Full) {
		Glow11.Glow11 effect = Camera.main.GetComponent<Glow11.Glow11>();
		effect.rerenderResolution = quality;
		if(effect != null) {
			effect.enabled = enabled;
		}
	}

	static void ToggleAA(bool enabled, float quality = 1) {
		AntialiasingAsPostEffect effect = Camera.main.GetComponent<AntialiasingAsPostEffect>();
		if(effect != null) {
			effect.enabled = enabled;
		}
	}

	static void ToggleSSAO(bool enabled, SSAOEffect.SSAOSamples quality = SSAOEffect.SSAOSamples.Medium) {
		SSAOEffect effect = Camera.main.GetComponent<SSAOEffect>();
		effect.m_SampleCount = quality;
		if(effect != null) {
			effect.enabled = enabled;
		}
	}

	static void ToggleBloom(bool enabled, Bloom.BloomQuality quality = Bloom.BloomQuality.High) {
		Bloom effect = Camera.main.GetComponent<Bloom>();
		effect.quality = quality;
		if(effect != null) {
			effect.enabled = enabled;
		}
	}*/
}
