@echo off
REM Activate the venv
cd /d C:\ComfyUI
call comfyui_venv\Scripts\activate.bat

echo ====================================
echo Installing SageAttention compatibility layer for Intel XPU
echo ====================================

REM Create the proper directory structure
cd custom_nodes
IF EXIST sageattention (
    rd /s /q sageattention
)
mkdir sageattention

REM Create a single __init__.py file with all the necessary code
echo import torch > sageattention\__init__.py
echo from torch import nn >> sageattention\__init__.py
echo. >> sageattention\__init__.py
echo class SageAttention(nn.Module): >> sageattention\__init__.py
echo     def __init__(self, *args, **kwargs): >> sageattention\__init__.py
echo         super().__init__() >> sageattention\__init__.py
echo     def forward(self, x): >> sageattention\__init__.py
echo         return x >> sageattention\__init__.py
echo. >> sageattention\__init__.py
echo def sageattn(*args, **kwargs): >> sageattention\__init__.py
echo     return None >> sageattention\__init__.py
echo. >> sageattention\__init__.py
echo class SageAttentionNode: >> sageattention\__init__.py
echo     @classmethod >> sageattention\__init__.py
echo     def INPUT_TYPES(s): >> sageattention\__init__.py
echo         return {"required": {"tensor": ("TENSOR",)}} >> sageattention\__init__.py
echo     RETURN_TYPES = ("TENSOR",) >> sageattention\__init__.py
echo     FUNCTION = "forward" >> sageattention\__init__.py
echo     CATEGORY = "advanced" >> sageattention\__init__.py
echo. >> sageattention\__init__.py
echo     def forward(self, tensor): >> sageattention\__init__.py
echo         return (tensor,) >> sageattention\__init__.py
echo. >> sageattention\__init__.py
echo NODE_CLASS_MAPPINGS = { >> sageattention\__init__.py
echo     "SageAttention": SageAttentionNode >> sageattention\__init__.py
echo } >> sageattention\__init__.py
echo. >> sageattention\__init__.py
echo print("SageAttention XPU compatibility layer loaded") >> sageattention\__init__.py

echo.
echo ====================================
echo SageAttention compatibility layer installed!
echo This allows ComfyUI to run without errors when SageAttention is requested.
echo Note: This does not provide actual SageAttention functionality.
echo ====================================
pause
