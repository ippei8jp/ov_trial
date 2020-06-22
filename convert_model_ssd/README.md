# SSD 事前学習モデルをダウンロードし、IR形式に変換する

opneVINO の ``model_downloader``でインターネット上に公開されている事前学習済みモデルをダウンロードし、 openVINOの入力形式であるIR形式に変換する。

ちなみに、変換パラメータは、``/opt/intel/openvino/deployment_tools/open_model_zoo/models``ディレクトリにまとめられている。

# 事前準備

## openVINOのインストール

[openVINO フルパッケージをubuntuにインストール(改訂版)](https://ippei8jp.github.io/memoBlog/2020/06/16/openVINO_ubuntu_2.html) を参考にopenVINOをインストールする。

これを含め、動作確認した際の pythonモジュールとバージョンは [requirements.txt](requirements.txt) を参照。

# IRファイルへの変換

モデルファイルは あらかじめ ``download_models`` ディレクトリでダウンロードしておく。  
``mk_tflte_ssd.sh`` を実行すると、``_frozen`` ディレクトリに frozen model をexportし、  
さらに ``_tflite`` ディレクトリにtfliteファイルを出力する。  

最終的に生成されるファイルは以下の通り。  
| ファイル名                                         | 内容                                              |
|-----------------------------------------------|------------------------------|
| _models/\*/«モデル名»/\*                      | ダウンロードしたモデル       |
| _IR/\*/«モデル名»/«モデル名»/\*/«モデル名».*  | IRモデルファイル             |
| _IR/*.labels                                  | ラベルファイル               |

# 参考  

[openVINO でSSD(その2)](https://ippei8jp.github.io/memoBlog/2019/12/18/openVINO_SSD_2.html)  

