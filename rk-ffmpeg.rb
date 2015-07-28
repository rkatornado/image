#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#---- 画像ファイルの入ったディレクトリから連番の画像ファイルのリンクを作成し ffmpeg で動画を作成するスクリプト
#---- ToDo
# * 出力ディレクトリの設定
# * ffmpeg bit_rate が指定方法を調査(指定できていない）

if ARGV.size <= 1 then  
  puts "Usage: $ ruby #{$0} in_fig_dir"
  puts "(e.g): $ ruby #{$0} in_fig_dir out.mpeg"
  exit
end

in_fig_dir = ARGV[0] # 入力画像の入ったディレクトリ
out_fig_dir  = "."   # 出力動画を保存するディレクトリ
#out_fig_name = "out.flv" # 出力動画名
#out_fig_name = "out.mpeg" # 出力動画名
out_fig_name = ARGV[1] # 出力動画名

out_fig = "#{out_fig_dir}/#{out_fig_name}" # 出力画像
figs = Dir.glob("#{in_fig_dir}/*.png").sort
nx = figs.size # 画像数

tmp_dir = `mktemp -d tmp.XXXXXXXXXXXXXX`.chomp # 一時ディレクトリの作成

#---- 画像ファイルの入ったディレクトリから連番の画像ファイルのリンクを作成する
for i in 0..nx-1
  fname = figs[i] 
  ext_name = File.extname(fname)
  system("ln -s #{fname} #{tmp_dir}/fig_#{"%04d"%(i+1)}#{ext_name}")
  # "renban files has been created in #{tmp_dir}"
end

# ffmpeg で動画を作成
#system("ffmpeg -i #{tmp_dir}/fig_%4d.png -s 2560x1920 #{out_fig}")
bit_rate = "300k"
#codec    = "mpeg"
#system("ffmpeg -i #{tmp_dir}/fig_%4d.png #{out_fig}")
system("ffmpeg -i #{tmp_dir}/fig_%4d.png -b:v #{bit_rate} #{out_fig}")
#system("ffmpeg -i #{tmp_dir}/fig_%4d.png -b #{bit_rate} -v #{codec} #{out_fig}")
#system("ffmpeg -i #{tmp_dir}/fig_%4d.png -qscale 0 #{out_fig}")

# 一時ディレクトリの削除
system( "rm -rf #{tmp_dir}")

if File.exists?( out_fig ) == true then
  puts "#{out_fig} has been created."
  system("open #{out_fig}")
else 
  "Failed to create a movie. "
end
