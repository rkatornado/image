#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#---- 連番の画像ファイルを結合し a × b  (横a枚, 縦b枚) の画像を作成するスクリプト
if ARGV.size <= 3 then  
  puts "Usage: $ ruby #{$0} in_fig_dir/*.png out_fig_dir/out_fig_name seq_type nx_or_ny "
  puts "       seq_type: (1) yoko => tate, (2) tate => yoko"
  puts "(e.g): $ ruby #{$0} in_fig_dir/'*.png' './all.png' 1 2"
  puts "     : (yoko=>tate), n_yoko=2, all.png will be created."
  exit
end

in_fig_dir   = ARGV[0] # 入力画像ファイル名
out_fig_name = ARGV[1] # 出力画像ファイル名
seq_type     = ARGV[2] # 画像を並べる順番: "1": yoko => tate, "2": tate => yoko
num          = ARGV[3].to_i # 横 or 縦に並べる画像の数

files = Dir.glob("#{in_fig_dir}").sort # 結合する全ファイル
puts "Input files are as follows:"
p files

p out_fig_dir = File.dirname(out_fig_name)
system("mkdir -p #{out_fig_dir}") if File.exists?( out_fig_dir ) == false

tmp_dir = `mktemp -d tmp.XXXXXXXXXXXXXX`.chomp # 一時ディレクトリの作成

ext_name = File.extname( files[0] ) # 画像ファイルの拡張子を取得
                                    # (全て同じ拡張子であることを想定して, 最初の1枚の拡張子を取得)

n_max = files.size # 全画像数

if seq_type == "1" then
  nx     = num
  nx_max = num
  ny_max = (n_max / num.to_f).ceil
  puts "(yoko => tate) #{nx_max}x#{ny_max} file will be created."
  
  n = 0; cat_files = [] # initialize
  for   j in 1..ny_max
    for i in 1..nx_max
      cat_files << files[n] # 配列の末尾に追加
      if (i == nx) or (n == n_max) then
        ff_in  = cat_files.join(" ") # join: 配列の要素を文字列 sep を間に挟んで連結した文字列を返す
        ff_out = "#{tmp_dir}/#{"%05d"%j}#{ext_name}"  # 結合する画像数は99999以下とする
        puts "appending #{j}th row"
        system("convert +append #{ff_in} #{ff_out}") # 横方向に nx 枚の画像を結合
        cat_files = [] # initialize
        break if n == n_max
      end
      n += 1
    end
  end
  
  system("convert -append #{tmp_dir}/* #{out_fig_name}") # 縦方向に ny_max 枚の画像を結合

elsif seq_type == "2" then
  nx_max = (n_max / num.to_f).ceil
  ny     = num
  ny_max = num
  puts "(tate => yoko) #{ny_max}x#{nx_max} file will be created."
  
  n = 0; cat_files = [] # initialize
  for   i in 1..nx_max
    for j in 1..ny_max
      cat_files << files[n] # 配列の末尾に追加
      if (j == ny) or (n == n_max) then
        ff_in  = cat_files.join(" ") # join: 配列の要素を文字列 sep を間に挟んで連結した文字列を返す
        ff_out = "#{tmp_dir}/#{"%05d"%i}#{ext_name}"  # 結合する画像数は99999以下とする
        puts "appending #{i}th column"
        system("convert -append #{ff_in} #{ff_out}") # 縦方向に ny 枚の画像を結合
        cat_files = [] # initialize
        break if n == n_max
      end
      n += 1
    end
  end
  
  system("convert +append #{tmp_dir}/* #{out_fig_name}") # 横方向に nx_max 枚の画像を結合

end

system( "rm -rf #{tmp_dir}")

if File.exists?( out_fig_name ) == true then
  puts "#{out_fig_name} has been created."
#  system("open #{out_fig_name}")
else 
  "Failed to create a figure. "
end
