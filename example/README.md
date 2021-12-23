
## 参数
|  参数名   | 描述  | 是否必传  |
| :----: | :----: | :----: |
| children  | widget 列表 |是 |
|   key  | 组件key |否 |
| onIndexChanged  | 滚动到对应widget 的回调 |否 |
| excludeOffset  | 不参与计算定位的偏移量 |否 |



## 可调用方法
- 滚动到指定下标组件的位置
```
jumpToIndex(int index);
```

## 示例代码
```

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends BaseStatefulState<TestPage> {
  GlobalKey<AnchorPointScrollViewState> _anchorPointKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 180),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _anchorPointKey.currentState?.jumpToIndex(4);
            },
            child: Container(
              height: 90,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: AnchorPointScrollView(
              key: _anchorPointKey,
              onIndexChanged: (index) {
                print('lch----$index');
              },
              children: [
                Container(
                  // margin: EdgeInsets.only(top: 10),
                  height: 180,
                  width: 376,
                  color: Colors.yellow,
                  child: Directionality(
                    child: Text('0'),
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Container(
                  height: 300,
                  width: 376,
                  color: Colors.red,
                  child: Directionality(
                    child: Text('1'),
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Container(
                  height: 60,
                  width: 376,
                  color: Colors.green,
                  child: Directionality(
                    child: Text('2'),
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Container(
                  height: 140,
                  width: 376,
                  color: Colors.blue,
                  child: Directionality(
                    child: Text('3'),
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Container(
                  height: 1080,
                  width: 376,
                  color: Colors.grey,
                  child: Directionality(
                    child: Text('4'),
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

```