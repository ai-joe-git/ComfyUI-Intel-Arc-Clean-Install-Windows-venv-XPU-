@echo off
title Updating ComfyUI

echo ================================================================
echo ComfyUI Update Script
echo ================================================================
echo.
echo This will update:
echo   - ComfyUI core
echo   - PyTorch XPU Nightly
echo   - Triton XPU
echo   - Custom nodes
echo   - Python dependencies
echo.
pause

cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

echo.
echo [1/5] Updating ComfyUI core...
git pull
if errorlevel 1 (
    echo WARNING: Git pull failed - may have local changes
)

echo.
echo [2/5] Updating PyTorch XPU Nightly...
pip install --upgrade --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

echo.
echo [3/5] Updating Triton XPU...
pip install --upgrade pytorch-triton-xpu

echo.
echo [4/5] Updating Python dependencies...
pip install --upgrade pip
pip install -r requirements.txt

echo.
echo [5/5] Updating custom nodes...
cd custom_nodes
for /d %%i in (*) do (
    if exist "%%i\.git" (
        echo Updating %%i...
        cd %%i
        git pull
        if exist "requirements.txt" pip install -r requirements.txt
        cd ..
    )
)

cd ..

echo.
echo ================================================================
echo Update Complete!
echo ================================================================
echo.
echo Verifying PyTorch XPU...
python -c "import torch; print('PyTorch:', torch.__version__); print('XPU:', torch.xpu.is_available() if hasattr(torch, 'xpu') else False)"
echo.
echo Run START_ComfyUI.bat to launch
echo ================================================================
pause
