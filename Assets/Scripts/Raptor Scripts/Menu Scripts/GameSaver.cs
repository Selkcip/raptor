using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameSaver : MonoBehaviour {
	public static Dictionary<string, string> OpenSave(string saveName) {
		string save = PlayerPrefs.GetString(saveName);
		string[] pairs = save.Split(new char[]{','});
		Dictionary<string, string> values = new Dictionary<string, string>();
		foreach(string pair in pairs) {
			string[] keyValue = pair.Split(new char[] { '=' });
			if(keyValue.Length > 1) {
				values.Add(keyValue[0], keyValue[1]);
			}
			else {
				print(saveName + " save might be corrupt.");
			}
		}
		return values;
	}

	public static void CloseSave(string saveName, Dictionary<string, string> save){
		string saveString = "";
		bool first = true;
		foreach(KeyValuePair<string, string> pair in save) {
			if(first) {
				first = false;
			}
			else {
				saveString += ",";
			}
			saveString += pair.Key + "=" + pair.Value;
		}
		PlayerPrefs.SetString(saveName, saveString);
	}

	public static void SaveValue(Dictionary<string, string> save, string key, string value) {
		save.Remove(key);
		save.Add(key, value);
	}

	public static void SaveValue(Dictionary<string, string> save, string key, int value) {
		save.Remove(key);
		save.Add(key, value.ToString());
	}

	public static void SaveValue(Dictionary<string, string> save, string key, float value) {
		save.Remove(key);
		save.Add(key, value.ToString());
	}

	public static void SaveValue(Dictionary<string, string> save, string key, bool value) {
		save.Remove(key);
		save.Add(key, value.ToString());
	}

	public static void getValue(Dictionary<string, string> save, string key, out string value) {
		save.TryGetValue(key, out value);
	}

	public static void getValue(Dictionary<string, string> save, string key, out int value) {
		string stringValue;
		save.TryGetValue(key, out stringValue);
		if(!int.TryParse(stringValue, out value)) {
			value = 0;
		}
	}

	public static void getValue(Dictionary<string, string> save, string key, out float value) {
		string stringValue;
		save.TryGetValue(key, out stringValue);
		if(!float.TryParse(stringValue, out value)) {
			value = 0;
		}
	}

	public static void getValue(Dictionary<string, string> save, string key, out bool value) {
		string stringValue;
		save.TryGetValue(key, out stringValue);
		if(!bool.TryParse(stringValue, out value)) {
			value = false;
		}
	}
}
