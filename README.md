# image
画像の編集, 動画の作成等のスクリプト群

## rk-convert.rb
* 連番の画像ファイルを結合し a × b  (横a枚, 縦b枚) の画像を作成するスクリプト
  * test_rk-convert.rb: rk-convert.rb のテストスクリプト 
    * fig_test_rk-convert/: test_rk-convert.rb で用いる画像ファイル（1.png ~ 7.png）        

## append_from_dirs.rb
* 複数のディレクトリに入っている連番ファイルを順に結合し, 複数の画像を作成する (rk-convert.rbを利用)
  * (例) 異なる解像度のモデル結果の画像が4つのディレクトリ(d1~d4)に複数（時系列）入っているとすると, 
　　 $ ruby append_from_dirs.rb outdir 1 2 d1 d2 d3 d4
  
  により, d1~d4 のファイルを結合した画像が outdir に作成される. 
  このとき, seq_type=1 なので yoko=>tate の順で, 横に 2 (縦に 2 )並べた画像が作成される.

## crop_picture.sh
* 任意領域を切り出すスクリプト
  * Thanks to 鵜沼くん（鵜沼くん作成の以下のコードを改変しました https://github.com/TakashiUNUMA/UNUSH/blob/master/MANIAC/picture_tool/crop_picture.sh)

## rk-crop.rb
* 任意領域を切り出すスクリプト(crop_picture.shの改良版)

## rk-ffmpeg.rb
* ffmpegで動画を作成するスクリプト（未完）


