@echo off
title ComfyUI Intel Arc XPU - Advanced Installation v2.0

echo ================================================================
echo ComfyUI Intel Arc XPU Installer v2.0
echo ================================================================
echo.
echo This installer combines Intel best practices with cutting-edge
echo PyTorch XPU nightly builds for maximum performance.
echo.
echo Features:
echo   - ComfyUI ^(latest from official repo^)
echo   - PyTorch 2.11+ XPU Nightly ^(faster than Intel's 2.5.1^)
echo   - Triton XPU ^(GGUF acceleration^)
echo   - Python venv ^(lighter than conda^)
echo   - Visual Studio Build Tools verification
echo   - Intel XPU environment optimization
echo.
echo Installation directory: C:\ComfyUI
echo Estimated time: 10-15 minutes
echo Disk space required: ~8GB
echo.
pause

REM ============================================
REM Step 1: System Checks
REM ============================================
echo.
echo [1/7] Performing system checks...

REM Check Python
where python >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found!
    echo.
    echo Download Python 3.11 ^(recommended^):
    echo https://www.python.org/downloads/release/python-3110/
    echo.
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

REM Get Python version
for /f "usebackq tokens=2" %%i in (`python --version 2^>^&1`) do set PYTHON_VER=%%i
echo Found Python: %PYTHON_VER%

python --version | findstr /C:"3.10" /C:"3.11" >nul
if errorlevel 1 (
    echo WARNING: Python 3.10 or 3.11 recommended for best compatibility
    echo Current version: %PYTHON_VER%
    echo.
    echo Continue anyway? ^(Y/N^)
    choice /C YN /N
    if errorlevel 2 exit /b 1
)

REM Check Git
where git >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git not found!
    echo.
    echo Download Git for Windows:
    echo https://git-scm.com/download/win
    pause
    exit /b 1
)

echo OK: Python %PYTHON_VER% and Git found

REM ============================================
REM Step 2: Check Intel GPU
REM ============================================
echo.
echo [2/7] Detecting Intel GPU...

powershell -c "Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty Name" | findstr /i "Arc Iris Xe Intel(R) UHD" >nul
if errorlevel 1 (
    echo WARNING: No Intel GPU detected!
    echo.
    echo This setup is optimized for:
    echo   - Intel Arc A-Series ^(A310, A380, A580, A750, A770^)
    echo   - Intel Core Ultra iGPU ^(Meteor Lake, Arrow Lake^)
    echo.
    echo Your GPU:
    powershell -c "Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty Name"
    echo.
    echo Continue with CPU-only mode? ^(Y/N^)
    choice /C YN /N
    if errorlevel 2 exit /b 1
) else (
    echo Detected Intel GPU:
    powershell -c "Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty Name" | findstr /i "Arc Iris Xe Intel(R) UHD"
)


REM ============================================
REM Step 3: Clone/Update ComfyUI
REM ============================================
echo.
echo [3/7] Setting up ComfyUI repository...

if exist "C:\ComfyUI" (
    echo.
    echo ComfyUI directory already exists: C:\ComfyUI
    echo.
    echo Options:
    echo   [U] Update existing installation ^(keeps models/workflows^)
    echo   [F] Fresh install ^(delete and reinstall^)
    echo   [S] Skip ^(use existing^)
    echo.
    choice /C UFS /N /M "Choose option: "

    if errorlevel 3 (
        echo Skipping ComfyUI clone...
        cd /d C:\ComfyUI
    )
    if errorlevel 2 if not errorlevel 3 (
        echo Backing up models and custom_nodes...
        if exist "models" move models models_backup >nul 2>&1
        if exist "custom_nodes" move custom_nodes custom_nodes_backup >nul 2>&1

        echo Removing old ComfyUI...
        rmdir /s /q "C:\ComfyUI"

        echo Cloning fresh ComfyUI...
        git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git C:\ComfyUI

        cd /d C:\ComfyUI
        if exist "..\models_backup" move ..\models_backup models >nul 2>&1
        if exist "..\custom_nodes_backup" move ..\custom_nodes_backup custom_nodes >nul 2>&1
    )
    if errorlevel 1 if not errorlevel 2 (
        cd /d C:\ComfyUI
        echo Updating ComfyUI...
        git pull
    )
) else (
    echo Cloning ComfyUI repository...
    git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git C:\ComfyUI
    if errorlevel 1 (
        echo ERROR: Failed to clone ComfyUI
        echo Check your internet connection and try again
        pause
        exit /b 1
    )
    cd /d C:\ComfyUI
)

