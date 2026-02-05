@echo off
title ComfyUI - Intel Arc (Speed Recovery)

echo ================================================
echo Starting ComfyUI with Intel Arc XPU
echo ================================================

:: They don't affect math, just driver stability.
set UR_L0_ENABLE_RELAXED_ALLOCATION_LIMITS=1
set SYCL_CACHE_PERSISTENT=1

cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

:: We removed --use-pytorch-cross-attention 
:: We kept your original --gpu-only and --cache-none
python main.py ^
--gpu-only ^
--cache-none ^
--front-end-version "Comfy-Org/ComfyUI_frontend@latest" ^
--enable-cors-header "*" ^
--listen 0.0.0.0

pause
