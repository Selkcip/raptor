using UnityEngine;
using System.Collections;

public class ConsoleCommandRouter : MonoBehaviour {
    void Start() {
        ConsoleCommandsRepository repo = ConsoleCommandsRepository.Instance;
        repo.RegisterCommand("restart", Restart);
        repo.RegisterCommand("mouse", Mouse);
        repo.RegisterCommand("quit", Quit);

		//options stuff
		repo.RegisterCommand("resolution", Resolution);
		repo.RegisterCommand("fullscreen", FullScreen);
		repo.RegisterCommand("headbob", HeadBob);
		repo.RegisterCommand("invertaxis", InvertAxis);
		repo.RegisterCommand("bindjump", KeyBindJump);
	}

	public string Resolution(params string[] args) {
		Options.Resolution(int.Parse(args[0]), int.Parse(args[1]));
		return ("Resolution set to " + args[0] + "x" + args[1]);
	}

	public string FullScreen(params string[] args) {
		Options.FullScreen(bool.Parse(args[0]));
		return ("FullScreen: " + args[0]);
	}

	public string HeadBob(params string[] args) {
		Options.HeadBob(bool.Parse(args[0]));
		return ("HeadBob: " + args[0]);
	}

	public string InvertAxis(params string[] args) {
		Options.InvertAxis(bool.Parse(args[0]));
		return ("Axis inverted");
	}

	public string KeyBindJump(params string[] args) {
		Options.KeyMapping("Jump", KeyCode.C);
		return ("Jump changed");
	}

	//the other stuff
    public string Restart(params string[] args) {
        Application.LoadLevel(0);
        return "Reloaded level.";
    }

    public string Mouse(params string[] args) {
        string state = args[0];
        if(state == "lock") {
            Screen.lockCursor = true;
            return "Mouse locked.";
        }
        else if(state == "unlock") {
            Screen.lockCursor = false;
            return "Mouse unlocked.";
        }
        else {
            return "use mouse lock or mouse unlock.";
        }
    }

    public string Quit(params string[] args) {
        Application.Quit();
        return "Application quitting..";
    }
}