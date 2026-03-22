# Contributing to CyberForge

Thank you for your interest in contributing! 🎉

## How to Contribute

### Reporting Bugs
1. Check if the issue already exists in [Issues](https://github.com/Dexel-Software-Solutions/cyberforge/issues)
2. Open a new issue with:
   - Your OS and bash version (`bash --version`)
   - The exact command you ran
   - The error output

### Suggesting Features
Open an issue with the label `enhancement` and describe:
- What problem the new module/feature solves
- Example usage (`./cyberforge.sh newmodule example.com`)

### Submitting Code

```bash
# 1. Fork the repo on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/cyberforge.git
cd cyberforge

# 3. Create a feature branch
git checkout -b feat/your-module-name

# 4. Make your changes
# Follow the module template in docs/USAGE.md

# 5. Test your code
bash -n cyberforge.sh          # syntax check
./cyberforge.sh your-module    # functional test

# 6. Commit (follow Conventional Commits)
git commit -m "feat: add your-module for XYZ purpose"

# 7. Push and open a PR
git push origin feat/your-module-name
```

## Code Style Guidelines

- Use `local` for all function variables
- Always validate required arguments at the top of each function
- Call `log_audit` at start and end of each module
- Use provided helper functions (`ok`, `warn`, `err`, `found`, etc.)
- Add entry to `_help()` and the `main()` case statement
- Update `README.md` and `CHANGELOG.md`
- Keep modules self-contained — no global state changes

## Commit Message Format

```
type: short description

Types:
  feat     → New module or feature
  fix      → Bug fix
  docs     → Documentation only
  refactor → Code restructure (no feature change)
  perf     → Performance improvement
  test     → Test additions
  chore    → Build/tooling changes
```

## Code of Conduct

- Be respectful and constructive
- This tool is for **educational and authorized use only**
- Do not submit modules designed for offensive/illegal use

---

**Developer:** Demiyan Dissanayake
