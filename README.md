# matrix_qq ([English](/README.en.md))

[matrix](https://matrix.org) 和 [QQ](https://im.qq.com) 的桥。

## 安装

在你的应用的 `Gemfile` 加入这行：

```ruby
gem 'matrix_qq'
```

然后运行：

    $ bundle

或者你自己安装

    $ gem install matrix_qq

## 使用

TODO: 写使用说明

注意：请确保 `matrix-dbus` 和 `cqhttp-dbus` 正在运行。

## 开发

检出这个仓库后，运行 `bin/setup` 来安装依赖关系。然后，运行 `rake spec` 来运行测试。 您还可以运行 `bin/console` 启动交互式提示符(`irb`)，让您进行实验。

要将此 gem 安装到本机上，请运行 `bundle exec rake install`。 要释出新版本，请在 `version.rb` 中更新版本号，然后运行 `bundle exec rake release`，该版本将为该版本创建一个 git 标签，并推送 git 提交和标签，然后将 `.gem` 文件提交到 [rubygems.org](https://rubygems.org)。

## 贡献

欢迎来 [GitHub](https://github.com/71e6fd52/matrix_qq) 上发起 issues 和 pull requests
