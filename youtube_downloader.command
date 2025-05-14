#!/bin/bash

echo "📥 YouTube 视频下载器 - 带中文字幕 & 音频提取"

# 读取视频链接
read -p "请输入YouTube视频链接: " VIDEO_URL

# 设置保存目录
SAVE_DIR="$HOME/Downloads/youtube"
mkdir -p "$SAVE_DIR"

# 选择只下载MP3音频或MP4视频
read -p "是否只下载MP3音频？(y/n): " AUDIO_ONLY

# 设置字幕语言
SUB_LANG="zh-Hans,en"  # 中文简体和英文字幕

# 提取 Chrome cookies
echo "🍪 正在提取浏览器 cookies..."

# 下载命令构建
echo "📦 开始下载..."

if [ "$AUDIO_ONLY" == "y" ]; then
    echo "🎵 下载 MP3 音频..."
    yt-dlp \
        --cookies-from-browser chrome \
        --extract-audio --audio-format mp3 \
        --output "$SAVE_DIR/%(title)s.%(ext)s" \
        --verbose \
        "$VIDEO_URL"
else
    echo "📄 下载视频和字幕..."
    yt-dlp \
        --cookies-from-browser chrome \
        --write-subs --write-auto-subs --embed-subs --sub-lang "$SUB_LANG" \
        --convert-subs srt \
        --merge-output-format mp4 \
        --remux-video mp4 \
        --prefer-ffmpeg \
        -f "bestvideo+bestaudio/best" \
        --output "$SAVE_DIR/%(title)s.%(ext)s" \
        --verbose \
        "$VIDEO_URL"
fi

# 检查下载结果
if [ $? -eq 0 ]; then
    echo "✅ 下载完成！文件保存在：$SAVE_DIR"

    # 显示最近下载的文件
    echo "📂 最近下载的文件："
    ls -lht "$SAVE_DIR" | head -n 5
else
    echo "❌ 下载过程中出现错误！请检查上面的错误信息。"
fi

