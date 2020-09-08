R, Python, Juliaで分析でよくやりそうな操作をそれぞれ実装し、パフォーマンスを確認  
ここではデータの読み込み時間は計測対象から除外し、処理時間にのみ焦点をあわせている

# 実行環境
## R
- R version 4.0.2
- tidyverse 1.3.0

## Python 
- Python 3.8.2
- Pandas  1.0.5

## Julia
- julia 1.4.2
- DataFrames 0.21.2
- DataFramesMeta 0.5.1

# 実行結果
最初のjoin部分はR側が少し早いものの後続処理は処理時間はほぼ同じだった。  
ただし、pythonで1ヶ月ずらして前月情報を付与する部分で最大44GBくらいメモリを食ったのに対し  
Rでは23GB程度しか食わないことが判明

| Step | Python | R |  Julia |
|---|---|---|---|
| 01. Simple join | 00:00:50 | 00:00:29 | 00:01:39 |
| 02. Aggregate | 00:00:46 | 00:00:46 | 00:00:40 |
| 03. Join previous month result | 00:03:58 | 00:04:14 | 00:05:18 |

※ Pythonのみ全ステップが終了して計算時間をPrintした後プロセスが終わるまで数十秒要するのが気になった
  


___
以下、作業の再現のためのメモ

# テスト用データの準備
Rでgenerate_dummy_data.Rを実行してしばらく待つと2つのCSVファイルが生成されるので、それを使う。
実行には20GBくらいのメインメモリとCSV保存に4.5GBくらいの保存領域を消費するので
ある程度スペックに余裕のあるマシンで実行しないと危険。


# R側の実行方法
コンソールからRscript 01_join_test.RでOK  
  
※renvで環境を予め準備してください

# Python側の実行方法
poetry shellなんかで環境をActivateしておいてから
python 01_join_test.py を叩けばOK  
  
※poetryで環境は予め準備してください

