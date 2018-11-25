# dataStructureAndAlgorithm(データ構造とアルゴリズム)
講義科目である。
## 目的
講義科目「データ構造とアルゴリズム」の復習を行う  
## 手段
教科書「Javaで学ぶアルゴリズムとデータ構造 柴田望洋著 SBCreative」の内容及び講義の内容をMicrosoft Word 2016を用いて問題形式でまとめる。(note.docx)  
また、docxファイルはpdfファイルで公開する。([note.pdf](https://github.com/17ec084/grade2-2/raw/master/dataStructureAndAlgorithm/note.pdf))
## その他特筆すべき事項

### ポインタソート
聴講中に思いついた、新しい(？)並び替えアルゴリズム。  
コンセプトは単純明快である。  
1.並び変えたい自然数を同じ(または比例する)番地のアドレスに格納する。  
2.空いた番地はつめる  
これで終わり。  
例えば表0のような配列をポインタソートすると、手順1で表1のようになり、手順2で表2のようになってソートが完了する。  
<Div Align="center">表0 ソート前の配列</Div>   
<table Align="center">
  <tr>
    <th>アドレスまたは配列の番目</th>
    <th>0</th>
    <th>1</th>
    <th>2</th>
    <th>3</th>
    <th>4</th>
    <th>5</th>
    <th>6</th>
  </tr>
  <tr>
    <td>自然数</td>
    <td>1</td>
    <td>7</td>
    <td>14</td>
    <td>12</td>
    <td>0</td>
    <td>8</td>
    <td>4</td>
  </tr>
</table>
