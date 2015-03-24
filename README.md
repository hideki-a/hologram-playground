# Hologram Playground


## サンプル

Google Chromeで見て下さい。サンプルファイルは随時更新されます。更新履歴は```docs_history```内に保存しています。

- [サンプル](http://hideki-a.github.io/hologram-playground/docs/styleguide/modules.html)

## 使い方

1. ```tools/hologramStuff/```で```bundle install```を実行します。
2. ```tools/```で```npm i```を実行します。
3. ```tools/```で```grunt styleguide```を実行します。

Hologramは```htdocs/_scss```内のファイルをドキュメント化します。テンプレートは、```tools/hologramStuff/```内にあります。

## 補足

Hologramは、SCSS形式の一行コメントで記載できるようにカスタマイズしています。（```bundle install```でカスタマイズ済みのHologramがインストールされます。）

	//doc
	// ---
	// title: 見出し1
	// name: heading01
	// category: Modules
	// ---

	// 見出しパターン1です。主にページタイトルとして利用します。

	// ```html_example
	// <div class="hdg-01-container">
	// <h1 class="hdg-01">会社情報 <span class="en" lang="en">Corporate Information</span></h1>
	// </div><!-- /.hdg-01-container -->
	// ```
	//docend

