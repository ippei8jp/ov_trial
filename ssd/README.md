# SSD実行

## 事前準備
[openVINO フルパッケージをubuntuにインストール(改訂版)](https://ippei8jp.github.io/memoBlog/2020/06/16/openVINO_ubuntu_2.html) を参考にインストールしておく。  

その他、``test.sh``内でcsvファイルを操作したいので、以下のコマンドでpandasもインストールしておくこと。  
```bash
pip install pandas 
```

動作確認した際の pythonモジュールとバージョンは [requirements.txt](requirements.txt) を参照。  

## ファイル構成

| ファイル                     | 内容                      |
|------------------------------|---------------------------|
| ov_object_detection_ssd.py   | SSD処理スクリプト本体     |
| test.sh                      | テストスクリプト          |
| _result                      | 結果格納用ディレクトリ    |
| requirements.txt             | 使用したpipモジュール一覧 |

## ``ov_object_detection_ssd.py``

SSD認識処理本体。  

USAGEは以下の通り。  

```
usage: ov_object_detection_ssd.py [-h] -m MODEL -i INPUT [--labels LABELS]
                                  [-d DEVICE] [-l CPU_EXTENSION]
                                  [-pt PROB_THRESHOLD] [--sync] [--save SAVE]
                                  [--time TIME] [--log LOG] [--no_disp]

optional arguments:
  -h, --help            Show this help message and exit.

Input Options:
  -m MODEL, --model MODEL
                        Required.
                        Path to an .xml file with a trained model.
  -i INPUT, --input INPUT
                        Required.
                        Path to a image/video file. 
                        (Specify 'cam' to work with camera)
  --labels LABELS       Optional.
                        Labels mapping file
                        Default is to change the extension of the modelfile
                        to '.labels'.
  -d DEVICE, --device DEVICE
                        Optional
                        Specify the target device to infer on; 
                        CPU, GPU, FPGA, HDDL or MYRIAD is acceptable.
                        The demo will look for a suitable plugin 
                        for device specified.
                        Default value is CPU
  -l CPU_EXTENSION, --cpu_extension CPU_EXTENSION
                        Optional.
                        Required for CPU custom layers. 
                        Absolute path to a shared library
                        with the kernels implementations.
                        以前はlibcpu_extension_avx2.so 指定が必須だったけど、
                        2020.1から不要になった

Output Options:
  --save SAVE           Optional.
                        Save result to specified file
  --time TIME           Optional.
                        Save time log to specified file
  --log LOG             Optional.
                        Save console log to specified file
  --no_disp             Optional.
                        without image display

Execution Options:
  -pt PROB_THRESHOLD, --prob_threshold PROB_THRESHOLD
                        Optional.
                        Probability threshold for detections filtering
  --sync                Optional.
                        Start in sync mode
```

## ``test.sh``

``test.sh`` を実行するとパラメータに応じた設定で ``ov_object_detection_ssd.py`` を実行する。  
オプション/パラメータは以下の通り。

```
  ./test.sh [option_model] [option_log] [model_number | list | all | allall ] [input_file]
    ---- option_model ----
      -c | --cpu : CPUを使用
      -n | --ncs : NCS2を使用
    ---- option_log ----
      -l | --log : 実行ログを保存(model_number指定時のみ有効
                       all/allall指定時は指定の有無に関わらずログを保存
      --no_disp  : 表示を省略
                       all/allall指定時は指定の有無に関わらず表示を省略
      --sync     : 同期モードで実行
                       省略時は非同期モードで実行
    input_file 省略時はデフォルトの入力ファイルを使用
```

ログを保存する場合は、``_result`` ディレクトリに以下の形式で保存される。

| ファイル            | 内容                                            |
|---------------------|-------------------------------------------------|
| «モデル名»\_(cpu\|ncs2)\_(async\|sync).log      | 認識結果                                        |
| «モデル名»\_(cpu\|ncs2)\_(async\|sync).time     | フレーム毎の処理時間                            |
| «モデル名»\_(cpu\|ncs2)\_(async\|sync).time.average     | 各処理時間の平均値                     |
| «モデル名»\_(cpu\|ncs2)\_(async\|sync).«拡張子» | 認識結果画像(入力ファイルと同じフォーマット)    |

### 注意事項  
- ログファイル名はモデル名に応じて付与されるので、同じモデルで入力ファイルを変えて実行すると上書きされる。  
- \[TODO\]その場で表示する場合は、認識時間がオリジナルのフレームレートより早い場合、  
  オリジナルのフレームレートに合わせるようにwatが入る。
  最速の認識時間が知りたい場合はｰ-no_dispで表示を省略し、--logオプションでログ保存する。  
  
