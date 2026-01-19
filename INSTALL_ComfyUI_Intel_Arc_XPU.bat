@echo off
setlocal EnableDelayedExpansion
title ComfyUI Intel Arc XPU - Complete Installation

echo ================================================================
echo ComfyUI Intel Arc XPU Installer
echo ================================================================
echo.
echo This will install:
echo   - ComfyUI (latest)
echo   - PyTorch XPU Nightly (Intel Arc optimized)
echo   - Triton XPU (for GGUF acceleration)
echo   - Python virtual environment
echo   - Visual Studio Build Tools verification
echo.
echo Installation directory: C:\ComfyUI
echo.
pause

REM ============================================
REM Step 1: Check Prerequisites
REM ============================================
echo.
echo [1/8] Checking prerequisites...

where python >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found! Install Python 3.10 or 3.11 first.
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)

where git >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git not found! Install Git for Windows first.
    echo Download: https://git-scm.com/download/win
    pause
    exit /b 1
)

python --version | findstr /C:"3.10" /C:"3.11" >nul
if errorlevel 1 (
    echo WARNING: Python 3.10 or 3.11 recommended. You may encounter issues.
    pause
)

echo OK: Python and Git found

REM ============================================
REM Step 2: Check Visual Studio Build Tools
REM ============================================
echo.
echo [2/8] Checking C++ compiler for Triton...

set "MSVC_FOUND=0"
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
    set "MSVC_FOUND=1"
    set "VCVARS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
)
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "MSVC_FOUND=1"
    set "VCVARS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
)

if "%MSVC_FOUND%"=="0" (
    echo.
    echo WARNING: Visual Studio Build Tools not found!
    echo Triton GGUF acceleration requires C++ compiler.
    echo.
    echo Download Build Tools: https://visualstudio.microsoft.com/downloads/
    echo Select: "Build Tools for Visual Studio 2022"
    echo Install: Desktop development with C++
    echo.
    echo Continue anyway? (Y/N)
    choice /C YN /N
    if errorlevel 2 exit /b 1
) else (
    echo OK: MSVC compiler found
)

REM ============================================
REM Step 3: Clone/Update ComfyUI
REM ============================================
echo.
echo [3/8] Setting up ComfyUI...

if exist "C:\ComfyUI" (
    echo ComfyUI directory exists. Update? (Y/N)
    choice /C YN /N
    if errorlevel 2 (
        echo Skipping ComfyUI clone
    ) else (
        cd /d C:\ComfyUI
        git pull
    )
) else (
    echo Cloning ComfyUI...
    git clone https://github.com/comfyanonymous/ComfyUI.git C:\ComfyUI
    if errorlevel 1 (
        echo ERROR: Failed to clone ComfyUI
        pause
        exit /b 1
    )
)

cd /d C:\ComfyUI

REM ============================================
REM Step 4: Create Virtual Environment
REM ============================================
echo.
echo [4/8] Creating Python virtual environment...

if exist "comfyui_venv" (
    echo Virtual environment already exists
) else (
    python -m venv comfyui_venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment
        pause
        exit /b 1
    )
)

call comfyui_venv\Scripts\activate.bat

REM ============================================
REM Step 5: Install PyTorch XPU Nightly
REM ============================================
echo.
echo [5/8] Installing PyTorch XPU Nightly for Intel Arc...

python -m pip install --upgrade pip

pip uninstall -y torch torchvision torchaudio intel-extension-for-pytorch

echo Installing PyTorch XPU nightly build...
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

echo.
echo Verifying PyTorch XPU installation...
python -c "import torch; print('PyTorch:', torch.__version__); print('XPU available:', hasattr(torch, 'xpu') and torch.xpu.is_available()); print('Device:', torch.xpu.get_device_name(0) if torch.xpu.is_available() else 'XPU not available')"

REM ============================================
REM Step 6: Install ComfyUI Dependencies
REM ============================================
echo.
echo [6/8] Installing ComfyUI dependencies...

pip install -r requirements.txt

REM ============================================
REM Step 7: Install Triton XPU
REM ============================================
echo.
echo [7/8] Installing Triton XPU for GGUF acceleration...

pip install pytorch-triton-xpu

echo.
echo Verifying Triton installation...
python -c "try: import triton; print('Triton version:', triton.__version__); except Exception as e: print('Triton not available:', e)"

REM ============================================
REM Step 8: Install ComfyUI Frontend
REM ============================================
echo.
echo [8/8] Installing ComfyUI frontend...

pip install --upgrade comfyui-frontend-package

REM ============================================
REM Create directories
REM ============================================
echo.
echo Creating directories...

if not exist "models" mkdir models
if not exist "custom_nodes" mkdir custom_nodes
if not exist "input" mkdir input
if not exist "output" mkdir output
if not exist "user" mkdir user

REM ============================================
REM Installation Complete
REM ============================================
echo.
echo ================================================================
echo Installation Complete!
echo ================================================================
echo.
echo Next steps:
echo   1. Run INSTALL_Custom_Nodes.bat to install recommended nodes
echo   2. Run INSTALL_GGUF_Triton_Patch.bat for GGUF acceleration
echo   3. Copy your models to C:\ComfyUI\models\
echo   4. Run START_ComfyUI.bat to launch
echo.
echo Installation directory: C:\ComfyUI
echo ================================================================
pause
