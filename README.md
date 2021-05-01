# Gene_Trello_CLI
Generate Trello-CLI Commands.

# trello-cli install
* URL
* https://www.npmjs.com/package/trello-cli
* https://github.com/mheap/trello-cli

trelewで自動追加を試みたのだが、なんといちいちtmpに中間ファイルを書き込みに行く際にその中間ファイルをエディタで開くせいでシーケンシャルに追加が出来ないという難点が発覚した。
いちいちボードにいって、リストを選んで、という行為は求めていないのだ。
そのため、trello-cliで自動化することにした。
環境は、WSL2 Ubuntu 20.04 LTSによる。

```
npm install -g trello-cli
npm audit fix
npm audit
```
この後で、trelloを実行すると
```
$ trello
We couldn't find an authentication token! Please visit the following URL:
https://trello.com/1/connect?key=YOURAPIKEY&name=trello-cli&response_type=token&scope=account,read,write&expiration=never
Once you have a token, run the following command:
trello set-auth <token>
```

ここで、key=YOURAPIKEYのトークンは
https://trello.com/app-key
で手に入る。

認証をした後にトークンが手に入るので、
```
$trello set-auth <<<token>>>
Token set
$ trello
Trello CLI
Welcome to Trello CLI! To get started, run:
trello --help
$ trello --help
warning: Usage: trello [command]

command
add-board Adds a new board with the specified name
add-card Add a card to a board
add-list Adds a new list to the specified board with the specified name
add-webhook Add a webhook to a board
archive-card Archive a card from a board
assigned-to-me Show cards that are currently assigned to yourself, or any member specified
card-assign Add or remove a member to a card
card-details Show details about a specified card
close-board Closes those board(s) where the specified text occurs in their name
delete-card Remove a card from a board
delete-webhook Remove a webhook by ID
move-all-cards Move all cards from one list to another
move-card Move a card on a board
refresh Refresh all your board/list names
show-boards Show the list of cached boards
show-cards Show the cards on a list
show-labels Show labels defined on a board
show-lists Show the list of cached lists
show-webhooks display webhooks for current user applications
```
先ほどのトークンを~/.trello-cli/config.jsonに書いてやる必要がある。
```
$trello add-board -b hoge
error: The 'appKey' in ~/.trello-cli/config.json is invalid
$vim ~/.trello-cli/config.json
```
形式は
```
$ cat ~/.trello-cli/config.json
{
"appKey": "YOURAPIKEY",
"configPath": "/home/Jhon_Doe/.trello-cli/",
"authCache": "authentication.json",
"translationCache": "translations.json"
}
```
のため、YOURAPIKEYを
https://trello.com/app-key
で手に入れたトークンに書き換える。

そのままリフレッシュもせずに実行すると、エラーが発生する。
```
$ trello add-board -b hoge
/home/Jhon_Doe/.npm-global/lib/node_modules/trello-cli/src/commands/add-board.js:44
throw err;
^

Error: invalid value for prefs_permissionLevel
at Request._callback (/home/Jhon_Doe/.npm-global/lib/node_modules/trello-cli/node_modules/node-trello/lib/node-trello.js:88:13)
at Request.self.callback (/home/Jhon_Doe/.npm-global/lib/node_modules/trello-cli/node_modules/request/request.js:187:22)
at Request.emit (events.js:198:13)
at Request.<anonymous> (/home/Jhon_Doe/.npm-global/lib/node_modules/trello-cli/node_modules/request/request.js:1044:10)
at Request.emit (events.js:198:13)
at IncomingMessage.<anonymous> (/home/Jhon_Doe/.npm-global/lib/node_modules/trello-cli/node_modules/request/request.js:965:12)
at IncomingMessage.emit (events.js:203:15)
at endReadableNT (_stream_readable.js:1145:12)
at process._tickCallback (internal/process/next_tick.js:63:19)
```
そのため、リフレッシュを行う。
```
$ trello refresh
Organization, board, list, and user cache refreshed
$ trello show-boards
hoge (ID: 5fed95fef1821948a7830e2f)
fuga (ID: 5fedbdb8c116fb4da27a0277)
```

ちなみadd-cardでは、IDではなく、名前を指定してやらないとならない

```
$ trello add-card -b "5fedbdb8c116fb6da27a0277" -l "60694e98ac78177856ee63a5" "hoge" -p bottom
error: Board '5fedbdb8c116fb6da27a0277' does not exist. Exiting.
$ trello add-card -b "hoge" -l "piyo" "hoge" -p bottom
$ trello show-cards -b "hoge" -l "piyo"
Trelloワークスペース > hoge > piyo
* QoaxQksq - hoge
$
```

