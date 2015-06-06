# H V T G

HIPHOP Video Title Generator.  
Check this out, yo: https://hvtg.herokuapp.com

## Tasks

* ローカルから読み込んだ iPhone で撮影した写真の向きがおかしくなる
  * 下記を参考にして直す
    * [iOS6でメガピクセル画像をCanvasに描画するとおかしくなってしまう件と、その対処 - snippets from shinichitomita’s journal](http://d.hatena.ne.jp/shinichitomita/20120927/1348726674)
    * [egashira.jp : JPEGからJavascriptでEXIFのOrientation情報のみを取得する](http://www.egashira.jp/2013/03/obtain-orientation-from-jpeg-exif)
    * [exif-js/exif-js](https://github.com/exif-js/exif-js)
* ダウンロードボタンを押すと Chrome がクラッシュする
  * Data URL のサイズ制限が原因 (なぜか iPhone の Safari は大丈夫だった)
  * Blob URL を使えば解決するのかも 
    * [javascript - "Aw, Snap" when data uri is too large - Stack Overflow](http://stackoverflow.com/questions/16761927/aw-snap-when-data-uri-is-too-large)
* Preview のカラムの縦幅が無駄に広くなってしまう
  * 直し方がよく分からない
* iPhone での使用感が全体的にいまいち
  * テキスト入力を少なめにしたい
  * メイン画面はプレビューのみ、左右に title/background の半透明な設定画面の Drawer とし、設定をいじりながらプレビューを閲覧できるようにしたい
* 設定項目
  * transform rotate できるようにしたい
* 保存機能
  * 一時的に作業データを Local Storage とかに保存できるようにしたい
  * 設定項目を location.hash から読み込めるようにしたい
* リファクタリング
  * 引用符をシングルクオートに統一する

## Links

* [node.js - static files with express.js - Stack Overflow](http://stackoverflow.com/questions/10434001/static-files-with-express-js)
* [flexboxの旧仕様、改定仕様、現行仕様の一覧 « LINE Engineers' Blog](http://developers.linecorp.com/blog/?p=2479)
* [初心者でもすぐ使える！CSSを使った中央寄せの方法まとめ８＋α | 株式会社Bark to Imagine](http://barktoimagine.com/web/css/1653)
* [Node.js(Express) 事始め ＆ Heroku へデプロイまでのメモ - Qiita](http://qiita.com/hkusu/items/e46de8c446840c50aefe)
* [背景画像の拡大・縮小 → background-size ! | 0から目指すWebマスター](http://www.allinthemind.biz/markup/css/background-size.html)
* [html2canvas - Screenshots with JavaScript](http://html2canvas.hertzen.com/)
* [More About Refs | React](https://facebook.github.io/react/docs/more-about-refs.html)
* [CSSでキレイな日本語フォントの明朝とゴシック | Ri-mode Memo](http://ri-mode.com/memo/2013/11/08/japanese_font_family/)
* [reactjs - React.jsでFormを扱う - Qiita](http://qiita.com/koba04/items/40cc217ab925ef651113)
* a タグの download 属性
* [[CSS]コピペでOK、text-shadowを使ってテキストにさまざまなスタイルを与える全23種類のスタイルシートのまとめ | コリス](http://coliss.com/articles/build-websites/operation/css/css-text-shadow-comilation-by-boltaway.html)
* [Inline Styles | React](https://facebook.github.io/react/tips/inline-styles.html "Inline Styles | React")
  * react の style でベンダープレフィクスを使いたい場合は WebkitTransform のように大文字を使う
* [flexboxの旧仕様、改定仕様、現行仕様の一覧 ≪ LINE Engineers' Blog](http://developers.linecorp.com/blog/?p=2479 "flexboxの旧仕様、改定仕様、現行仕様の一覧 ≪ LINE Engineers' Blog")
* [html - Data protocol URL size limitations - Stack Overflow](http://stackoverflow.com/questions/695151/data-protocol-url-size-limitations)
* [canvas.toDataURL() for large canvas - Stack Overflow](http://stackoverflow.com/questions/16156402/canvas-todataurl-for-large-canvas)
* [exif-js/exif-js](https://github.com/exif-js/exif-js)
