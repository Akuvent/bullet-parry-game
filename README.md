# Bullet Parry

Working title for a 2D one-bullet parry / heat game built in **Godot 4.7**.

## Pull the repo (other devs)

### 1. Install tools

- [Git for Windows](https://git-scm.com/download/win) — run the installer, leave **“Git from the command line and also from 3rd-party software”** checked, then **close and reopen** PowerShell
- [Godot **4.7**](https://godotengine.org/download) (Standard build is enough; match major.minor with `project.godot`)

Check Git works:

```powershell
git --version
```

If you see `git is not recognized`, Git isn’t installed or PATH wasn’t updated — reinstall Git, reopen the terminal, try again.

### 2. Clone

```powershell
cd $HOME
git clone https://github.com/Akuvent/bullet-parry-game.git
cd bullet-parry-game
```

If you already have a clone:

```powershell
git pull origin master
```

### 3. Open the game project

1. Launch Godot 4.7
2. **Import** → select `bpg-project/project.godot`
3. Open the project and press **F5** (or Play) to run the main scene

Game code lives under `bpg-project/` (`scenes/`, `scripts/`, `autoload/`, etc.).

### 4. Daily workflow

```powershell
git pull origin master
# …edit in Godot…
git add .
git commit -m "Short description of what changed"
git push origin master
```

Prefer a feature branch if several people push at once:

```powershell
git checkout -b your-name/short-topic
git push -u origin your-name/short-topic
```

Then open a PR on GitHub.

### Notes

- Do **not** commit `.env`, tokens, or local secrets.
- `discord-setup/` is studio Discord tooling and is **not** part of this game repo (ignored / local only).
- After first open, Godot may generate `.godot/` locally — that folder stays ignored.

Need access? Ask a repo admin for write permission on [Akuvent/bullet-parry-game](https://github.com/Akuvent/bullet-parry-game).
