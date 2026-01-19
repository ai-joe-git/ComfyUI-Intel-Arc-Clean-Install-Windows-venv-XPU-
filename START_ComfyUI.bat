@echo off
title ComfyUI - Intel Arc XPU with Triton Optimization

REM ============================================
REM Initialize C++ Compiler for Triton
REM ============================================
echo ================================================================
echo Initializing ComfyUI with Intel Arc XPU
echo ================================================================

set "MSVC_FOUND=0"
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
    set "MSVC_FOUND=1"
    set "VCVARS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
)
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "MSVC_FOUND=1"
    set "VCVARS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
)

if "%MSVC_FOUND%"=="1" (
    echo [COMPILER] Loading C++ environment for Triton...
    call "%VCVARS_PATH%" >nul 2>&1
    echo OK: C++ compiler loaded
) else (
    echo [WARNING] C++ compiler not found - Triton may not work
    echo Install Visual Studio Build Tools for GGUF acceleration
)

REM ============================================
REM Intel XPU Environment Variables
REM ============================================
set SYCL_CACHE_PERSISTENT=1
set SYCL_CACHE_DIR=C:\ComfyUI\sycl_cache
set SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
set ONEAPI_DEVICE_SELECTOR=level_zero:gpu
set SYCL_DEVICE_FILTER=level_zero:gpu

if not exist "C:\ComfyUI\sycl_cache" mkdir "C:\ComfyUI\sycl_cache"

echo [XPU] Intel Arc GPU acceleration enabled
echo.

REM ============================================
REM Launch ComfyUI
REM ============================================
cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

echo [INFO] Starting ComfyUI...
echo [INFO] GGUF Triton optimization: Active
echo [INFO] First GGUF load will compile kernels (~10-30 sec)
echo [INFO] Access UI: http://127.0.0.1:8188
echo.

python main.py ^
--lowvram ^
--bf16-unet ^
--async-offload ^
--disable-smart-memory ^
--preview-method auto ^
--output-directory "%USERPROFILE%\Documents\AI-Playground\media" ^
--front-end-version "Comfy-Org/ComfyUI_frontend@latest"

pause
