# Bullet Parry

Working title for a 2D one-bullet parry / heat game built in **Godot 4.7**.

## Pull the repo (other devs)

### 1. Install tools

- [Git](https://git-scm.com/downloads)
- [Godot **4.7**](https://godotengine.org/download) (Standard build is enough; match major.minor with `project.godot`)

### 2. Clone

```bash
git clone https://github.com/Akuvent/bullet-parry-game.git
cd bullet-parry-game
```

If you already have a clone:

```bash
git pull origin master
```

### 3. Open the game project

1. Launch Godot 4.7
2. **Import** → select `bpg-project/project.godot`
3. Open the project and press **F5** (or Play) to run the main scene

Game code lives under `bpg-project/` (`scenes/`, `scripts/`, `autoload/`, etc.).

### 4. Daily workflow

```bash
git pull origin master
# …edit in Godot…
git add .
git commit -m "Short description of what changed"
git push origin master
```

Prefer a feature branch if several people push at once:

```bash
git checkout -b your-name/short-topic
git push -u origin your-name/short-topic
```

Then open a PR on GitHub.

### Notes

- Do **not** commit `.env`, tokens, or local secrets.
- `discord-setup/` is studio Discord tooling and is **not** part of this game repo (ignored / local only).
- After first open, Godot may generate `.godot/` locally — that folder stays ignored.

Need access? Ask a repo admin for write permission on [Akuvent/bullet-parry-game](https://github.com/Akuvent/bullet-parry-game).
