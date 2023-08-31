# objc-format

Objective-C 代码格式化通用仓库，其他仓库一键安装并使用，不用单独配置到各自仓库中。

## Dependency

* Python 3（以下命令使用 pyenv 安装 Python 3.8.0 版本）
> * HOMEBREW_NO_AUTO_UPDATE=1 brew install -v pyenv
> * echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
> * pyenv install -v 3.8.0
> * HOMEBREW_NO_AUTO_UPDATE=1 brew install pyenv-virtualenv
> * pyenv virtualenv 3.8.0 ENV3.8.0
> * pyenv global ENV3.8.0

## Installation

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/htxs/objc-format/main/install.sh)"
```

* 注意事项1: 需要在各子库的根目录执行以上安装命令
* 注意事项2: 执行命令所在目录需要为 `git` 工程，即包含 `.git` 目录
* 注意事项3: 本工程的 `git hook` 采用 `pre-commit` + `pre-commit.d` 方式，如原工程已采用其他方式的 `pre-commit` hook，则会冲突，请酌情使用。也可联系作者沟通兼容方案。

## Usage

* 增量部分: 安装本工具后，默认开启了 `pre-commit` 钩子，提交代码时会进行代码格式化检查，对于代码格式不符合预期的文件，会拦截本次提交并给出相应提示。此时根据提示对待修改的文件进行格式化即可:
```shell
$ git commit -m 'fix: test objc format git pre-commit hook'
INFO:pre-commit:Running hook pre-commit.d/01-objc_coding_standard...
INFO:pre-commit:🚸 Format and stage individual files:
"`pwd`/.githooks/spacecommander"/format-objc-file.sh 'Dir/TestFile.m' && git add 'Dir/TestFile.m';

🚀  Format and stage all affected files:
         "`pwd`/.githooks/spacecommander"/format-objc-files.sh -s

🔴  There were formatting issues with this commit, run the👆 above👆 command to fix.
💔  Commit anyway and skip this check by running git commit --no-verify
ERROR:pre-commit:Hook pre-commit.d/01-objc_coding_standard failed. Aborting...
```

* 存量部分: 可以使用以下命令对组件库存量代码进行全局代码格式化
```shell
"`pwd`/.githooks/spacecommander"/format-objc-files-in-repo.sh
```

* 自定义哪些代码需要格式化，哪些代码不需要格式化（Carthage/ 和 Pods/ 目录会自动忽略），提供两种方式: 
> * 如果组件库根目录存在 `.formatting-directory` 文件，则仅对该文件中列出的子目录进行代码格式化（每个目录为一行）
> * 如果组件库根目录存在 `.formatting-directory-ignore` 文件，则该文件中列出的子目录下的代码不会进行代码格式化（每个目录为一行）

## Support

Make an [issue](https://github.com/htxs/objc-format/issues/new)

## Contributing

gzucm_tianjie@foxmail.com

## License

objc-format is available under the MIT license. See the LICENSE file for more info.
