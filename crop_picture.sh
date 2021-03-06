#!/bin/bash
#
# 任意領域を切り出すプログラム
# Producted by Takashi Unuma, Kyoto Univ.
# Modified by Ryohei Kato.
#  (copied from https://github.com/TakashiUNUMA/UNUSH/blob/master/MANIAC/picture_tool/crop_picture.sh)
# Last update: 2015/07/20

# 引数が無い場合は、使用方法を表示する。
if test $# -lt 1
then
    echo "USAGE: ./crop_picture.sh [images]"
    echo "   ex) ./crop_picture.sh fig_test_crop_picture_initial/*png"
    exit
fi

# 引数は、何個あってもOK。
inputs=$*

# 出力ディレクトリの設定
outdir="croped"

# 切り出したい領域の設定
  # 切り出したい領域の決定には Mac の場合 ImageJ という無料ソフトが利用可能
  # ImageJ: http://rsb.info.nih.gov/ij/
    # Measure: http://www.hm6.aitai.ne.jp/~maxcat/imageJ/menus/analyze.html#measure
# 切り出したい領域の横幅(単位: pixel)
#xsize=900
xsize=440

# 切り出したい領域の縦幅(単位: pixel)
#ysize=400
ysize=1030

# 切り出したい領域の左上の点の横方向の位置(単位: pixel)
#xpoint=50
xpoint=600

# 切り出したい領域の左上の点の縦方向の位置(単位: pixel)
#ypoint=200
ypoint=0

# 回転角
#rotate=30
rotate=-45
#rotate=0

# 出力形式(デフォルトでは、PNG形式で出力)
suffics=png

# 出力ディレクトリの作成
if [ ! -e $outdir ]; then 
    mkdir -p $outdir
fi

# 処理部
for input in ${inputs}
do
    infile=`basename ${input}`
    out_fig_name="croped/crop_${infile%.*}.${suffics}"
    echo "Now croping ${infile}"

    # 上記で設定した条件で画像を切り出す。
    convert -rotate ${rotate} -crop ${xsize}x${ysize}+${xpoint}+${ypoint} ${input} tmp_${infile%.*}.${suffics}

    # 切りぬいた画像に赤色で枠を付ける。
    convert -bordercolor red -border 2x2 tmp_${infile%.*}.${suffics} ${out_fig_name}

    rm -f tmp_${infile%.*}.${suffics}
done

echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!  SUCCESSFUL COMPLESSION  !!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo ""
rm -f crop_picture.sh~
