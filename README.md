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
    The authenticity of host 'raspineko.local (fe80::ba27:ebff:fecd:6f26%en0)' can't be established.
    ECDSA key fingerprint is SHA256:VoQc32UNxU2JlB34zyW6akm67acZC1PyDgKrmu+kkSM.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'raspineko.local,fe80::ba27:ebff:fecd:6f26%en0' (ECDSA) to the list of known hosts.
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
