# My Personal Emacs Configuration

## 说明

以前使用过 Emacs 一段时间，采用过两种方式：
1. 基于 Spacemacs 配置框架
2. 配置文件全部自己编写

这两种方式都有很多问题，包括配置、管理等方面，主要还是对 Elisp 和 Spacemacs 的包管理机制不甚明了，网上的博客不够系统，所以后来还是放弃了。

最近通过研究 Survat Apte 在 Medium 网站上的 Emacs 配置博客系列，基本对 Emacs 的配置方法和管理思路有了较清晰的认识，重新拾起 Emacs 作为自己的日程安排和知识管理。

## 配置文件

第一次提交包含几个文件
1. init.el
2. org-config.el
3. custom-file.el

## 使用方法

1. 安装 Emacs
2. Delete `~/.emacs` or `~/.emacs.d`, if you already have it.
3. Run `git clone https://github.com/hehao9504/hehao_emacs.d.git ~/.emacs.d`
4. Open Emacs, it will download all the packages. (Ignore the warnings on the first launch.)
5. Start using it!
