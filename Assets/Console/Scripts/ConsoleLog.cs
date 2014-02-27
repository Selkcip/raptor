using UnityEngine;
using System.Collections;

public class ConsoleLog {
    private static ConsoleLog instance;
    public static ConsoleLog Instance {
        get {
            if (instance == null) {
                instance = new ConsoleLog();
            }
            return instance;
        }
    }

	public static void Print(object message) {
		if(instance != null) {
			instance.Log(message.ToString());
		}
	}

    public string log = "";

    public void Log(string message) {
        log += message + "\n";
    }
}
