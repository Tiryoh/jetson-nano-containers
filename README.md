# jetson-nano-containers

Jetson Nano用のDockerfileです。

主にROS関係のDockerfileを揃えています。

## Dockerfile

* L4T R32.4.3 (JetPack 4.4)
    * [ROS Dashing](./l4t-r32.4.3/ros-dashing/Dockerfile)
    * [ROS Eloquent](./l4t-r32.4.3/ros-eloquent/Dockerfile)
    * [ROS Melodic](./l4t-r32.4.3/ros-melodic/Dockerfile)
* L4T R32.4.4 (JetPack 4.4.1)
    * [ROS Dashing](./l4t-r32.4.4/ros-dashing/Dockerfile)
    * [ROS Eloquent](./l4t-r32.4.4/ros-eloquent/Dockerfile)
    * [ROS Melodic](./l4t-r32.4.4/ros-melodic/Dockerfile)
        * [ros-deep-learning](./l4t-r32.4.4/ros-deep-learning-melodic/Dockefile)

## 使い方

以下の手順でこのDockerfileを使用できます。

0. [Docker実行環境の用意](#0-docker実行環境の用意)
1. [Dockerfileのダウンロード](#1-dockerfileのダウンロード)
2. [Dockerイメージのビルド](#2-dockerイメージのビルド)
3. [Dockerコンテナの起動](#3-dockerコンテナの起動)

詳細および[サンプルの実行方法](#サンプルの実行方法)は後述します。

## 0. Docker実行環境の用意

### Jetson Nano

Jetson NanoのOS、L4Tを含むJetPackにはあらかじめNVIDIAのドライバが有効になったDockerがインストールされているようです。  
以下のページによるとDockerインストール済みなのはJetPack 4.2.1以降のようです。

https://github.com/NVIDIA/nvidia-docker/wiki/NVIDIA-Container-Runtime-on-Jetson

CUDAコンパイラを扱えるようにするため、
以下のページを見ながら`/etc/docker/daemon.json`を編集し、
`docker build`時にもGPUへのアクセスを有効にします。

https://github.com/dusty-nv/jetson-containers#docker-default-runtime

### PC

CUDAに依存しない一部のDockerイメージについてはJetson Nano上ではなく、より処理能力の高いPC上でクロスビルドできます。  
クロスビルドしない場合はこの手順は不要です。

#### Dockerのインストール

PCにDockerをインストールします。

UbuntuにDockerをインストールする場合、Docker社が用意しているインストールスクリプトを使うのが簡単だと思いますので、おすすめします。

```
$ curl -SsfL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
$ sudo usermod -aG docker $(whoami)
```

以下のページに詳細があります。

https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script

その他のOSについても以下のページに記載があるようです。

https://docs.docker.com/engine/install/

#### クロスビルド用の設定

macOSの場合はそのままビルドできます。

Linuxの場合は以下のコマンドで [multiarch/qemu-user-static](https://github.com/multiarch/qemu-user-static) を使ってクロスビルドできるように設定できます。

`docker build`時や`docker run`時に`standard_init_linux.go:211: exec user process caused "exec format error"`というエラーが出た場合は、以下のコマンドを再度実行してみてください。

```
$ sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
Unable to find image 'multiarch/qemu-user-static:latest' locally
latest: Pulling from multiarch/qemu-user-static
9758c28807f2: Pull complete 
1541dc593e72: Pull complete 
ed8a5179ae11: Pull complete 
1ec39da9c97d: Pull complete 
ebb26d08461b: Pull complete 
Digest: sha256:a9944443ade713bc12ca0579c0e15a090ab43aa7a0d7b4c6883d1fbd44f6902f
Status: Downloaded newer image for multiarch/qemu-user-static:latest
Setting /usr/bin/qemu-alpha-static as binfmt interpreter for alpha
Setting /usr/bin/qemu-arm-static as binfmt interpreter for arm
Setting /usr/bin/qemu-armeb-static as binfmt interpreter for armeb
Setting /usr/bin/qemu-sparc-static as binfmt interpreter for sparc
Setting /usr/bin/qemu-sparc32plus-static as binfmt interpreter for sparc32plus
Setting /usr/bin/qemu-sparc64-static as binfmt interpreter for sparc64
Setting /usr/bin/qemu-ppc-static as binfmt interpreter for ppc
Setting /usr/bin/qemu-ppc64-static as binfmt interpreter for ppc64
Setting /usr/bin/qemu-ppc64le-static as binfmt interpreter for ppc64le
Setting /usr/bin/qemu-m68k-static as binfmt interpreter for m68k
Setting /usr/bin/qemu-mips-static as binfmt interpreter for mips
Setting /usr/bin/qemu-mipsel-static as binfmt interpreter for mipsel
Setting /usr/bin/qemu-mipsn32-static as binfmt interpreter for mipsn32
Setting /usr/bin/qemu-mipsn32el-static as binfmt interpreter for mipsn32el
Setting /usr/bin/qemu-mips64-static as binfmt interpreter for mips64
Setting /usr/bin/qemu-mips64el-static as binfmt interpreter for mips64el
Setting /usr/bin/qemu-sh4-static as binfmt interpreter for sh4
Setting /usr/bin/qemu-sh4eb-static as binfmt interpreter for sh4eb
Setting /usr/bin/qemu-s390x-static as binfmt interpreter for s390x
Setting /usr/bin/qemu-aarch64-static as binfmt interpreter for aarch64
Setting /usr/bin/qemu-aarch64_be-static as binfmt interpreter for aarch64_be
Setting /usr/bin/qemu-hppa-static as binfmt interpreter for hppa
Setting /usr/bin/qemu-riscv32-static as binfmt interpreter for riscv32
Setting /usr/bin/qemu-riscv64-static as binfmt interpreter for riscv64
Setting /usr/bin/qemu-xtensa-static as binfmt interpreter for xtensa
Setting /usr/bin/qemu-xtensaeb-static as binfmt interpreter for xtensaeb
Setting /usr/bin/qemu-microblaze-static as binfmt interpreter for microblaze
Setting /usr/bin/qemu-microblazeel-static as binfmt interpreter for microblazeel
Setting /usr/bin/qemu-or1k-static as binfmt interpreter for or1k
```

## 1. Dockerfileのダウンロード

必要なDockerfileをダウンロードするか、このGitリポジトリをまとめてダウンロードします。

```
$ git clone https://github.com/Tiryoh/jetson-nano-containers.git
```

## 2. Dockerイメージのビルド

ビルドしたいDockerfileのあるディレクトリまで移動して`docker build`します。  
例えば、JetPack 4.4.1（L4T R32.4.4）用のROS Melodicをビルドしたい場合は以下のコマンドを実行します。

```
$ cd jetson-nano-containers/l4t-r32.4.4/ros-melodic
$ sudo docker build -t ros:melodic-ros-base-l4t-r32.4.4 .
```

※`docker build`時の`-t`オプションは`--tag`のショートオプションです。

## 3. Dockerコンテナの起動

起動したいコンテナ名（ビルド時に`-t`で指定したもの）を指定して`docker run`します。

```
$ sudo docker run --rm -it ros:melodic-ros-base-l4t-r32.4.4
```

※`docker run`時の`-t`オプションは`--tty`のショートオプションです。

## サンプルの実行方法

### `ros-deep-learning:melodic-l4t-r32.4.4`を実行する例

#### ビルド

CUDAを必要とするのでJetson Nano上で実行ビルドします。  
`ros:melodic-ros-base-l4t-r32.4.4`が必要です。


`ros-deep-learning:melodic-l4t-r32.4.4`を以下のコマンドでビルドします。

```
$ cd jetson-nano-containers/l4t-r32.4.4/ros-deep-learning-melodic
$ sudo docker build -t ros-deep-learning:melodic-l4t-r32.4.4 .
```

#### コンテナの起動

##### 方法1

コンテナ起動時に直接`roslaunch`を実行する方法です。

以下のコマンドを実行します。

```
# CSIカメラを使う場合
$ sudo docker run --rm -t --network host -v /tmp/argus_socket:/tmp/argus_socket ros-deep-learning:melodic-l4t-r32.4.4 \
roslaunch ros_deep_learning video_source.ros1.launch input:=csi://0
```

```
# USBカメラを使う場合
$ sudo docker run --rm -t --network host --device /dev/video0:/dev/video0:mwr -v /tmp/argus_socket:/tmp/argus_socket ros-deep-learning:melodic-l4t-r32.4.4 \
roslaunch ros_deep_learning video_source.ros1.launch input:=v4l2:///dev/video0
```

##### 方法2

コンテナを起動し、その中でコマンドを入力する方法です。

以下のように起動したDockerコンテナの中でコマンドを実行します。

```
# CSIカメラを使う場合
$ sudo docker run --rm -it --network host -v /tmp/argus_socket:/tmp/argus_socket ros-deep-learning:melodic-l4t-r32.4.4
# コンテナ内で
$ roslaunch ros_deep_learning video_source.ros1.launch input:=csi://0
```

```
# USBカメラを使う場合
$ sudo docker run --rm -it --network host --device /dev/video0:/dev/video0:mwr -v /tmp/argus_socket:/tmp/argus_socket ros-deep-learning:melodic-l4t-r32.4.4
# コンテナ内で
$ roslaunch ros_deep_learning video_source.ros1.launch input:=v4l2:///dev/video0
```

#### 映像の確認

`roslaunch ros_deep_learning video_source.ros1.launch`を実行すると、
`/video_source/raw`と言う名前で`[sensor_msgs/Image](http://docs.ros.org/en/api/sensor_msgs/html/msg/Image.html)`形式のROSトピックが配信されます。

`rqt_image_view`でノートPC等から確認できます。

詳しくはこちらの公式資料を確認してください。

https://github.com/dusty-nv/ros_deep_learning#video_source-node

<!-- RTP で受信する場合は https://github.com/dusty-nv/jetson-inference/blob/master/docs/aux-streaming.md を参照しながら -->

## ライセンス

このリポジトリはMITライセンスに基づいて公開されています。  
MITライセンスについては[LICENSE](./LICENSE)を確認してください。

### 謝辞

MIT Licenseで公開されている[dusty-nv/jetson-containers](https://github.com/dusty-nv/jetson-containers)と[atinfinity/jetson_ros_docker](https://github.com/atinfinity/jetson_ros_docker)をベースにしています。

```
/*
 * Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
```

```
MIT License

Copyright (c) 2020 atinfinity

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```