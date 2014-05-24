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
				values.Add(keyValue[0], WWW.UnEscapeURL(keyValue[1]));
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
			saveString += pair.Key + "=" + WWW.EscapeURL(pair.Value);
		}
		PlayerPrefs.SetString(saveName, saveString);
	}

	public static void Delete(string saveName) {
		PlayerPrefs.DeleteKey(saveName);
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

		string name, level;
		float notoriety, map, health, attack, stealth;
		int money;
		int ssrQ, tiltQ, glowQ, aaQ, ssaoQ, bloomQ;
		GetValue("name", out name);
		GetValue("level", out level);
		GetValue("notoriety", out notoriety);
		GetValue("map", out map);
		GetValue("money", out money);
		GetValue("health", out health);
		GetValue("attack", out attack);
		GetValue("stealth", out stealth);

		print(notoriety + ", " + map + ", " + money + ", " + name + ", " + level);

		RaptorInteraction.name = name;
		RaptorInteraction.level = level;
		RaptorInteraction.notoriety = notoriety;
		RaptorInteraction.mapAmountAcquired = map;
		RaptorInteraction.money = money;
		RaptorInteraction.maxHealth = health;
		RaptorInteraction.attack = attack;
		RaptorInteraction.stealthTime = stealth;

		GetValue("ssrQ", out ssrQ);
		GetValue("tiltQ", out tiltQ);
		GetValue("glowQ", out glowQ);
		GetValue("aaQ", out aaQ);
		GetValue("ssaoQ", out ssaoQ);
		GetValue("bloomQ", out bloomQ);

		GrapicsToggles.SSRQuality = ssrQ;
		GrapicsToggles.TiltShiftQuality = tiltQ;
		GrapicsToggles.GlowQuality = glowQ;
		GrapicsToggles.AAQuality = aaQ;
		GrapicsToggles.SSAOQuality = ssaoQ;
		GrapicsToggles.BloomQuality = bloomQ;

		UpgradeSpawner.upgrades.Clear();
		string purchasesString;
		GetValue("purchases", out purchasesString);
		if(purchasesString != null && purchasesString != "") {
			print(purchasesString);
			string[] consumables = purchasesString.Split(new char[] { '+' });
			foreach(string conString in consumables) {
				UpgradeSpawner.upgrades.Add(Resources.Load<CollectibleUpgrade>("Prefabs/Upgrades/" + conString));
				UpgradeSpawner.upgrades[UpgradeSpawner.upgrades.Count - 1].name = conString;
			}
		}

		PlayerShipController.consumables.Clear();
		string consumablesString;
		GetValue("consumables", out consumablesString);
		if(consumablesString != null && consumablesString != "") {
			print(consumablesString);
			string[] consumables = consumablesString.Split(new char[]{'+'});
			foreach(string conString in consumables) {
				string[] consumable = conString.Split(new char[] { ':' });
				if(consumable.Length > 1) {
					int consumCount = 0;
					int.TryParse(consumable[1], out consumCount);
					UpgradeCount count = new UpgradeCount(Resources.Load<ConsumableUpgrade>("Prefabs/Upgrades/" + consumable[0]));
					count.count = consumCount;
					PlayerShipController.consumables.Add(count);
				}
			}
		}
	}

	public static void CreateGame(string saveName) {
		print("creating save");
		SetValue("name", "Click to enter name here");
		SetValue("level", RaptorInteraction.defaultLevel);
		SetValue("notoriety", 0f);
		SetValue("money", 0);
		SetValue("map", 0f);
		SetValue("health", RaptorInteraction.defaultMaxHealth);
		SetValue("attack", RaptorInteraction.defaultAttack);
		SetValue("stealth", RaptorInteraction.defaultStealthTime);

		SetValue("ssrQ", -1);
		SetValue("tiltQ", -1);
		SetValue("glowQ", 1);
		SetValue("aaQ", -1);
		SetValue("ssaoQ", -1);
		SetValue("bloomQ", -1);

		Save(saveName, currentSave);
	}

	public static void SaveGame(string saveName) {
		SetValue("name", RaptorInteraction.name);
		SetValue("level", RaptorInteraction.level);
		SetValue("notoriety", RaptorInteraction.notoriety);
		SetValue("money", RaptorInteraction.money);
		SetValue("map", RaptorInteraction.mapAmountAcquired);
		SetValue("health", RaptorInteraction.maxHealth);
		SetValue("attack", RaptorInteraction.attack);
		SetValue("stealth", RaptorInteraction.stealthTime);

		SetValue("ssrQ", GrapicsToggles.SSRQuality);
		SetValue("tiltQ", GrapicsToggles.TiltShiftQuality);
		SetValue("glowQ", GrapicsToggles.GlowQuality);
		SetValue("aaQ", GrapicsToggles.AAQuality);
		SetValue("ssaoQ", GrapicsToggles.SSAOQuality);
		SetValue("bloomQ", GrapicsToggles.BloomQuality);

		string purchases = "";
		bool first = true;
		foreach(CollectibleUpgrade upgrade in UpgradeSpawner.upgrades) {
			if(first) {
				first = false;
			}
			else {
				purchases += "+";
			}
			purchases += upgrade.name;
		}
		//print(consumables);
		SetValue("purchases", purchases);

		string consumables = "";
		first = true;
		foreach(UpgradeCount count in PlayerShipController.consumables) {
			if(first){
				first = false;
			}else{
				consumables += "+";
			}
			consumables += count.upgrade.name + ":" + count.count;
		}
		//print(consumables);
		SetValue("consumables", consumables);

		Save(saveName, currentSave);
	}
}
