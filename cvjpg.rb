#!/use/bin/env ruby

# ImageMagickのconvertコマンドに依存
# 画像のパスを引数にいれると画像を圧縮して出力

def to_jpg(path)
  begin 
    system("convert -quality 90 #{path} #{File.basename(path, ".*")}.jpg")
  rescue
    puts "convert Error!"
  end
end

to_jpg(ARGV[0])
