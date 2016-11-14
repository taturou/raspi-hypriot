# はじめに

これは、Raspberry Pi 3に[Hypriot](http://blog.hypriot.com/)をインストールする手順をまとめたのです。

# 環境

## ホスト

OS X El Capitan (version 10.11.6)

## ターゲット

Raspberry Pi 3 Model B ((Element14版)

# 参照

* [Hypriot公式サイト](http://blog.hypriot.com/)
* [flashコマンドのReadme](https://github.com/hypriot/flash)
* [Raspberry PiでもDocker。Hypriotレビュー - さくらのナレッジ](http://knowledge.sakura.ad.jp/knowledge/5418/)

# インストール

1. [Hyporiotのダウンロードページ](http://blog.hypriot.com/downloads/)から、最新のOSイメージをダウンロード

    2016-11-11時点での最新は:
    * Description: Version 1.1.0
    * Download Link: https://github.com/hypriot/image-builder-rpi/releases/download/v1.1.0/hypriotos-rpi-v1.1.0.img.zip
    * Published: 2016-10-12

    だったので:

    ```bash
    osx$ wget https://github.com/hypriot/image-builder-rpi/releases/download/v1.1.0/hypriotos-rpi-v1.1.0.img.zip
    osx$ unzip hypriotos-rpi-v1.1.0.img.zip
    ```
    
    結構時間かかる。11分かかった
    
    `curl -O` だと何故かダウンロードできなかった。

2. flashコマンドのインストール

    [github.com/hypriot/flash/Readme.md](https://github.com/hypriot/flash) を参考にインストール
    
    ```bash
    osx$ curl -O https://raw.githubusercontent.com/hypriot/flash/master/$(uname -s)/flash
    osx$ chmod +x flash
    ```
3. flashコマンドの実行に必要らしいパッケージをインストール

    これも、[github.com/hypriot/flash/Readme.md](https://github.com/hypriot/flash) に書いてあったので。
    
    ```bash
    osx$ brew install pv
    osx$ brew install awscli
    ```
    
4. device-init.yaml 作成

    ホスト名と無線LANの設定を行う。
    HypriotはAvahi動いてるので、OS XからならIPアドレス分からなくても `{hostname}.local` でアクセスできる。

    ```bash
    osx$ cat ./device-init.yaml
    hostname: black-pearl
    wifi:
      interfaces:
        wlan0:
          ssid: "MyNetwork"
          password: "secret_password"
    ```

5. 今の状況

    ```bash
    osx$ ls
    device-init.yaml
    flash*
    hypriotos-rpi-v1.1.0.img
    hypriotos-rpi-v1.1.0.img.zip
    ```

6. microSDHCカードを初期化する

    探しやすいように初期化する。
    SDA公式の「SD Formatter Version4.0」で、ボリュームラベルを "RECOVERY" としてクイックフォーマット

7. microSDHCカードのデバイス名を取得する

    ```bssh
    osx$ diskutil list
    ...(略)...
    /dev/disk4 (internal, physical):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:     FDisk_partition_scheme                        *15.7 GB    disk4
       1:             Windows_FAT_32 RECOVERY                15.7 GB    disk4s1
    ```
    
    ということで、`/dev/disk4` だった。

8. インストール

    ```bash
    osx$ ./flash --config device-init.yaml hypriotos-rpi-v1.1.0.img
    Filesystem                                                Size   Used  Avail Capacity   iused    ifree %iused  Mounted on
    /dev/disk1                                               699Gi  597Gi  102Gi    86% 156508969 26607957   85%   /
    devfs                                                    191Ki  191Ki    0Bi   100%       662        0  100%   /dev
    map -hosts                                                 0Bi    0Bi    0Bi   100%         0        0  100%   /net
    map auto_home                                              0Bi    0Bi    0Bi   100%         0        0  100%   /home
    /dev/disk4s1                                              15Gi  2.4Mi   15Gi     1%         0        0  100%   /Volumes/RECOVERY

    Is /dev/disk4 correct? yes
    Unmounting disk4 ...
    Unmount of all volumes on disk4 was successful
    Unmount of all volumes on disk4 was successful
    Flashing hypriotos-rpi-v1.1.0.img to disk4 ...
    Password:****
    1000MiB 0:01:37 [10.2MiB/s] [=================================================================================================================================================================>] 100%            
    0+16000 records in
    0+16000 records out
    1048576000 bytes transferred in 97.809171 secs (10720631 bytes/sec)
    Copying device-init.yaml to /Volumes/HypriotOS/device-init.yaml ...
    Unmounting and ejecting disk4 ...
    Unmount of all volumes on disk4 was successful
    Unmount of all volumes on disk4 was successful
    Disk /dev/disk4 ejected
    🍺  Finished.
    ```
    
    最後の '🍺  Finished.' がいい感じ♪

9. Raspberry Pi起動

    microSDHCカードをRaspberry Piに挿して起動する
    起動確認は、とりあえず ping で。
    
    ```bash
    osx$ ping black-pearl.local
    ```
    
    35秒ほどで起動て ping が通るようになった。

10. sshで接続
    
    * username: pirate
    * password: hypriot
    
    ```bash
    osx$ ssh pirate@black-pearl.local
    The authenticity of host 'black-pearl.local (fe80::ba27:ebff:fecd:6f26%en0)' can't be established.
    ECDSA key fingerprint is SHA256:VoQc32UNxU2JlB34zyW6akm67acZC1PyDgKrmu+kkSM.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'black-pearl.local,fe80::ba27:ebff:fecd:6f26%en0' (ECDSA) to the list of known hosts.
    pirate@black-pearl.local's password:
  
    HypriotOS (Debian GNU/Linux 8)
  
    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.
  
    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    -bash: warning: setlocale: LC_ALL: cannot change locale (ja_JP.UTF-8)
    -bash: warning: setlocale: LC_ALL: cannot change locale (ja_JP.UTF-8)
    HypriotOS/armv7: pirate@black-pearl in ~
    $ 
    ```

# デフォルトでインストール済みのコマンド

## docker関連

* docker
* docker-containerd
* docker-containerd-shim
* docker-proxy
* dockerd                 
* docker-compose
* docker-containerd-ctr
* docker-machine
* docker-runc             

### docker

```bash
raspi$ docker -v
Docker version 1.12.2, build bb80604
```

### docker-compose

```bash
raspi$ docker-compose -v
docker-compose version 1.8.1, build 878cff1 
```

## その他

### apt

```bash
raspi$ apt --version
apt 1.0.9.8.3 for armhf compiled on Apr  2 2016 16:38:14
```

### git

```bash
raspi$ git --version
git version 2.1.4
```

# 固定IPアドレスを設定する

諸事情により、IPアドレスを:

* 無線LANはDHCPで取得
* 有線LANは固定IPに設定

したい。
HypriotはRasbianベースなので、その辺の知識が使えます。

```bash
raspi$ cat /etc/network/interfaces.d/eth0 
allow-hotplug eth0
iface eth0 inet dhcp
```

以下のように修正

```bash
raspi$ cat /etc/network/interfaces.d/eth0 
allow-hotplug eth0
#iface eth0 inet dhcp
iface eth0 inet static
address 192.168.40.103
network 192.168.40.0
netmask 255.255.255.0
broadcast 192.168.40.255
gateway 192.168.40.1
dns-nameservers 8.8.8.8
dns-search ESOL.CO.JP
```

ただ、この設定だと `/etc/resolv.conf` が変更されない。なぜ？
しょうがないから直接設定。

```bash
$ cat /etc/resolv.conf
nameserver 8.8.8.8
search ESOL.CO.JP
```

# DockerUIでdockerの状態を見る

DockerUI、マジハンパネー！
てことで。

やり方は [dockerhub/hypriot/rpi-dockerui](https://hub.docker.com/r/hypriot/rpi-dockerui/) を見れば説明いらず

```bash
raspi $ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock hypriot/rpi-dockerui
Unable to find image 'hypriot/rpi-dockerui:latest' locally
latest: Pulling from hypriot/rpi-dockerui
f550508d4a51: Pull complete 
a3ed95caeb02: Pull complete 
Digest: sha256:6e245629d222e15e648bfc054b9eb24ac253b1f607d3dd513491dd9d5d272cfb
Status: Downloaded newer image for hypriot/rpi-dockerui:latest
a8892553dc86870856e49679ac4d0d3d0e522154183d9e534f5e8fd5fdc7e721
```

いやぁ、dockerの時代に生まれてよかった。

# itamae をインストールする

itamae、必要ですよね。
Hypriotにはrubyが入っていないので、まずはそこからです。

1. localeを設定する

    デフォルトのままだと、perlがwarningを吐くので、localeを ja_JP.UTF-8 に設定する
    なんでperlの話をするかというと、`apt-get install` でperlが走るから。

    ```bash
    raspi$ sudo locale-gen ja_JP.UTF-8
    Generating locales (this might take a while)...
      en_US.UTF-8... done
    Generation complete.
    HypriotOS/armv7: pirate@raspiNeko in ~ on master*
    raspi$ sudo dpkg-reconfigure locales
    ...(略)...ここで ja_JP.UTF-8 を選択する。
    Generating locales (this might take a while)...
      en_US.UTF-8... done
      ja_JP.UTF-8... done
    Generation complete.
```

2. rubyをインストールする

    ```bash
    raspi$ sudo apt-get update
    raspi$ sudo apt-get install -y ruby
    ...(略)...
    raspi$ ruby -v
    ruby 2.1.5p273 (2014-11-13) [arm-linux-gnueabihf]
    ```

3. itamaeをインストールする

    ```bash
    raspi$ sudo gem install itamae
    ...(略)...
    raspi$ $ itamae version
    Itamae v1.9.9
    ```
