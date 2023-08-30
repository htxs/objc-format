#!/usr/bin/env bash

# set -ex
# 当前脚本所在目录
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
tmp_githooks_zip_path="$DIR/githooks.zip"
tmp_githooks_path="$DIR/githooks"
download_file_url="https://raw.githubusercontent.com/htxs/objc-format/main/githooks.zip"

# 下载 githooks 相关文件: https://raw.githubusercontent.com/htxs/objc-format/main/githooks.zip
function ensure_down_githooks() {
  # 存在 zip 文件，则删除重新下载
  if [ -f "$tmp_githooks_zip_path" ]; then
    rm "$tmp_githooks_zip_path"
    echo "rm old zip file: $tmp_githooks_zip_path"
  fi

  # curl 下载文件
  if curl -fsSL $download_file_url -o $tmp_githooks_zip_path >/dev/null 2>&1; then
    echo "download zip file success."
  else
    echo "download zip file fail."
    exit -1
  fi
}

# 解压 githooks.zip 到当前目录
function ensure_unzip_githooks() {
  # -f 参数判断文件是否存在
  if [ -f "$tmp_githooks_zip_path" ]; then
    if unzip -qo "$tmp_githooks_zip_path" >/dev/null 2>&1; then
      echo "unzip file success."
    else
      echo "unzip file fail."
      # 退出前删除临时文件
      ensure_delete_files
      exit -1
    fi
  else
    echo "zip file not exist: $tmp_githooks_zip_path"
    exit -1
  fi
}

# 执行 githooks 目录下的 githooks 初始化脚本
function ensure_setup_githooks() {
  setup_path="$tmp_githooks_path/githooks-setup.sh"
  if bash $setup_path >/dev/null 2>&1; then
    echo "exec githooks-setup.sh success."
  else
    echo "exec githooks-setup.sh fail."
    # 退出前删除临时文件
    ensure_delete_files
    exit -1
  fi
}

# 删除临时下载的 githooks.zip 文件 以及解压后的 githooks 目录
function ensure_delete_files() {
  # -d 参数判断目录是否存在
  if [ -d "$tmp_githooks_path" ]; then
    rm -rf "$tmp_githooks_path"
    echo "rm $tmp_githooks_path"
  fi

  # -f 参数判断文件是否存在
  if [ -f "$tmp_githooks_zip_path" ]; then
    rm -f "$tmp_githooks_zip_path"
    echo "rm $tmp_githooks_zip_path"
  fi
}

# 串行执行
ensure_down_githooks && ensure_unzip_githooks && ensure_setup_githooks && ensure_delete_files

