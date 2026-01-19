@echo off
title Installing ComfyUI Custom Nodes

echo ================================================================
echo ComfyUI Custom Nodes Installer
echo ================================================================
echo.
echo This will install essential custom nodes:
echo   - ComfyUI-Manager (node management)
echo   - ComfyUI-GGUF (quantized models)
echo   - ComfyUI-VideoHelperSuite (video tools)
echo   - ComfyUI-Impact-Pack (utilities)
echo   - rgthree-comfy (workflow tools)
echo.
pause

cd /d C:\ComfyUI\custom_nodes
call ..\comfyui_venv\Scripts\activate.bat

echo.
echo [1/5] Installing ComfyUI-Manager...
if not exist "ComfyUI-Manager" (
    git clone https://github.com/ltdrdata/ComfyUI-Manager
    cd ComfyUI-Manager
    if exist requirements.txt pip install -r requirements.txt
    cd ..
) else (
    echo Already installed, updating...
    cd ComfyUI-Manager
    git pull
    if exist requirements.txt pip install -r requirements.txt
    cd ..
)

echo.
echo [2/5] Installing ComfyUI-GGUF...
if not exist "ComfyUI-GGUF" (
    git clone https://github.com/city96/ComfyUI-GGUF
) else (
    echo Already installed, updating...
    cd ComfyUI-GGUF
    git pull
    cd ..
)

echo.
echo [3/5] Installing ComfyUI-VideoHelperSuite...
if not exist "ComfyUI-VideoHelperSuite" (
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
    cd ComfyUI-VideoHelperSuite
    if exist requirements.txt pip install -r requirements.txt
    cd ..
) else (
    echo Already installed, updating...
    cd ComfyUI-VideoHelperSuite
    git pull
    if exist requirements.txt pip install -r requirements.txt
    cd ..
)

echo.
echo [4/5] Installing ComfyUI-Impact-Pack...
if not exist "ComfyUI-Impact-Pack" (
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack
    cd ComfyUI-Impact-Pack
    if exist requirements.txt pip install -r requirements.txt
    cd ..
) else (
    echo Already installed, updating...
    cd ComfyUI-Impact-Pack
    git pull
    if exist requirements.txt pip install -r requirements.txt
    cd ..
)

echo.
echo [5/5] Installing rgthree-comfy...
if not exist "rgthree-comfy" (
    git clone https://github.com/rgthree/rgthree-comfy
) else (
    echo Already installed, updating...
    cd rgthree-comfy
    git pull
    cd ..
)

echo.
echo ================================================================
echo Custom Nodes Installation Complete!
echo ================================================================
echo.
echo Next: Run INSTALL_GGUF_Triton_Patch.bat for GGUF acceleration
echo ================================================================
pause
