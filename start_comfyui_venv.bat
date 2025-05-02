@echo off
set SYCL_CACHE_PERSISTENT=1
cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

REM Launch with always up-to-date official frontend
python main.py --preview-method auto --output-directory C:\Users\%USERNAME%\Documents\AI-Playground\media --lowvram --disable-ipex-optimize --bf16-unet --reserve-vram 6.0 --front-end-version Comfy-Org/ComfyUI_frontend@latest

pause
