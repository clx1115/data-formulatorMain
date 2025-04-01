#!/bin/bash

# 激活虚拟环境（如果存在）
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# 设置环境变量
export $(cat .env | xargs)

# 启动应用
python -m data_formulator --port ${PORT:-5000}
