# ComfyUI Intel Arc & Intel Ultra Core iGPU Clean Install (Windows, venv, XPU)

This repository provides **fully automated batch scripts** to install and launch ComfyUI on Windows, optimized for both Intel Arc GPUs **and** Intel Ultra Core iGPUs (Meteor Lake/Core Ultra series) using the XPU backend.

You get:
- The latest ComfyUI and official frontend
- An isolated Python virtual environment (venv)
- Intel Arc/XPU-optimized PyTorch
- No need to manually patch device code
- Optional batch to install ComfyUI Manager

---

## Features

- **No dependency conflicts:** ComfyUI runs in its own venv, separate from AI Playground, Pinokio, or other tools.
- **Always up-to-date:** Scripts fetch the latest ComfyUI and frontend versions.
- **Automatic XPU support:** PyTorch XPU is installed and used by default.
- **No manual patching:** No need to edit `model_management.py` for device selection.
- **ComfyUI Manager install script included.**

---

## Compatibility

**This setup is tested and confirmed to work with:**

| GPU Type                      | Supported | Notes                                                                                      |
|-------------------------------|-----------|--------------------------------------------------------------------------------------------|
| Intel Arc (A-Series)          | ✅ Yes    | Full support with PyTorch XPU. (e.g. Arc A770, A750, A580, A380, A310)                     |
| Intel Arc Pro (Workstation)   | ✅ Yes    | Same as above.                                                                             |
| Intel Ultra Core iGPU         | ✅ Yes    | Supported via PyTorch XPU (e.g. Intel Core Ultra 5/7/9 Meteor Lake NPU/iGPU).              |
| Intel Iris Xe (integrated)    | ⚠️ Partial| Experimental, limited or no support in current PyTorch XPU builds. May fallback to CPU.     |
| Intel UHD (older iGPU)        | ❌ No     | Not supported for AI acceleration, CPU-only fallback.                                      |
| NVIDIA (GTX/RTX)              | ✅ Yes    | Use the official CUDA/Windows portable or conda install.                                   |
| AMD Radeon (RDNA/ROCm)        | ⚠️ Partial| ROCm support is limited and not recommended for most users.                                 |
| CPU only                      | ✅ Yes    | Works, but extremely slow for image/video generation.                                      |

**Intel Ultra Core iGPU Support:**  
- Intel Ultra Core (Meteor Lake, “Core Ultra 5/7/9” etc.) iGPUs are supported with this guide, as they use the same PyTorch XPU backend as Intel Arc discrete GPUs.
- You do **not** need a discrete Arc GPU; the integrated GPU in Intel Ultra Core CPUs will be used if present and drivers are up to date.
- Performance will be lower than Arc A-series, but you get full node-based ComfyUI functionality.

**Intel Iris Xe and UHD Graphics:**  
- Intel Iris Xe iGPU support is experimental. Some features may not work or may fall back to CPU.
- Intel UHD Graphics (older iGPUs) are **not supported** for AI acceleration, and ComfyUI will use CPU only.

---

## Prerequisites

