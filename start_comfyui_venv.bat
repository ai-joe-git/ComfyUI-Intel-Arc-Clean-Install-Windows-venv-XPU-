@echo off
set SYCL_CACHE_PERSISTENT=1
set SYCL_CACHE_DIR=C:\ComfyUI\sycl_cache
set SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1

REM Intel Arc GPU compatibility fixes
set ONEAPI_DEVICE_SELECTOR=level_zero:gpu
set SYCL_DEVICE_FILTER=level_zero:gpu

REM Create cache directory if it doesn't exist
if not exist "C:\ComfyUI\sycl_cache" mkdir "C:\ComfyUI\sycl_cache"

cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

REM Eager mode: no torch.compile backend, plain PyTorch on XPU
REM Removed --use-split-cross-attention for stability
python main.py ^
--preview-method auto ^
--output-directory "C:\Users\%USERNAME%\Documents\AI-Playground\media" ^
--lowvram ^
--bf16-unet ^
--disable-smart-memory ^
--async-offload ^
--front-end-version "Comfy-Org/ComfyUI_frontend@latest" ^
--oneapi-device-selector level_zero:gpu

pause
