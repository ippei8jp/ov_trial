#!/bin/bash

#### ディレクトリ #############################################################
# ダウンロードツールのあるディレクトリ
DOWNLOADER_DIR=${INTEL_OPENVINO_DIR}/deployment_tools/tools/model_downloader

# モデルをダウンロードするディレクトリ
MODELS_BASE_DIR=`pwd`/_models
IR_BASE_DIR=`pwd`/_IR

#### 各モデル名称と #####################################
# 使用できるモデル一覧は以下を実行して取得
# ${DOWNLOADER_DIR}/downloader.py  --print_all
declare -a model_names=()              	# モデル名
model_names+=('mobilenet-ssd')
model_names+=('ssd300')
model_names+=('ssd512')
model_names+=('ssd_mobilenet_v1_coco')
model_names+=('ssd_mobilenet_v1_fpn_coco')
model_names+=('ssd_mobilenet_v2_coco')
model_names+=('ssdlite_mobilenet_v2')

for ix in ${!model_names[@]}; do
	modelname=${model_names[ix]}
	${DOWNLOADER_DIR}/downloader.py \
	    --name ${modelname} \
	    --output_dir   ${MODELS_BASE_DIR}
	
	${DOWNLOADER_DIR}/converter.py \
	    --precisions FP16 \
	    --name ${modelname} \
	    --download_dir ${MODELS_BASE_DIR} \
	    --output_dir ${IR_BASE_DIR}
done

# ラベルデータファイルの作成
# 本来ならprotobuffで読み込んでごちょごちょやるべきだが、
# とりあえずIDに抜けがなければこんな姑息な手段で変換できる。
# mscoco
wget -O - https://raw.githubusercontent.com/tensorflow/models/master/research/object_detection/data/mscoco_complete_label_map.pbtxt \
	| grep display_name | sed -e "s/^.*\"\(.*\)\".*$/\1/g" >  ${IR_BASE_DIR}/mscoco_complete_label_map.labels
# voc
wget -O - https://raw.githubusercontent.com/weiliu89/caffe/ssd/data/VOC0712/labelmap_voc.prototxt \
	| grep display_name | sed -e "s/^.*\"\(.*\)\".*$/\1/g" >  ${IR_BASE_DIR}/voc_label_map.labels


# protoファイル作ってprotocでpyに変換したモジュールをimportして、、、という方法をとるらしい...
