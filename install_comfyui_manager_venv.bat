@echo off
REM Activate the venv
cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

REM Go to custom_nodes directory
cd custom_nodes

REM Clone ComfyUI-Manager (if not already present)
IF NOT EXIST comfyui-manager (
    git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
) ELSE (
    echo comfyui-manager already exists, skipping clone.
)

REM Install ComfyUI-Manager dependencies
pip install -r comfyui-manager\requirements.txt

echo.
echo ==========================
echo ComfyUI Manager installed!
echo Restart ComfyUI to enable the Manager.
echo ==========================
pause
