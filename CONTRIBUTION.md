
# 🤝 `CONTRIBUTING.md`

# Contributing Guide

Thanks for your interest in contributing 🎉

This project values **clarity**, **safety**, and **maintainability**.

---

## 🧠 Philosophy

- Explicit dependencies > magic
- Safe re-runs > one-shot scripts
- Explainability > silent behavior

---

## 🧩 Adding a New Module

1. Create a new file in `modules/`
   ```bash
   modules/mytool.sh
    ````

2. Register the module:

   ```bash
   register "mytool" "dependency1 dependency2" \
     "command -v mytool >/dev/null" \
     "brew install mytool" \
     "Short description of mytool"
   ```

3. Test:

   ```bash
   ./setup.sh --dry-run mytool
   ./setup.sh --explain mytool
   ```

## 🧪 Testing Checklist

* [ ] `--dry-run` works
* [ ] Dependencies respected
* [ ] Re-running is safe
* [ ] No silent failures
* [ ] Works on macOS / Linux (if applicable)

---

## 📚 Documentation

If you add:

* A new module → update README
* A new feature → add example screenshot
* A new flag → document usage

---

## 🧼 Code Style

* Bash strict mode (`set -Eeuo pipefail`)
* Quote variables
* Avoid global side effects
* Keep modules small and focused

---

## 🚫 What Not to Do

* Do not install tools without declaring dependencies
* Do not modify user files without backups
* Do not add silent behavior

---

## 💬 Questions

Open an issue or discussion — happy to help!
