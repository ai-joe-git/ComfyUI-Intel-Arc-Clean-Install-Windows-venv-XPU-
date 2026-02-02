@echo off
title ComfyUI - Intel Arc XPU 

echo ================================================
echo Starting ComfyUI with Intel Arc XPU
echo ================================================

cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

echo.
echo [INFO] GGUF Triton optimization enabled
echo [INFO] First GGUF load will compile kernels (~10-30 sec)
echo [INFO] Subsequent loads will use cached kernels
echo.

python main.py ^
--cache-none ^
--lowvram ^
--front-end-version "Comfy-Org/ComfyUI_frontend@latest" ^
--max-upload-size 500 ^
--enable-cors-header "*" ^
--listen 0.0.0.0


pause