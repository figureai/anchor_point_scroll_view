
## 锚点滚动组件

- 效果

![](https://tva1.sinaimg.cn/large/008i3skNgy1gxnqvq0bq2g30au0m00wy.gif)


- 示例代码
```

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnchorPointScrollViewState> _anchorKey = GlobalKey();
  int _currentIndex = 0;

  _onPress(int index) {
    _anchorKey.currentState?.jumpToIndex(index);
    // _anchorKey.currentState?.animatedTo(index,duration:const Duration(milliseconds: 150),curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Wrap(
          children: List.generate(10, (index) {
            return TextButton(
              onPressed: () => _onPress(index),
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: index == _currentIndex ? Colors.red : Colors.grey,
                  fontSize: index == _currentIndex ? 24 : 12,
                ),
              ),
            );
          }),
        ),
        Expanded(
          child: AnchorPointScrollView(
            key: _anchorKey,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: List.generate(10, (index) {
              return Container(
                height: 80.0 * (index+1),
                color: Colors.primaries[index],
                alignment: Alignment.center,
                child: Text(index.toString(),
                    style: const TextStyle(fontSize: 28, color: Colors.black)),
              );
            }),
          ),
        ),
      ]),
    );
  }
}


```


## 参数
|  参数名   | 描述  | 是否必传  |
| :----: | :----: | :----: |
| children  | widget 列表 |是 |
| excludeOffset  | 不参与计算定位的偏移量 |否 |
|   key  | 组件key |否 |
| onIndexChanged  | 滚动到对应widget 的回调 |否 |
| onScroll  | 滚动过程的回调 |否 |


## 可调用方法
- 滚动到指定下标组件的位置
```
jumpToIndex(int index);
animatedTo(
    int index, {
    required Duration duration,
    required Curve curve,
  }) 

```
