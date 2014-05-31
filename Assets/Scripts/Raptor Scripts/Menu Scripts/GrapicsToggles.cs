using UnityEngine;
using System.Collections;

public class GrapicsToggles : MonoBehaviour {

	static int	_SSRQuality = -1;
	static int	_TiltShiftQuality = 1;
	static int _GlowQuality = 1;
	static int _AAQuality = 4;
	static int _SSAOQuality = 1;
	static int _BloomQuality = 2;

	public bool overrideDefaults = false;
	public int SSRQualityOverride = 1;
	public int TiltShitQualityOverride = 1;
	public int GlowQualityOverride = 1;
	public int AAQualityOverride = 4;
	public int SSAOQualityOverride = 1;
	public int BloomQualityOverride = 2;

	void Start() {
		if(overrideDefaults) {
			SSRQuality = SSRQualityOverride;
			TiltShiftQuality = TiltShitQualityOverride;
			GlowQuality = GlowQualityOverride;
			AAQuality = AAQualityOverride;
			SSRQuality = SSRQualityOverride;
			BloomQuality = BloomQualityOverride;
		}
	}

	public static int SSRQuality {
		get {
			return _SSRQuality;
		}
		set {
			_SSRQuality = value;
		}
	}

	public static int TiltShiftQuality {
		get {
			return _TiltShiftQuality;
		}
		set {
			_TiltShiftQuality = value;
		}
	}

	public static int GlowQuality {
		get {
			return _GlowQuality;
		}
		set {
			_GlowQuality = value;
		}
	}

	public static int AAQuality {
		get {
			return _AAQuality;
		}
		set {
			_AAQuality = value;
		}
	}

	public static int SSAOQuality {
		get {
			return _SSAOQuality;
		}
		set {
			_SSAOQuality = value;
		}
	}

	public static int BloomQuality {
		get {
			return _BloomQuality;
		}
		set {
			_BloomQuality = value;
		}
	}

	void Update() {
		if(Camera.main != null) {
			ScreenSpaceReflections ssr = Camera.main.GetComponent<ScreenSpaceReflections>();
			if(ssr != null) {
				if(_SSRQuality < 1) {
					ssr.enabled = false;
				}
				else {
					ssr.enabled = true;
					ssr.m_Downsampling = _SSRQuality;
				}
			}

			TiltShiftHdr tilt = Camera.main.GetComponent<TiltShiftHdr>();
			if(tilt != null) {
				if(_TiltShiftQuality < 0) {
					tilt.enabled = false;
				}
				else {
					tilt.enabled = true;
					tilt.quality = (TiltShiftHdr.TiltShiftQuality)_TiltShiftQuality;
				}
			}

			Glow11.Glow11 glow = Camera.main.GetComponent<Glow11.Glow11>();
			if(glow != null) {
				if(_GlowQuality < 1) {
					glow.enabled = false;
				}
				else {
					if(!glow.enabled){
						glow.enabled = true;
					}
					Glow11.Resolution res = (Glow11.Resolution)_GlowQuality;
					if(glow.rerenderResolution != res) {
						glow.rerenderResolution = res;
					}
				}
			}

			AntialiasingAsPostEffect aa = Camera.main.GetComponent<AntialiasingAsPostEffect>();
			if(aa != null) {
				if(_AAQuality < 0) {
					aa.enabled = false;
				}
				else {
					aa.enabled = true;
				}
			}

			SSAOEffect ssao = Camera.main.GetComponent<SSAOEffect>();
			if(ssao != null) {
				if(_SSAOQuality < 0) {
					ssao.enabled = false;
				}
				else {
					ssao.enabled = true;
					ssao.m_SampleCount = (SSAOEffect.SSAOSamples)_SSAOQuality;
				}
			}

			Bloom bloom = Camera.main.GetComponent<Bloom>();
			if(bloom != null) {
				if(_BloomQuality < 0) {
					bloom.enabled = false;
				}
				else {
					bloom.enabled = true;
					bloom.quality = (Bloom.BloomQuality)_BloomQuality;
				}
			}
		}
	}
}
