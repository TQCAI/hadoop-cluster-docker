#!/usr/bin/env python
import sys
import os
from pathlib import Path

file=sys.argv[1]
print(f'file = {file}')
target_line='# auto add env'
txt=Path(file).read_text()
lines=txt.splitlines()
if target_line in lines:
    ix=lines.index(target_line)
    lines=lines[:ix]
env_lines=Path('env.Dockerfile').read_text().splitlines()
lines=lines+[target_line]+env_lines
Path(file).write_text('\n'.join(lines))