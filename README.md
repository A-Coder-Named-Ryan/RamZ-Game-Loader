# GameZ - RAM Disk Launcher for Compressed Games

**Automated 7z extraction to high-speed RAM disk for faster gaming and reduced storage footprint**

![Windows](https://img.shields.io/badge/Platform-Windows-blue) ![7z](https://img.shields.io/badge/Archive-7z-green) ![AIM](https://img.shields.io/badge/Tool-AIM%20Toolkit-orange)

## Overview

**GameZ** is a PowerShell-based launcher that automatically extracts compressed 7z game archives into a temporary RAM disk, launches the game at high speed, and cleans up after you exit. Perfect for gamers with limited SSD/HDD space who want to compress their game library while still enjoying RAM-speed performance.

### Why Use GameZ?
- 🗜️ **Save Disk Space**: Store games as compressed 7z archives (often 20-40% smaller)
- ⚡ **RAM Speed**: Run games from RAM (Via AIM Toolkit) for faster asset streaming after extraction
- 🧹 **Clean Gaming**: No leftover files—temporary RAM disk deleted when you close the game
- 🔄 **Automation**: One-click launch handles extraction, mounting, and cleanup automatically

---

## How It Works

1. **Compress**: Convert your game folder to a 7z archive (`.7z`)
2. **Launch**: GameZ creates a RAM disk via [AIM Toolkit](https://sourceforge.net/projects/aim-toolkit/files/latest/download)
3. **Extract**: Uncompresses the game from 7z into high-speed RAM storage
4. **Play**: Game launches from RAM (faster than HDD/SSD once extracted)
5. **Cleanup**: RAM disk automatically removed when game exits

> **Note:** Initial extraction from 7z to RAM takes time (depending on archive size and CPU), but gameplay runs at RAM speeds, and you save significant disk space by keeping games compressed when not in use.

---

## Requirements

- **Windows 10/11** (PowerShell 5.1+)
- **[AIM Toolkit](https://sourceforge.net/projects/aim-toolkit/files/latest/download)** (Free) - For creating RAM disks
- **[7-Zip](https://www.7-zip.org/)** (Free) - For extracting compressed archives
- **Sufficient RAM**: Equal to or larger than your uncompressed game size

---

## Installation

1. Download `GameZ.ps1`, `config.json` and `Ramz Loader (run this as admin).bat`
2. Ensure AIM Toolkit and 7-Zip are installed
3. Edit `config.json` with your game paths:
   ```json
   {
     "GAMEDISK": "Z:",
     "RAMSIZE": "2G",
     "GAMEARCHIVE": "F:\\Games\\MyGame.7z",
     "EXTRACTPATH": "Z:\\",
     "GAMEEXE": "Z:\\Game.exe",
     "GAMETITLE": "My Game",
     "PROCESSNAME": "Game",
     "AIMLL": "C:\\Program Files\\AIM Toolkit\\aim_ll.exe",
     "SEVENZIPCLI": "C:\\Program Files\\7-Zip\\7z.exe"
   }
4.Then run `Ramz Loader (run this as admin).bat` as administrator (duh)
