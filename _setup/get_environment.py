#basic python code to get information on the python environment

import sys
import os
import platform

print("=== Python Environment Details ===")
print(f"Python Version:          {sys.version}")
print(f"Python Executable:       {sys.executable}")
print(f"Platform:                {platform.platform()}")
print(f"OS:                      {os.name} / {platform.system()} {platform.release()}")
print(f"Current Working Directory: {os.getcwd()}")
print(f"sys.prefix (venv/base):  {sys.prefix}")
print(f"sys.base_prefix:         {getattr(sys, 'base_prefix', 'N/A')}")
print(f"Is Virtual Environment?: {sys.prefix != getattr(sys, 'base_prefix', sys.prefix)}")