#!/bin/bash
export TAVILY_API_KEY=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
set -e

# 1. 生成日期变量
DATE=$(date +%Y-%m-%d)
REPO_DIR="/root/ai-daily-digest"
REPORTS_DIR="$REPO_DIR/docs/reports"
mkdir -p $REPORTS_DIR

# 2. 运行ai-daily-digest生成日报
cd /root/.openclaw/workspace-stock/skills/skills/ai-daily/scripts
python3 ai_daily.py > /tmp/ai-daily-raw.md

# 3. 清理markdown内容，只保留核心信息，去掉生成提示等冗余内容
sed -i '/^#.*生成日志/d' /tmp/ai-daily-raw.md
sed -i '/^生成时间/d' /tmp/ai-daily-raw.md
sed -i '/^.*扫描.*抓取.*筛选/d' /tmp/ai-daily-raw.md
sed -i '/^核心领域分布/d' /tmp/ai-daily-raw.md
sed -i '/^---\s*$/,/^---\s*$/d' /tmp/ai-daily-raw.md
sed -i '/^$/N;/^\n$/D' /tmp/ai-daily-raw.md

# 4. 保存到日报目录
cp /tmp/ai-daily-raw.md $REPORTS_DIR/$DATE.md

# 5. 提交到GitHub
cd $REPO_DIR
git add .
git commit -m "feat: 添加 $DATE 日报"
git push origin main

echo "✅ $DATE 日报已成功生成并上传到GitHub"
