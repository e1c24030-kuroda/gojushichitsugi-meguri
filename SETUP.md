# セットアップ手順

開発環境を自分のパソコンに用意して、アプリを動かせるようになるまでの手順です。

## 1. 必要なもの

| もの | 用途 | 必須？ |
| --- | --- | --- |
| Git | コードのダウンロード・共有 | 必須 |
| Flutter SDK **3.47.5 以上**（Dart 3.13.4 以上） | アプリのビルド・実行 | 必須 |
| Google Chrome | ブラウザでアプリを確認する | 必須 |
| VSCode ＋ 拡張機能「Flutter」 | コードの編集 | 任意 |
| Xcode | iPhone で動かす（Mac のみ） | 任意 |
| Android Studio | Android で動かす | 任意 |

> Flutter のバージョンが古いと、`flutter pub get` のときにエラーになります（手順 6 を参照）。

## 2. Git を入れる

- **Mac**: ターミナルで `git --version` を実行します。入っていなければインストールするか聞かれるので、「インストール」を押します。
- **Windows**: https://git-scm.com/ からダウンロードしてインストールします。

## 3. Flutter を入れる

公式の手順に沿ってインストールします: https://docs.flutter.dev/get-started/install

- **Mac（Homebrew を使っている場合）**:

  ```bash
  brew install --cask flutter
  ```

- **Windows**: 公式ページから zip をダウンロードして展開し、`flutter\bin` にパスを通します（公式手順に書いてあります）。

インストールできたら、次のコマンドで確認します。

```bash
flutter --version   # 3.47.5 以上であれば OK
flutter doctor      # 足りないものがあれば教えてくれる
```

`flutter doctor` で「Chrome」に ✓ が付いていれば、ブラウザでの確認はできます。
Xcode や Android Studio の ✗ は、スマホで動かさないなら気にしなくて大丈夫です。

## 4. コードをダウンロードする

リポジトリ: https://github.com/gojunanatsugi-meguri/gojushichitsugi-meguri

リポジトリが非公開の場合は、GitHub アカウント名をメンバーに伝えて、Organization に招待してもらってください。

```bash
git clone https://github.com/gojunanatsugi-meguri/gojushichitsugi-meguri.git
cd gojushichitsugi-meguri
```

## 5. アプリを動かす

```bash
flutter pub get          # 使っているパッケージをダウンロード（最初の1回と、pubspec.yaml が変わったとき）
flutter run -d chrome    # Chrome でアプリが開く
```

Chrome が自動で開いて、アプリが表示されれば成功です。

### 動かしている間の操作

`flutter run` を実行したターミナルで、次のキーを押します。

| キー | 動作 |
| --- | --- |
| `r` | コードの変更を画面に反映（ホットリロード） |
| `R` | アプリを最初から起動し直す |
| `q` | 終了 |

### スマホの大きさで見る

このアプリはスマホ向けです。Chrome で右クリック →「検証」→ 左上のスマホのアイコンを押すと、スマホの画面サイズで確認できます。

### スマホ・シミュレーターで動かす

```bash
flutter devices   # 使える端末の一覧
flutter run       # 接続中の実機・起動中のシミュレーターで起動
```

- iPhone で動かすには Mac と Xcode が必要です。
- Android で動かすには Android Studio（Android SDK）が必要です。
- QR 読み取りのカメラは、ブラウザでは動かないことがあります。その場合は、お店を手動で選ぶデモ操作で流れを確認できます。

## 6. うまくいかないとき

| 症状 | 対処 |
| --- | --- |
| `flutter pub get` で「The current Dart SDK version is ...」と出る | Flutter が古いです。`flutter upgrade` を実行します |
| `flutter: command not found` | Flutter のパスが通っていません。手順 3 の公式手順を見直して、ターミナルを開き直します |
| `flutter run -d chrome` で「No devices found」と出る | Chrome をインストールします。それでも出る場合は `flutter doctor` を確認します |
| 画面の一部の文字が □ になる | 日本語フォントが足りていません（既知の問題です） |

## コードの場所

| 場所 | 中身 |
| --- | --- |
| `lib/main.dart` | アプリの入口 |
| `lib/theme.dart` | 色や文字などの見た目の設定 |
| `lib/models/app_state.dart` | データとアプリの状態（スポット、クイズ、クーポン、位の名前・必要な距離など） |
| `lib/screens/` | 各画面（スタンプ帳、QR 読取、クイズ、クーポン、地図） |
| `pubspec.yaml` | 使っているパッケージの一覧 |

## チームでの作業の流れ

1. 作業を始める前に、最新のコードを取ってきます。

   ```bash
   git pull
   ```

2. 変更したら、保存してコミットし、GitHub に送ります。

   ```bash
   git add .
   git commit -m "変更内容を短く書く"
   git push
   ```

3. 他の人が `pubspec.yaml` を変えていたら、`git pull` のあとに `flutter pub get` を実行します。
