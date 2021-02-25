# AppRouter

## Router Spec
#### Story: Tap universal link from webside to launch app to current view controller

#### Narrative #1
    As an app user
    I want the app correctly open page when tap universal link from webside

## Use Cases
##### Primary course
- [ ] App 啟動後 URLNavigator navigator 不是 nil
- [ ] App Router 能正確解析 universal link (get query string)，並開啟正確頁面
	- [ ] 路徑配對成功
	- [ ] 路徑配對成功且需要 1 個參數
	- [ ] 路徑配對成功且需要 2 個參數
- [ ] 列出的 url path 都需確實被註冊到 navigator 上
	- [ ] App Router 需要處理多少個 path，navigator 就會相對應要註冊幾次

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
