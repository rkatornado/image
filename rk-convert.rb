#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#---- 画像ファイルを結合する
if ARGV.size <= 3 then  
  puts "Usage: $ ruby #{$0} in_fig_dir out_fig_name seq_type nx_or_ny "
  puts "       seq_type: (1) yoko => tate, (2) tate => yoko"
  puts "(e.g): $ ruby #{$0} in_fig_dir all 1 2"
  puts "     : (yoko=>tate), n_yoko=2, all.extname will be created."
  exit
end

in_fig_dir   = ARGV[0] # 入力画像ファイルが入ったディレクトリ
out_fig_name = ARGV[1] # 出力画像名（拡張子なし）
seq_type     = ARGV[2] # "1": yoko => tate, "2": tate => yoko
num          = ARGV[3].to_i # 横 or 縦に並べる画像の数

fname = "*" # 結合するファイルをファイル名で選択したい場合はココを編集

files = Dir.glob("#{in_fig_dir}/#{fname}").sort # 結合する全ファイル
puts "Input files are as follows:"
p files


tmp_dir = `mktemp -d tmp.XXXXXXXXXXXXXX`.chomp
#system("mkdir -p #{tmp_dir}") if File.exists?( tmp_dir ) == false

ext_name = File.extname( files[0] ) # 画像ファイルの拡張子を取得
                                    # (全て同じ拡張子であることを想定して, 最初の1枚の拡張子を取得)

fig_out = "#{out_fig_name}#{ext_name}" # 出力画像名（拡張子あり）

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
  
  system("convert -append #{tmp_dir}/* #{fig_out}") # 縦方向に ny_max 枚の画像を結合

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
  
  system("convert +append #{tmp_dir}/* #{fig_out}") # 横方向に nx_max 枚の画像を結合

end

system( "rm -rf #{tmp_dir}")

if File.exists?( fig_out ) == true then
  puts "#{fig_out} has been created."
#  system("open #{fig_out}")
else 
  "Failed to create a figure. "
end
