using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameSave : Dictionary<string, string> {

}

public class GameSaver : MonoBehaviour {
	public static GameSave currentSave;

	public static GameSave Open(string saveName) {
		string save = PlayerPrefs.GetString(saveName);
		string[] pairs = save.Split(new char[]{','});
		GameSave values = new GameSave();
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

	public static void Save(string saveName, GameSave save) {
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

	public static void SetValue(string key, string value) {
		currentSave.Remove(key);
		currentSave.Add(key, value);
	}

	public static void SetValue(string key, int value) {
		currentSave.Remove(key);
		currentSave.Add(key, value.ToString());
	}

	public static void SetValue(string key, float value) {
		currentSave.Remove(key);
		currentSave.Add(key, value.ToString());
	}

	public static void SetValue(string key, bool value) {
		currentSave.Remove(key);
		currentSave.Add(key, value.ToString());
	}

	public static void GetValue(string key, out string value) {
		currentSave.TryGetValue(key, out value);
	}

	public static void GetValue(string key, out int value) {
		string stringValue;
		currentSave.TryGetValue(key, out stringValue);
		if(!int.TryParse(stringValue, out value)) {
			value = 0;
		}
	}

	public static void GetValue(string key, out float value) {
		string stringValue;
		currentSave.TryGetValue(key, out stringValue);
		if(!float.TryParse(stringValue, out value)) {
			value = 0;
		}
	}

	public static void GetValue(string key, out bool value) {
		string stringValue;
		currentSave.TryGetValue(key, out stringValue);
		if(!bool.TryParse(stringValue, out value)) {
			value = false;
		}
	}

	public static void LoadGame(string saveName) {
		currentSave = Open(saveName);
		if(currentSave.Count <= 0) {
			CreateGame(saveName);
		}
		float notoriety, map;
		int money;
		string name;
		GetValue("notoriety", out notoriety);
		GetValue("map", out map);
		GetValue("money", out money);
		GetValue("name", out name);

		print(notoriety + " " + map + " " + money + " " + name);

		RaptorInteraction.notoriety = notoriety;
		RaptorInteraction.mapAmountAcquired = map;
		RaptorInteraction.money = money;
		RaptorInteraction.name = name;
	}

	public static void CreateGame(string saveName) {
		SetValue("notoriety", 0f);
		SetValue("money", 0);
		SetValue("map", 0f);
		SetValue("name", "Click to enter name here");
		Save(saveName, currentSave);
	}

	public static void SaveGame(string saveName) {
		SetValue("notoriety", RaptorInteraction.notoriety);
		SetValue("money", RaptorInteraction.money);
		SetValue("map", RaptorInteraction.mapAmountAcquired);
		SetValue("name", RaptorInteraction.name);
		Save(saveName, currentSave);
	}
}
