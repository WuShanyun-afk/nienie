# 捏捏乐

二十只可以捏的小东西。点一下（手机上按住）它会扁一下，还会叫一声。

**网页：<https://wushanyun-afk.github.io/nienie/>**

| 文件 | 名字 | 特点 |
|---|---|---|
| `koala.html` | 考拉捏捏乐 | 咕咕 · 颜文字 |
| `chick.html` | 小鸡捏捏乐 | 跳一下 · 扇翅膀 |
| `chickcook.html` | 小鸡厨师 | 围着刀叉 · 咕咕 |
| `orca.html` | 虎鲸捏捏乐 | 海洋世界 · 爱心 · 哨音 |
| `whale.html` | 鲸鱼捏捏乐 | 喷水 · 浅灰蓝 |
| `seal.html` | 小海豹捏捏乐 | duang |
| `octopus.html` | 章鱼捏捏乐 | 喷墨 · 变色 |
| `penguin8.html` | 企鹅捏捏乐 | 全身弹 |
| `loprabbit.html` | 垂耳兔捏捏乐 | 耳朵会晃 |
| `cornerbunny.html` | 角落白兔捏捏乐 | 摸肚皮 |
| `blackrabbit.html` | 小黑猫捏捏乐 | 白眼睛 |
| `creamcat.html` | 奶油猫捏捏乐 | 唧唧 |
| `kitty.html` | 白团子 | 软 |
| `hamster.html` | 仓鼠捏捏乐 | 鼓鼓的 |
| `panda.html` | 熊猫捏捏乐 | 黑眼圈 |
| `dog.html` | 捏捏小狗 | 垂耳 |
| `frog.html` | 青蛙捏捏乐 | 咕 |
| `pig-game.html` | 小猪捏捏乐 | 粉 |
| `whitemint.html` | 薄荷奶绿 | 凉凉的 |
| `shenshuwan.html` | 沈舒晚 | 我自己 |

`index.html` 是首页，手机上可以「添加到主屏幕」。

## 图

首页底下那一栏，是三张透明 PNG（1600×1600），点开就是原图。

| 文件 | 名字 |
|---|---|
| `img/koala1.png` | 考拉 |
| `img/chick1.png` | 小鸡 |
| `img/chickcook1.png` | 小鸡厨师 |

## 怎么做的

每一只都是一个单独的 HTML 文件：图形是内联 SVG，声音是 Web Audio 现场合成的，没有图片、没有外部依赖，复制到哪儿都不会白屏，断网也能开。

## 更新

在电脑上双击 `发布.bat`，它会做两件事：

1. 把 `捏捏乐合集\` 里所有 HTML 同步过来；
2. 把 `沈舒晚绘制的图\` 里的 `koala1.png`、`chick1.png`、`chickcook1.png` 同步到 `img\`（要换图或加图，改 `tools\publish.ps1` 里的 `$pics` 那一行）。

然后自动推上去，GitHub Pages 一两分钟后更新。
