# jetson-nano-containers

Jetson Nano用のDockerfileです。

主にROS関係のDockerfileを揃えています。

## Dockerfile

* L4T R32.4.3 (JetPack 4.4)
    * [ROS Dashing](./l4t-r32.4.3/ros-dashing/Dockerfile)
    * [ROS Eloquent](./l4t-r32.4.3/ros-eloquent/Dockerfile)
* L4T R32.4.4 (JetPack 4.4.1)
    * [ROS Melodic](./l4t-r32.4.4/ros-melodic/Dockerfile)


## ライセンス

このリポジトリはMITライセンスに基づいて公開されています。  
MITライセンスについては[LICENSE](./LICENSE)を確認してください。

### 謝辞

MIT Licenseで公開されている[dusty-nv/jetson-containers](https://github.com/dusty-nv/jetson-containers)をベースにしています。

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