- **Windows 10/11**
- **Intel Arc GPU** (A-series, Arc Pro) or **Intel Ultra Core iGPU** (Meteor Lake/Core Ultra series)
- **Python 3.10 or 3.11** ([download here](https://www.python.org/downloads/))
- **Git for Windows** ([download here](https://git-scm.com/download/win))
- At least **50GB free disk space** (for models, nodes, outputs, etc.)
- Latest Intel Graphics drivers

---

## Usage

### 1. Preparation

- **Backup** your `models`, `custom_nodes`, and `workflows` folders if you have a previous ComfyUI installation.
- **Delete or rename** any old `C:\ComfyUI` folder if you want a completely clean install.

---

### 2. Installation

Save the following as `install_comfyui_venv.bat` and run it (double-click or right-click > Run as administrator):

```batch
@echo off
REM === [OPTIONAL] Delete old ComfyUI folder for a clean install ===
REM rmdir /s /q C:\ComfyUI

REM 1. Clone the latest ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git C:\ComfyUI

REM 2. Go to the ComfyUI directory
cd /d C:\ComfyUI

REM 3. Create an isolated Python venv
python -m venv comfyui_venv

REM 4. Activate the venv
call comfyui_venv\Scripts\activate.bat

REM 5. Upgrade pip
python -m pip install --upgrade pip

REM 6. Install base dependencies
pip install -r requirements.txt

REM 7. Uninstall any previous torch
pip uninstall -y torch torchvision torchaudio

REM 8. Install Intel Arc (XPU) optimized torch
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

REM 9. Upgrade to the latest official ComfyUI frontend
pip install --upgrade comfyui-frontend-package

REM 10. Show torch version for confirmation
python -c "import torch; print('Torch version:', torch.__version__)"

echo.
echo ==========================
echo Installation complete!
echo If you see Torch version ...+xpu, you are ready.
echo You can now launch ComfyUI with the start batch file.
echo ==========================
pause
```

---

### 3. Launching ComfyUI

Save the following as `start_comfyui_venv.bat` and use it to start ComfyUI every time:

```batch
@echo off
set SYCL_CACHE_PERSISTENT=1
cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

REM Launch with always up-to-date official frontend
python main.py --preview-method auto --output-directory C:\Users\%USERNAME%\Documents\AI-Playground\media --lowvram --disable-ipex-optimize --bf16-unet --reserve-vram 6.0 --front-end-version Comfy-Org/ComfyUI_frontend@latest

pause
```

---

### 4. (Optional) Install ComfyUI Manager

Save this as `install_comfyui_manager_venv.bat` and run it after installing ComfyUI:

```batch
@echo off
REM Activate the venv
cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

REM Go to custom_nodes directory
cd custom_nodes

REM Clone ComfyUI-Manager (if not already present)
IF NOT EXIST comfyui-manager (
    git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
) ELSE (
    echo comfyui-manager already exists, skipping clone.
)

REM Install ComfyUI-Manager dependencies
pip install -r comfyui-manager\requirements.txt

echo.
echo ==========================
echo ComfyUI Manager installed!
echo Restart ComfyUI to enable the Manager.
echo ==========================
pause
```

---

## Notes

- After installation, copy your `models`, `custom_nodes`, and `workflows` folders into `C:\ComfyUI` if needed.
- Only use custom nodes that are compatible with Intel Arc/XPU (not CUDA-only).
- If you see `Torch version: ...+xpu` and `Device: xpu` in the ComfyUI log, you are using Intel Arc or Intel Ultra Core iGPU acceleration.
- No need to manually patch `model_management.py` with this setup.
- To update ComfyUI or the frontend, simply re-run the install batch.

---

## Troubleshooting

- **If you see `Device: cpu` and not `xpu`:**
  - Make sure you activated the venv before installing torch.
  - Uninstall torch and reinstall the XPU version in the venv as shown above.
- **If you update ComfyUI:**  
  - Re-run the install batch if needed to ensure all dependencies are correct.
- **If you get a CUDA error:**  
  - You may have a leftover CUDA-only node or an old workflow forcing `"cuda"` as device. Remove/replace these.

---

## References

- [ComfyUI Official GitHub](https://github.com/comfyanonymous/ComfyUI)
- [Intel Arc Graphics Thread (ComfyUI)](https://github.com/comfyanonymous/ComfyUI/discussions/476)
- [ComfyUI install guide and benchmarks on Intel Arc (Reddit)](https://www.reddit.com/r/IntelArc/comments/1hhkbhs/comfyui_install_guide_and_sample_benchmarks_on/)
- [How to Install and Run ComfyUI on Intel Arc - YTECHB](https://www.ytechb.com/how-to-install-and-run-comfyui-on-intel-arc/)
- [Tech Craft: Install and control ComfyUI on PCs with Intel Arc GPUs (YouTube)](https://www.youtube.com/watch?v=fQKOJVVi44E)
- [ComfyUI Windows venv/conda install tutorial](https://comfyui.org/en/comfyui-windows-conda-venv)

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Credits

Scripts and guide by [ai-joe-git](https://github.com/ai-joe-git).  
Inspired by the Intel Arc and ComfyUI communities.

---

**Share these scripts and this README to help other Intel Arc and Intel Ultra Core users enjoy a smooth ComfyUI experience!**

Citations:
[1] https://github.com/ai-joe-git
[2] https://www.reddit.com/r/IntelArc/comments/1hhkbhs/comfyui_install_guide_and_sample_benchmarks_on/
[3] https://comfyui.org/en/comfyui-windows-conda-venv
[4] https://github.com/eli64s/readme-ai
[5] https://github.com/comfyanonymous/ComfyUI/discussions/476
[6] https://www.youtube.com/watch?v=fQKOJVVi44E
[7] https://www.ytechb.com/how-to-install-and-run-comfyui-on-intel-arc/
[8] https://www.youtube.com/watch?v=iK02IBeehT8
[9] https://www.youtube.com/watch?v=n2KM9ipvhaw
[10] https://docs.comfy.org/get_started/introduction
[11] https://benhouston3d.com/blog/crafting-readmes-for-ai
[12] https://community.intel.com/t5/Intel-ARC-Graphics/Need-Step-by-step-tutorial-newbie-how-to-install-comfyui-to-run/td-p/1576043
[13] https://www.youtube.com/watch?v=z5Y9L31ug4E
[14] https://www.reddit.com/r/comfyui/comments/1hhkx8l/comfyui_install_guide_and_sample_benchmarks_on/
[15] https://www.dhiwise.com/post/how-to-write-a-readme-that-stands-out-in-best-practices
[16] https://www.reddit.com/r/LocalLLaMA/comments/1hhkb4s/comfyui_install_guide_and_sample_benchmarks_on/?tl=fr
[17] https://www.reddit.com/r/comfyui/comments/1bf7aoz/python_virtual_environments_for_comfyui/
[18] https://docs.comfy.org/installation/system_requirements
[19] https://www.reddit.com/r/ChatGPTCoding/comments/1hg8m52/best_practices_for_converting_documentation_to/
[20] https://github.com/comfyanonymous/ComfyUI/blob/master/README.md
[21] https://comfyui-wiki.com/en/install/install-comfyui/install-comfyui-on-windows
