# ComfyUI Intel Arc GPU - Complete Installation Suite
## Windows | Virtual Environment | XPU Backend | Triton Acceleration

[![Intel Arc](https://img.shields.io/badge/Intel-Arc_GPU-0071C5?logo=intel)](https://www.intel.com/arc)
[![PyTorch](https://img.shields.io/badge/PyTorch-XPU_Nightly-EE4C2C?logo=pytorch)](https://pytorch.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Fully automated installation scripts for ComfyUI optimized for Intel Arc GPUs (A-Series) and Intel Core Ultra iGPUs with XPU backend, Triton acceleration, and GGUF quantized model support.**

---

## 🚀 Features

- ✅ **One-click installation** - Automated setup with dependency resolution
- ✅ **Intel Arc optimized** - Native XPU backend with PyTorch nightly builds
- ✅ **Triton acceleration** - 6-11x faster GGUF model loading and inference
- ✅ **Isolated environment** - Clean Python venv, no conflicts with other AI tools
- ✅ **Essential nodes included** - ComfyUI-Manager, GGUF, VideoHelper, Impact Pack
- ✅ **Always up-to-date** - Scripts pull latest ComfyUI and PyTorch versions
- ✅ **No manual patching** - Automatic XPU detection and optimization

---

## 📋 Requirements

### Hardware
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **GPU** | Intel Arc A310 | Intel Arc A770 16GB |
| **iGPU** | Intel Core Ultra 5 | Intel Core Ultra 7/9 |
| **RAM** | 16GB | 32GB+ |
| **Storage** | 50GB free | 100GB+ SSD |

### Software
- **Windows 10/11** (64-bit)
- **Python 3.10 or 3.11** - [Download](https://www.python.org/downloads/)
- **Git for Windows** - [Download](https://git-scm.com/download/win)
- **Visual Studio Build Tools 2022** - [Download](https://visualstudio.microsoft.com/downloads/)
  - Required for Triton GGUF acceleration
  - Select: "Desktop development with C++"
- **Latest Intel Graphics Drivers** - [Download](https://www.intel.com/content/www/us/en/download/785597/intel-arc-iris-xe-graphics-windows.html)

---

## 🎯 Quick Start

### 1. Download Scripts

Clone this repository or download as ZIP:

```bash
git clone https://github.com/ai-joe-git/ComfyUI-Intel-Arc-Clean-Install-Windows-venv-XPU-.git
cd ComfyUI-Intel-Arc-Clean-Install-Windows-venv-XPU-
```

### 2. Run Installation (5 minutes)

**Run scripts in this order:**

```batch
1. INSTALL_ComfyUI_Intel_Arc_XPU.bat       # Core installation
2. INSTALL_Custom_Nodes.bat                 # Essential nodes
3. INSTALL_GGUF_Triton_Patch.bat           # GGUF acceleration
4. START_ComfyUI.bat                        # Launch ComfyUI
```

### 3. Access ComfyUI

Open your browser: **http://127.0.0.1:8188**

---

## 📦 What Gets Installed

### Core Components
- **ComfyUI** - Latest from official repository
- **PyTorch 2.11+ XPU Nightly** - Intel Arc optimized builds
- **Triton XPU 3.6+** - GPU kernel acceleration
- **ComfyUI Frontend** - Latest official UI

### Essential Custom Nodes
- **ComfyUI-Manager** - Node package manager
- **ComfyUI-GGUF** - Quantized model support (Q4_0, Q8_0, etc.)
- **ComfyUI-VideoHelperSuite** - Video generation tools
- **ComfyUI-Impact-Pack** - Utility nodes
- **rgthree-comfy** - Workflow optimization tools

### Performance Optimizations
- **GGUF Triton Patch** - Accelerated dequantization
  - Q4_0 models: ~11x faster
  - Q8_0 models: ~6x faster
  - Q4_1 models: ~8x faster

---

## 🔧 Detailed Installation Guide

### Script 1: Core Installation

`INSTALL_ComfyUI_Intel_Arc_XPU.bat`

**What it does:**
1. ✓ Verifies Python 3.10/3.11 and Git installation
2. ✓ Checks for Visual Studio Build Tools (C++ compiler)
3. ✓ Clones ComfyUI to `C:\ComfyUI`
4. ✓ Creates isolated Python virtual environment
5. ✓ Installs PyTorch XPU nightly builds
6. ✓ Installs Triton XPU for acceleration
7. ✓ Installs ComfyUI dependencies
8. ✓ Verifies XPU device detection

**Expected output:**
```
PyTorch: 2.11.0.dev20260118+xpu
XPU available: True
Device: Intel(R) Arc(TM) A770 Graphics (16GB)
```

### Script 2: Custom Nodes Installation

`INSTALL_Custom_Nodes.bat`

**What it does:**
- Clones essential custom nodes to `C:\ComfyUI\custom_nodes\`
- Installs node-specific dependencies
- Updates existing nodes if already installed

**Nodes installed:**
- ComfyUI-Manager (ltdrdata)
- ComfyUI-GGUF (city96)
- ComfyUI-VideoHelperSuite (Kosinkadink)
- ComfyUI-Impact-Pack (ltdrdata)
- rgthree-comfy (rgthree)

### Script 3: GGUF Triton Patch

`INSTALL_GGUF_Triton_Patch.bat`

**What it does:**
1. ✓ Verifies ComfyUI-GGUF node is installed
2. ✓ Downloads latest Triton patch from this repo
3. ✓ Applies patch to enable GPU-accelerated dequantization
4. ✓ Verifies Triton kernels are active

**Performance improvements:**

| Model Type | Without Triton | With Triton | Speedup |
|------------|----------------|-------------|---------|
| Q4_0 GGUF | Slow PyTorch | Triton kernel | ~11x faster |
| Q8_0 GGUF | Slow PyTorch | Triton kernel | ~6x faster |
| Q4_1 GGUF | Slow PyTorch | Triton kernel | ~8x faster |
| Q4_K_M | PyTorch | PyTorch | No change* |

*K-quants (Q4_K_M, Q5_K_M, Q6_K) not yet accelerated by this patch.

### Script 4: Launch ComfyUI

`START_ComfyUI.bat`

**What it does:**
- Initializes Visual Studio C++ environment for Triton
- Sets Intel XPU environment variables
- Activates Python virtual environment
- Launches ComfyUI with optimized flags

**Startup flags:**
- `--lowvram` - Efficient memory management for 8-16GB GPUs
- `--bf16-unet` - BFloat16 precision (faster, lower VRAM)
- `--async-offload` - Asynchronous model offloading
- `--disable-smart-memory` - Predictable memory behavior

---

## 🎮 Supported Hardware

### Intel Arc Discrete GPUs (Full Support ✅)

| GPU Model | VRAM | Performance | Notes |
|-----------|------|-------------|-------|
| Arc A770 LE | 16GB | Excellent | Best for video generation |
| Arc A770 | 8GB | Very Good | Recommended for most workflows |
| Arc A750 | 8GB | Very Good | Great price/performance |
| Arc A580 | 8GB | Good | Budget option |
| Arc A380 | 6GB | Fair | Entry level |
| Arc A310 | 4GB | Limited | Simple workflows only |

### Intel Core Ultra iGPUs (Supported ✅)

| CPU Series | iGPU | Performance | Notes |
|------------|------|-------------|-------|
| Core Ultra 9 | Intel Arc iGPU | Good | Meteor Lake/Arrow Lake |
| Core Ultra 7 | Intel Arc iGPU | Good | Best laptop option |
| Core Ultra 5 | Intel Arc iGPU | Fair | Budget laptop |

### Intel Iris Xe (Experimental ⚠️)

- 11th/12th Gen Intel Core with Iris Xe
- Limited support, may fallback to CPU
- Not recommended for production use

### Legacy Intel Graphics (Not Supported ❌)

- Intel UHD Graphics (10th Gen and older)
- CPU-only mode (extremely slow)

---

## 🛠️ Updating ComfyUI

Run `UPDATE_ComfyUI.bat` to update:
- ComfyUI core
- PyTorch XPU nightly
- Triton XPU
- All custom nodes
- Python dependencies

The script safely updates while preserving your models and workflows.

---

## 📊 Performance Benchmarks

### LTX Video 2 (481 frames @ 768x512, 8 steps)

| Hardware | Time | GGUF Triton | Notes |
|----------|------|-------------|-------|
| Arc A770 16GB | 25:32 | Enabled | Q8_0 FLUX + Qwen |
| Arc A770 8GB | ~30:00 | Enabled | --lowvram required |
| Arc A750 8GB | ~32:00 | Enabled | Comparable to A770 8GB |
| Core Ultra 7 | ~45:00 | Enabled | iGPU only |

### FLUX.1 Dev (1024x1024, 20 steps)

| Hardware | Time | VRAM Used |
|----------|------|-----------|
| Arc A770 16GB | ~45s | 14GB |
| Arc A770 8GB | ~60s | 7.8GB (offloading) |
| Arc A750 8GB | ~65s | 7.8GB (offloading) |

*Benchmarks with GGUF Q8_0 models and Triton acceleration enabled.*

---

## 🐛 Troubleshooting

### Issue: "CUDA not available" or falls back to CPU

**Solution:**
```batch
# Verify XPU is detected
python -c "import torch; print(torch.xpu.is_available())"
```

If False:
1. Update Intel Graphics drivers
2. Reinstall PyTorch XPU: `pip install --pre torch --index-url https://download.pytorch.org/whl/nightly/xpu --force-reinstall`

### Issue: "Failed to find C++ compiler" error

**Solution:**
1. Install Visual Studio Build Tools 2022
2. Select "Desktop development with C++"
3. Restart your PC
4. Run `START_ComfyUI.bat` (not `python main.py` directly)

### Issue: Out of Memory (OOM) errors

**Solutions:**
- Use `--lowvram` flag (already in START script)
- Try GGUF quantized models (Q4_0, Q8_0)
- Reduce resolution or batch size
- Close other GPU applications

### Issue: Triton kernels not working

**Verify Triton:**
```batch
cd C:\ComfyUI
call comfyui_venv\Scripts\activate.bat
python -c "from custom_nodes.ComfyUI-GGUF.dequant import HAS_TRITON; print('Triton:', HAS_TRITON)"
```

If False:
```batch
pip install pytorch-triton-xpu --force-reinstall
```

### Issue: Slow performance compared to expected

**Checklist:**
- ✓ Triton patch applied? Check ComfyUI console for "Triton available, enabling optimized kernels"
- ✓ Using GGUF Q8_0/Q4_0 models for acceleration?
- ✓ GPU utilization at 100%? Check Task Manager
- ✓ Power plan set to "High Performance"?
- ✓ Latest Intel Graphics drivers installed?

---

## 💡 Tips for Best Performance

### Model Format Recommendations

| Use Case | Model Format | Why |
|----------|--------------|-----|
| **Best Quality** | GGUF Q8_0 | Minimal quality loss, 6x faster with Triton |
| **Balanced** | GGUF Q4_K_M | Good quality, smaller size |
| **Maximum Speed** | GGUF Q4_0 | 11x faster with Triton, acceptable quality |
| **Full Precision** | FP16/BF16 | Highest quality, largest size, slowest |

### Memory Management

**For 16GB Arc GPUs:**
- Remove `--lowvram` from START script for fastest performance
- Can run most models without offloading

**For 8GB Arc GPUs:**
- Keep `--lowvram` flag (default)
- Use GGUF quantized models
- Avoid loading multiple large models simultaneously

**For 4-6GB Arc GPUs:**
- Add `--novram` for maximum offloading
- Use Q4_0 GGUF models
- Lower resolution workflows only

### Workflow Optimization

- **Use GGUF models** - Faster loading with Triton acceleration
- **Enable caching** - Triton compiles kernels once, then caches
- **Batch processing** - Process multiple frames/images together
- **Lower steps** - 6-8 steps often sufficient with good samplers

---

## 📁 Directory Structure

After installation:

```
C:\ComfyUI\
├── comfyui_venv\           # Python virtual environment
├── custom_nodes\           # Custom nodes
│   ├── ComfyUI-Manager\
│   ├── ComfyUI-GGUF\       # Quantized models (Triton patched)
│   ├── ComfyUI-VideoHelperSuite\
│   ├── ComfyUI-Impact-Pack\
│   └── rgthree-comfy\
├── models\                 # Place models here
│   ├── checkpoints\
│   ├── clip\
│   ├── vae\
│   ├── loras\
│   └── unet\
├── input\                  # Input images/videos
├── output\                 # Generated outputs
├── user\                   # User settings
├── sycl_cache\            # XPU kernel cache
└── main.py                # ComfyUI entry point
```

---

## 🔗 Useful Resources

### Official Documentation
- [Intel Arc Graphics Drivers](https://www.intel.com/content/www/us/en/download/785597/intel-arc-iris-xe-graphics-windows.html)
- [ComfyUI Official GitHub](https://github.com/comfyanonymous/ComfyUI)
- [PyTorch XPU Documentation](https://pytorch.org/get-started/locally/)

### Community
- [ComfyUI Intel Arc Thread](https://github.com/comfyanonymous/ComfyUI/discussions/476)
- [Reddit: r/IntelArc](https://www.reddit.com/r/IntelArc/)
- [Reddit: r/ComfyUI](https://www.reddit.com/r/comfyui/)

### Model Resources
- [CivitAI](https://civitai.com/) - User-uploaded models
- [HuggingFace](https://huggingface.co/) - Official model hub
- [ComfyUI Workflows](https://openart.ai/workflows/comfyui) - Shared workflows

---

## 🤝 Contributing

Contributions welcome! Please:
1. Test on Intel Arc hardware
2. Document any issues or improvements
3. Submit PR with clear description

---

## 📜 License

MIT License - See [LICENSE](LICENSE) for details

---

## 🙏 Credits

- **Scripts**: ai-joe-git
- **ComfyUI**: comfyanonymous
- **GGUF Node**: city96
- **Intel XPU Community**: Everyone testing and sharing knowledge

---

## ⭐ Support

If these scripts helped you, please:
- ⭐ Star this repository
- 🐛 Report issues on GitHub
- 💬 Share your results in Discussions
- 📢 Help other Intel Arc users!

---

**Last Updated:** January 2026  
**ComfyUI Version:** 0.9.2+  
**PyTorch XPU Version:** 2.11.0.dev+  
**Tested Hardware:** Arc A770, A750, A580, Core Ultra 7/9

---

## 🚀 What's New

### January 2026
- ✅ Triton XPU integration for GGUF acceleration
- ✅ Automated patch installer with GitHub download
- ✅ Visual Studio Build Tools detection
- ✅ PyTorch 2.11+ nightly XPU builds
- ✅ Streamlined installation process
- ✅ Performance improvements for Q8_0/Q4_0 models

### Coming Soon
- 🔄 K-quant Triton kernels (Q4_K_M, Q5_K_M)
- 🔄 Automatic model downloader
- 🔄 ComfyUI Portable build option
- 🔄 Docker container for Intel Arc

---

**Made with ❤️ for the Intel Arc community**