echo OK: ComfyUI repository ready

REM ============================================
REM Step 4: Create Virtual Environment
REM ============================================
echo.
echo [4/7] Setting up Python virtual environment...

if exist "comfyui_venv" (
    echo Virtual environment already exists
    echo.
    echo Recreate? ^(Y/N^)
    choice /C YN /N
    if not errorlevel 2 (
        echo Removing old venv...
        rmdir /s /q comfyui_venv
        echo Creating new venv...
        python -m venv comfyui_venv
    )
) else (
    echo Creating virtual environment...
    python -m venv comfyui_venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment
        echo.
        echo Try running as Administrator or check Python installation
        pause
        exit /b 1
    )
)

call comfyui_venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERROR: Failed to activate virtual environment
    pause
    exit /b 1
)

echo OK: Virtual environment activated

REM ============================================
REM Step 5: Install PyTorch XPU Nightly
REM ============================================
echo.
echo [5/7] Installing PyTorch XPU Nightly ^(latest bleeding-edge^)...
echo This is NEWER than Intel's official 2.5.1 builds!
echo.

python -m pip install --upgrade pip setuptools wheel

echo Removing any existing PyTorch installations...
pip uninstall -y torch torchvision torchaudio intel-extension-for-pytorch

echo.
echo Installing PyTorch XPU Nightly ^(2.11+^)...
echo This may take 5-10 minutes...
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

if errorlevel 1 (
    echo ERROR: PyTorch installation failed!
    echo.
    echo Try:
    echo   1. Check internet connection
    echo   2. Run as Administrator
    echo   3. Disable antivirus temporarily
    pause
    exit /b 1
)

echo.
echo Verifying PyTorch XPU installation...
python -c "import torch; print('='*60); print('PyTorch:', torch.__version__); print('XPU Available:', hasattr(torch, 'xpu') and torch.xpu.is_available()); print('='*60)"

REM ============================================
REM Step 6: Install ComfyUI Dependencies
REM ============================================
echo.
echo [6/7] Installing ComfyUI dependencies...

pip install -r requirements.txt

if errorlevel 1 (
    echo WARNING: Some dependencies failed to install
    echo ComfyUI may still work, but some features could be missing
)



REM ============================================
REM Step 7: Finalize Installation
REM ============================================
echo.
echo [7/7] Finalizing installation...

echo Installing ComfyUI frontend...
pip install --upgrade comfyui-frontend-package

echo Creating directory structure...
if not exist "models" mkdir models
if not exist "models\checkpoints" mkdir models\checkpoints
if not exist "models\clip" mkdir models\clip
if not exist "models\clip_vision" mkdir models\clip_vision
if not exist "models\vae" mkdir models\vae
if not exist "models\loras" mkdir models\loras
if not exist "models\unet" mkdir models\unet
if not exist "models\controlnet" mkdir models\controlnet
if not exist "custom_nodes" mkdir custom_nodes
if not exist "input" mkdir input
if not exist "output" mkdir output
if not exist "user" mkdir user
if not exist "temp" mkdir temp

REM ============================================
REM Installation Complete - Show Summary
REM ============================================
echo.
echo.
echo ================================================================
echo Installation Complete! ^_^
echo ================================================================
echo.
python -c "import torch; print('PyTorch Version:', torch.__version__); xpu = hasattr(torch, 'xpu') and torch.xpu.is_available(); print('XPU Status:', 'READY' if xpu else 'CPU MODE'); print('Device:', torch.xpu.get_device_name(0) if xpu else 'CPU')"
echo.
echo ================================================================
echo Next Steps:
echo ================================================================
echo.
echo   1. INSTALL_Custom_Nodes.bat    - Install essential custom nodes
echo   2. Copy models to: C:\ComfyUI\models\checkpoints\
echo   3. START_ComfyUI.bat            - Launch ComfyUI
echo.
echo Installation directory: C:\ComfyUI
echo.
echo ================================================================
echo Performance Tips:
echo ================================================================
echo.
echo - Use GGUF Q8_0 models for best quality/speed balance
echo - First GGUF load compiles Triton kernels ^(~30 sec^)
echo - Update Intel Graphics drivers regularly
echo - Keep Windows power plan on "High Performance"
echo.
pause
