# Exam 01

## ゴール

Vagrant を利用して VM を構築し、app ディレクトリにある index.html をローカル環境でブラウザアクセスが可能な Web アプリケーションとして動作させる.

## 要件

### VM

- 同梱の Vagrantfile を利用する
- VM の OS ディストリビューション、バージョンは変更しない

### ネットワーク、ストレージ

**ネットワーク/ストレージの設定は Vagrant が用意する方法を用いて行ってください**

- ブラウザから Web アプリケーションへのアクセスは http://localhost:5001 で行う
- app ディレクトリが VM にマウントされ、index.html への変更がリアルタイムに反映される

### ミドルウェア

- Web サーバーには Apache を利用する
- Web サーバーはポート 8080 で Listen する

### その他

- VM のプロビジョニング手順をシェルスクリプトとしてまとめる
- VM 作成時に上記シェルスクリプトによって要件を満たす環境が構築されるようにする

## 手順

いきなりプロビジョニングのシェルスクリプトを書いても構いません.

まずは手作業で VM の構築をしたい場合は

```
$ cd /path/to/exam/01
$ vagrant up
```

で VM を作成し、

```
$ vagrant ssh
```

した上で作業が可能です.

VM を完全に破棄する場合は

```
$ vagrant destroy
```

で可能です.