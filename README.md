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

## Support

Make an [issue](https://github.com/htxs/objc-format/issues/new)

## Contributing

gzucm_tianjie@foxmail.com

## License

objc-format is available under the MIT license. See the LICENSE file for more info.
