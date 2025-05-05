@echo off
echo ===== ComfyUI Installer/Updater =====

REM Check if ComfyUI is already installed
IF NOT EXIST "C:\ComfyUI" (
    REM === Original installation script ===
    REM === [OPTIONAL] Remove old ComfyUI folder for a clean install ===
    REM rmdir /s /q C:\ComfyUI

    REM 1. Clone the latest version of ComfyUI
    git clone https://github.com/comfyanonymous/ComfyUI.git C:\ComfyUI

    REM 2. Go to ComfyUI folder
    cd /d C:\ComfyUI

    REM 3. Create an isolated Python venv
    python -m venv comfyui_venv

    REM 4. Activate the venv
    call comfyui_venv\Scripts\activate.bat

    REM 5. Update pip
    python -m pip install --upgrade pip

    REM 6. Install base dependencies
    pip install -r requirements.txt

    REM 7. Uninstall any previous torch version
    pip uninstall -y torch torchvision torchaudio

    REM 8. Install Intel Arc optimized torch (XPU)
    pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

    REM 9. Update ComfyUI frontend to the latest official version (optional)
    pip install --upgrade comfyui-frontend-package

    REM 10. Check installed torch version (should display +xpu)
    python -c "import torch; print('Torch version:', torch.__version__)"

    echo.
    echo ==========================
    echo Installation complete!
    echo If torch version shows +xpu, you're ready to go.
    echo You can now launch ComfyUI with the startup batch.
    echo ==========================
) ELSE (
    REM === Update script ===
    echo ComfyUI is already installed. Updating...
    
    REM 1. Go to ComfyUI folder
    cd /d C:\ComfyUI

    REM 2. Activate the venv
    call comfyui_venv\Scripts\activate.bat

    REM 3. Pull the latest changes from GitHub
    echo Updating ComfyUI core...
    git pull

    REM 4. Update pip
    echo Updating pip...
    python -m pip install --upgrade pip

    REM 5. Update dependencies
    echo Updating dependencies...
    pip install -r requirements.txt

    REM 6. Update torch (keeping Intel XPU version)
    echo Updating PyTorch...
    pip install --upgrade --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

    REM 7. Update frontend to latest version
    echo Updating ComfyUI frontend...
    pip install --upgrade comfyui-frontend-package

    REM 8. Check torch version
    echo Checking torch version...
    python -c "import torch; print('Torch version:', torch.__version__)"

    echo.
    echo ==========================
    echo Update complete!
    echo If torch version shows +xpu, you're ready to go.
    echo ==========================
)

pause