#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#---- 複数のディレクトリに入っている連番ファイルを順に結合し, 複数の画像を作成する
# 
# (例) 異なる解像度のモデル結果の画像が4つのディレクトリ(d1~d4)に複数（時系列）入っているとすると, 
#　　 $ ruby append_from_dirs.rb outdir 1 2 d1 d2 d3 d4"
# 　　により, d1~d4 のファイルを結合した画像が outdir に作成される. 
#    このとき, seq_type=1 なので yoko=>tate の順で, 横に 2 (縦に 2 )並べた画像が作成される.

if ARGV.size <= 3 then  
  puts "Usage: $ ruby #{$0} out_fig_dir seq_type nx_or_ny in_fig_dirs"
  puts "(e.g): $ ruby #{$0} out_fig_dir    1         2    f/1 f/2 f/3 f/4"
  puts "     : (yoko=>tate), n_yoko=2, all.png will be created."
  puts "       seq_type: (1) yoko => tate, (2) tate => yoko"
  exit
end

out_fig_dir = ARGV[0] # 結合した画像を出力するディレクトリ
#out_fig_dir = "fig_out" # 結合した画像を出力するディレクトリ

seq_type     = ARGV[1] # 画像を並べる順番: "1": yoko => tate, "2": tate => yoko
num          = ARGV[2].to_i # 横 or 縦に並べる画像の数
#seq_type     = 1 # 画像を並べる順番: "1": yoko => tate, "2": tate => yoko
#num          = 2 # 横 or 縦に並べる画像の数

# 結合する画像が入ったディレクトリを指定
p dirs = ARGV[3..-1]
#dirs = ["f/1", "f/2", "f/3", "f/4"]

# 残っているファイルリストを削除
system("rm FILELIST_DIRS*.txt FILELIST_CAT*.txt")

# 出力ディレクトリの作成
system("mkdir -p #{out_fig_dir}") if File.exists?( out_fig_dir ) == false

nd = dirs.size  # ディレクトリ数 
nf = Dir.glob("#{dirs[0]}/*").size # ディレクトリ内のファイル数

#---各ディレクトリのファイルリストを作成
for i_d in 1..nd # ディレクトリ番号でループ
  system("ls #{dirs[i_d-1]}/* > FILELIST_DIRS_#{"%04d"%(i_d)}.txt")
end

#---ディレクトリに入ったファイルの番号毎にファイルリストを作成 
for   i_f in 1..nf  # ファイル番号でループ
  ii_f = "#{"%04d"%(i_f)}"
  out_file = "FILELIST_CAT_#{ii_f}.txt"
  system("rm    #{out_file}") if File.exists?( out_file ) == true
  system("touch #{out_file}")
  for i_d in 1..nd # ディレクトリ番号でループ
    ii_d = "#{"%04d"%(i_d)}"
    system("awk 'NR==#{i_f}{print $0}' FILELIST_DIRS_#{ii_d}.txt >> #{out_file}")
  end
end

fig_name_dir1 = ""
# 画像ファイルの結合
for   i_f in 1..nf  # ファイル番号でループ
  ii_f = "#{"%04d"%(i_f)}"
  in_file = "FILELIST_CAT_#{ii_f}.txt"
  tmp = `awk 'NR==#{i_f}{print $1}' FILELIST_DIRS_0001.txt`.chomp # 1番目のディレクトリのファイル名
  fig_name_dir1 = File.basename(tmp)
  out_fig_name = "fig_CAT_#{ii_f}_#{fig_name_dir1}"
  out_fig = "#{out_fig_dir}/#{out_fig_name}"
#  system("ruby rk-convert.rb #{in_file} #{out_fig} #{seq_type} #{num}") 
  system("rk-convert #{in_file} #{out_fig} #{seq_type} #{num}") 
end

system("rm FILELIST_DIRS*.txt FILELIST_CAT*.txt")
