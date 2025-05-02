@echo off
REM === [OPTIONAL] Delete old ComfyUI folder for a clean install ===
REM rmdir /s /q C:\ComfyUI

REM 1. Clone the latest ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git C:\ComfyUI

REM 2. Go to the ComfyUI directory
cd /d C:\ComfyUI

REM 3. Create an isolated Python venv
python -m venv comfyui_venv

REM 4. Activate the venv
call comfyui_venv\Scripts\activate.bat

REM 5. Upgrade pip
python -m pip install --upgrade pip

REM 6. Install base dependencies
pip install -r requirements.txt

REM 7. Uninstall any previous torch
pip uninstall -y torch torchvision torchaudio

REM 8. Install Intel Arc (XPU) optimized torch
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

REM 9. Upgrade to the latest official ComfyUI frontend
pip install --upgrade comfyui-frontend-package

REM 10. Show torch version for confirmation
python -c "import torch; print('Torch version:', torch.__version__)"

echo.
echo ==========================
echo Installation complete!
echo If you see Torch version ...+xpu, you are ready.
echo You can now launch ComfyUI with the start batch file.
echo ==========================
pause
