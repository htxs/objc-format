#!/usr/bin/env bash
# setup-repo.sh
# Used to configure a repo for formatting, and adds a precommit hook to check formatting.
# Copyright 2015 Square, Inc

set -ex
export CDPATH=""
# 当前脚本所在目录
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# 工程根目录
CWDBASE="$( realpath "$DIR/../" )"
pre_commit_file="$CWDBASE/.git/hooks/pre-commit"
git_hooks_path="$CWDBASE/.git/hooks"
githooks_path="$CWDBASE/.githooks"

function ensure_pre_commit_file_exists() {
  if [ -e "$pre_commit_file" ]; then
    return 0
  fi 
  # It's a symlink
  if [ -h "$pre_commit_file" ]; then
    pre_commit_file=$(readlink "$pre_commit_file")
    return 0
  fi 

  if [ -d ".git" ]; then
    $(mkdir -p "$git_hooks_path");
  elif [ -e ".git" ]; then
    # grab the git dir from our .git file, listed as 'gitdir: blah/blah/foo'
    git_dir=$(grep gitdir .git | cut -d ' ' -f 2)
    pre_commit_file="$git_dir/hooks/pre-commit"

    # Even if our git dir is in an unusual place, we still need to create the hook directory
    # if it does not already exist.
    $(mkdir -p "$git_dir/hooks");
  else
    $(mkdir -p "$git_hooks_path");
  fi

  $(touch $pre_commit_file)
}

function ensure_pre_commit_file_is_executable() {
  $(chmod +x "$pre_commit_file")
}

function ensure_hook_is_installed() {
  # copy pre-commit and pre-commit.d to .git/hooks
  local_pre_commit_file="$DIR/pre-commit"
  local_pre_commit_dir="$DIR/pre-commit.d"
  local_spacecommander_dir="$DIR/spacecommander"
  $(cp -f "$local_pre_commit_file" "$git_hooks_path")
  $(cp -Rf "$local_pre_commit_dir" "$git_hooks_path")
  $(cp -Rf "$local_spacecommander_dir" "$git_hooks_path")
}

function ensure_git_ignores_clang_format_file() {
  grep -q ".clang-format" "$CWDBASE/.gitignore"
  if [ $? -gt 0 ]; then
    echo ".clang-format" >> "$CWDBASE/.gitignore"
  fi

  grep -q ".githooks" "$CWDBASE/.gitignore"
  if [ $? -gt 0 ]; then
    echo ".githooks" >> "$CWDBASE/.gitignore"
  fi
}

function symlink_hook_clang_format() {
  source_file_path="$git_hooks_path/spacecommander/.clang-format"
  if [ -f "$source_file_path" ]; then
    $(ln -sf "$source_file_path" "$CWDBASE/.clang-format")
  fi
}

function ensure_githooks_is_installed() {
  # 优先尝试配置 git config，如果报错后，不再执行后续的复制文件
  if git config core.hooksPath .githooks >/dev/null 2>&1; then
    echo "git config core.hooksPath .githooks success."
  else
    echo "git config core.hooksPath .githooks fail."
    return 0
  fi

  # 创建目录
  $(mkdir -p "$githooks_path");

  # 拷贝 githooks 相关文件
  local_pre_commit_file="$DIR/pre-commit"
  local_pre_commit_dir="$DIR/pre-commit.d"
  local_spacecommander_dir="$DIR/spacecommander"
  $(cp -f "$local_pre_commit_file" "$githooks_path")
  $(cp -Rf "$local_pre_commit_dir" "$githooks_path")
  $(cp -Rf "$local_spacecommander_dir" "$githooks_path")
}

function symlink_githooks_clang_format() {
  source_file_path="$githooks_path/spacecommander/.clang-format"
  if [ -f "$source_file_path" ]; then
    $(ln -sf "$source_file_path" "$CWDBASE/.clang-format")
  fi
}

# sync git hooks
if (echo version 2.9.5; git --version) | sort -Vk3 | tail -1  | grep -1 git >/dev/null; then
  # git version greater than 2.9.5, use core.hooksPath.
  echo "git version ≥2.9.5, use core.hooksPath config."
  ensure_githooks_is_installed && ensure_git_ignores_clang_format_file && symlink_githooks_clang_format
else
  # git version less than 2.9.5, move to .git/hooks
  echo "git version <2.9.5, move to .git/hooks."
  ensure_pre_commit_file_exists && ensure_pre_commit_file_is_executable && ensure_hook_is_installed && ensure_git_ignores_clang_format_file && symlink_hook_clang_format
fi
