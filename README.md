# K-SVD

##使用方法
画像パッチ(8x8)をpatch%d.pngの名前で./patch/に用意する。
こちらからパッチ画像を読み込み（デフォルトだと11000枚)、K-SVDを使った学習を行う。(dict_picture.m)
辞書サイズは64x441となっています。

画像からの辞書を使った復元については、同じディレクトリ内に適当な画像を用意し、
image_from_dict.mを使って試すことができます。

ライブラリは下記のOMP-Box v10を使用。
http://www.cs.technion.ac.il/~ronrubin/software.html

