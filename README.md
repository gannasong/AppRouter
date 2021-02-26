# AppRouter

## Router Spec
#### Story: Tap universal link from webside to launch app to current view controller

#### Narrative #1
    As an app user
    I want the app correctly open page when tap universal link from webside

## Use Cases
##### Primary course
- [X] App 啟動後 URLNavigator navigator 不是 nil
- [ ] App Router 在 didFinishLaunchingWithOptions 時，註冊所需要操作的 url pattern (對應開啟的 viewController) 
	- 格式 `https://icook.tw/amp/categories/<int:id>`
	- 測試：
	  - 不需要真的註冊，只要確認傳入的值是相同的即可
	- 開發：
	  - 需要真的註冊，而且每個 pattern 要處理的參數都不一樣 (在呼叫同隻 function 下，行為要如果處理，且可同時兼顧測試)
- [ ] App Router 能正確解析 universal link (get query string)，並開啟正確頁面
	- [ ] 是否能正確依照 url pattern 解析 url (無需參數) 
	- [ ] 是否能正確依照 url pattern 解析 url 且取出參數 (1 個參數)
	- [ ] 是否能正確依照 url pattern 解析 url 且取出參數 (2 個參數)
- [ ] 設定好全部的快速開啟頁面 (參數為 pattern 的值)   
  - 例： `navigator.open("DemoAlert")`
  - 例： `Navigator.open("myapp://alert?title=Hello&message=World")`
## Flowchart
<img alt="01_trending_repository_screen" src="Images/flowchart_01.png?raw=true">&nbsp;
```flow
st=>start: 使用者點擊 universal link
op=>operation: 啟動 App
op1=>operation: Init Navigator
op2=>operation: Navigator 註冊 all url paths
op3=>operation: 首頁 (補 Case)
op4=>operation: Router 解析 url (query string)
cond=>condition: Switch path case，navigator 導向正確頁面
e=>end: 跳轉正確頁面

st->op->op1->op2->op4
op4->cond
cond(yes)->e
cond(no)->op3(right)
```

## Url Paths
| Case | Url | Query |
| :----: | :---- | :----: |
| home | https://icook.tw | No |
| home | https://icook.tw/ | No |
| richSearch | https://icook.tw/search/羊肉/空心菜,辣椒/ | keyword、ingredients |
| category | https://icook.tw/categories/28 |  id  |
| category | https://icook.tw/amp/categories/28 |  id  |
| marketHome | https://market.icook.tw/ | No |

## URLNavigator
https://github.com/devxoul/URLNavigator

```javascript
// Test url: https://icook.tw/search/羊肉/空心菜,辣椒/
navigator.handle("https://icook.tw/search/<string:keyword>/<string:ingredients>") { (url, values, context) -> Bool in
  if let keyword = values["keyword"] {
  // get keyword -> "羊肉"
  }

  if let ingredients = values["ingredients"] {
  // get ingredients -> "空心菜,辣椒"
  }

  // do something
  navigator.present(DemoViewController(), wrap: nil, from: nil, animated: true, completion: nil)
  return true
}
```

#### Match
```javascript
let navigator = Navigator()
let url = "https://icook.tw/search/羊肉/空心菜,辣椒/"
let pattern = "https://icook.tw/search/<string:keyword>/<string:ingredients>"
let result = navigator.matcher.match(url, from: [pattern])

// if match pattern, result will be true and reutn values.
```
