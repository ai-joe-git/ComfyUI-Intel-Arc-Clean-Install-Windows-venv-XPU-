@echo off
set SYCL_CACHE_PERSISTENT=1
set SYCL_CACHE_DIR=C:\ComfyUI\sycl_cache


REM Intel Arc GPU compatibility fixes
set ONEAPI_DEVICE_SELECTOR=level_zero:gpu
set SYCL_DEVICE_FILTER=level_zero:gpu



REM Create cache directory if it doesn't exist
if not exist "C:\ComfyUI\sycl_cache\" mkdir "C:\ComfyUI\sycl_cache"


cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat


python main.py --preview-method auto --output-directory C:\Users\%USERNAME%\Documents\AI-Playground\media --lowvram --bf16-unet --use-split-cross-attention --disable-smart-memory --async-offload --front-end-version Comfy-Org/ComfyUI_frontend@latest --oneapi-device-selector level_zero:gpu


pause
