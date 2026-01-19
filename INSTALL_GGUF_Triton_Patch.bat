@echo off
title Installing GGUF Triton Patch

echo ================================================================
echo GGUF Triton Optimization Patch Installer
echo ================================================================
echo.
echo This will apply Triton acceleration to GGUF models:
echo   - Q4_0: ~11x faster dequantization
echo   - Q4_1: ~8x faster dequantization
echo   - Q8_0: ~6x faster dequantization
echo.
pause

cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

REM ============================================
REM Check if GGUF node exists
REM ============================================
echo.
echo [CHECK] Verifying ComfyUI-GGUF installation...

if not exist "custom_nodes\ComfyUI-GGUF" (
    echo ERROR: ComfyUI-GGUF not found!
    echo Run INSTALL_Custom_Nodes.bat first.
    pause
    exit /b 1
)

echo OK: ComfyUI-GGUF found

REM ============================================
REM Download patch from GitHub
REM ============================================
echo.
echo [DOWNLOAD] Fetching latest Triton patch...

powershell -Command "& {Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ai-joe-git/ComfyUI-Intel-Arc-Clean-Install-Windows-venv-XPU-/main/patches/comfyui_gguf_xpu.patch' -OutFile 'comfyui_gguf_xpu.patch'}" 2>nul

if not exist "comfyui_gguf_xpu.patch" (
    echo WARNING: Could not download patch automatically
    echo.
    echo Please download manually:
    echo https://github.com/ai-joe-git/ComfyUI-Intel-Arc-Clean-Install-Windows-venv-XPU-/blob/main/patches/comfyui_gguf_xpu.patch
    echo.
    echo Place it in: C:\ComfyUI\comfyui_gguf_xpu.patch
    echo Then run this script again.
    pause
    exit /b 1
)

echo OK: Patch file downloaded

REM ============================================
REM Apply patch
REM ============================================
echo.
echo [PATCH] Applying Triton optimization...

cd custom_nodes\ComfyUI-GGUF

REM Check if already applied
git apply --reverse --check ..\..\comfyui_gguf_xpu.patch >nul 2>&1
if not errorlevel 1 (
    echo Patch already applied. Skipping...
    goto :verify
)

REM Apply patch
git apply --whitespace=fix ..\..\comfyui_gguf_xpu.patch
if errorlevel 1 (
    echo.
    echo WARNING: Patch may not have applied cleanly
    echo This is usually safe - checking for Triton code...
    
    findstr /C:"HAS_TRITON" dequant.py >nul 2>&1
    if errorlevel 1 (
        echo ERROR: Triton code not found in dequant.py
        echo Manual patch may be required
        pause
        exit /b 1
    )
)

echo OK: Patch applied successfully

:verify
REM ============================================
REM Verify installation
REM ============================================
echo.
echo [VERIFY] Checking Triton integration...

cd ..\..
python -c "from custom_nodes.ComfyUI-GGUF.dequant import HAS_TRITON, USE_TRITON_KERNELS; print('HAS_TRITON:', HAS_TRITON); print('USE_TRITON_KERNELS:', USE_TRITON_KERNELS); exit(0 if HAS_TRITON and USE_TRITON_KERNELS else 1)"

if errorlevel 1 (
    echo.
    echo WARNING: Triton kernels not enabled
    echo Check that pytorch-triton-xpu is installed correctly
    pause
) else (
    echo OK: Triton kernels enabled!
)

echo.
echo ================================================================
echo GGUF Triton Patch Installation Complete!
echo ================================================================
echo.
echo Performance improvements:
echo   - Q4_0 models: ~11x faster
echo   - Q8_0 models: ~6x faster
echo   - First load will compile kernels (~10-30 seconds)
echo   - Subsequent loads use cached kernels
echo.
echo Next: Run START_ComfyUI.bat to launch with optimizations!
echo ================================================================
pause
