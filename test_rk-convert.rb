#!/usr/bin/ruby
exe = "rk-convert.rb"
in_fig_dir = "fig_test_rk-convert"

system("ruby #{exe} #{in_fig_dir} yoko-tate2x4 1 2")
system("ruby #{exe} #{in_fig_dir} yoko-tate3x3 1 3")
system("ruby #{exe} #{in_fig_dir} tate-yoko2x4 2 2")
