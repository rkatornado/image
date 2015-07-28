#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#
# 任意領域を切り出すプログラム
# Producted by Takashi Unuma, Kyoto Univ.
# Modified by Ryohei Kato.
#  (copied from https://github.com/TakashiUNUMA/UNUSH/blob/master/MANIAC/picture_tool/crop_picture.sh)
# Last update: 2015/07/24
if ARGV.size <= 6 then  # 引数が少ない場合は、使用方法を表示する。
  puts "Usage: $ ruby #{$0} in_fig_dir/'*.png' out_fig_dir xsize ysize x_lt y_lt rotate [c_loc] [c_num]"
  puts "(e.g): $ ruby #{$0} f2/'*.png'           croped      900   400   50  200  30                  # for Sample" 
  puts "(e.g): $ ruby #{$0} f3/20140819_2340.png croped      440  1030  600    0  -45      -8       4 # for hiroshima gouu" 
  puts "ファイル名を基に画像の左上に文字を入力する場合, ファイル名の最後の文字(-1) から数えた文字の位置(c_loc)と文字数(c_num)を入力する"
  exit
end

in_fig       = ARGV[0] # 入力画像ファイル名
out_fig_dir = ARGV[1] # 出力画像ファイル名
xsize  = ARGV[2] # 切り出したい領域の横幅(単位: pixel)
ysize  = ARGV[3] # 切り出したい領域の縦幅(単位: pixel)
x_lt   = ARGV[4] # 切り出したい領域の左上の点の横方向の位置(単位: pixel)
y_lt   = ARGV[5] # 切り出したい領域の左上の点の縦方向の位置(単位: pixel)
rotate = ARGV[6] # 回転角(degree)
c_loc  = ARGV[7].to_i # (文字を入力する場合): ファイル名の最後の文字(-1) から数えた文字の位置
c_num  = ARGV[8].to_i # (文字を入力する場合): 文字数

# 文字を画像に描くかどうか
draw_text = false
draw_text = true if ARGV.size > 7

# 切り出したい領域の設定
  # 切り出したい領域の決定には Mac の場合 ImageJ という無料ソフトが利用可能
  # ImageJ: http://rsb.info.nih.gov/ij/
    # Measure: http://www.hm6.aitai.ne.jp/~maxcat/imageJ/menus/analyze.html#measure


files = [] # 結合する全ファイル
if File.extname( in_fig ) == ".txt" then # ファイルリストから読み込み
  files = `cat #{in_fig} | tr '\n' ' '`.chomp.split
else
  files = Dir.glob("#{in_fig}").sort 
end
puts "Input files are as follows:"
p files

# 出力ディレクトリの作成
system("mkdir -p #{out_fig_dir}") if File.exists?( out_fig_dir ) == false

n_max = files.size # 全画像数

for i in 0..n_max-1
  f = files[i]
  f_b = File.basename(f)
  out_fig_name = "crop_#{f_b}"
  out_fig = "#{out_fig_dir}/#{out_fig_name}"
  puts "Now croping #{f}"

  # 上記で設定した条件で画像を切り出す。
  system( "convert -rotate #{rotate} -crop #{xsize}x#{ysize}+#{x_lt}+#{y_lt} #{f} #{out_fig_dir}/tmp_#{f_b} ")

  if draw_text == true then
    # 切りぬいた画像に赤色で枠を付ける + 左上に文字を入力する
    time = f_b[c_loc, c_num]
    text = "'" + time + "'"
    system("convert +repage  -bordercolor red -border 2x2 -font Helvetica -pointsize 100 -gravity northwest -annotate 0x0+5+5 #{text} -fill red #{out_fig_dir}/tmp_#{f_b} #{out_fig}")
  elsif draw_text == false then #  
    # 切りぬいた画像に赤色で枠を付けるのみ。
    system("convert -bordercolor red -border 2x2 #{out_fig_dir}/tmp_#{f_b} #{out_fig}")
  end

  if File.exists?( out_fig ) == true then
    puts "#{out_fig} has been created."
  else 
    "Failed to create a figure. "
    exit
  end
end

system( "rm -rf #{out_fig_dir}/tmp_*")

puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
puts "!!  SUCCESSFUL COMPLESSION  !!"
puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
