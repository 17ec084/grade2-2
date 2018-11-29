# FLICE(情報通信基礎実験 fundamental Laboratory on Infomation and Communication Engineering)
実験科目である。

## 目的
実験科目「情報通信基礎実験」のレポート作成を効率化する。

## 手段
1. Markdown記法によるレポートのひな型を作る。  
2. 各実験ごとに、ひな型に数式、図以外のものを加え、適切なディレクトリに保存する。
2. pandocを利用し、mdファイルをWord形式(.docx)に変換する
3. 数式と図を加え、ページ番号やその他を適切に編集する。  

### pandocのインストール及び使用方法
1. [pandocのサイト](https://github.com/jgm/pandoc/releases/tag/2.2.2.1)から、環境に合うmsiファイルをダウンロードした。  
2. ダウンロードしたものを開き、同意してインストールした。  
3. ローカルの、mdファイルでレポートを作成したディレクトリに行き、コマンドプロンプトで  
`pandoc ./(mdファイル名) -t docx -o report.docx` を実行する。  
4. 生成されたreport.docxを開き、すべてコピーし、過去作成したWord形式のレポートに貼り付ける。但し、貼り付けモードは「貼り付け先のテーマを使用」を選択する。  


以下、レポートのひな型である。
____
(作成途中)

### 参考サイト
https://qiita.com/tenten0213/items/f67f5601cbed6ef86b3c
