## 快速入门
## helloworld

1. javascript代码可以嵌在网页的任何地方,不过我们习惯把javascript代码放在`<head>`标签中.

2. javascript放于单独的`.js`文件中,通过`<script src=""></script>`引入文件

3. 多页面可引用同一`.js`文件,同一页面可用多个`<script>`标签对,浏览器会依次执行

4. 编辑工具推荐`visual studio code` 免费,有js支持

5. 浏览器`Chrome` 开发友好 console中可直接输入js代码,enter执行,`console.log(a)`可输出所需观察对象的值

## 基本语法
1. javascript语言类似java 语句结束用`;` 语句块用`{...}`,但js不强制使用`;`,不使用`;`可能会改变语意,浏览器解析脚本可能会出现和预期不一致的情况,我们所有语句结尾都加**`;`**


2. 一行字符串,仍然算一完整语句
```javascript
'Hello, world';
```

3. 一行可以写多条语句,但不建议这样做

4. 花括号`{...}`有缩进,一般为4个空格,非强制.

5. 以`//`开头直到行末的内容是行注释

6. `/*...*/`中的内容为块注释

## 数据类型
1. javascript不区分数值的类型,同一为number

2. `NaN` 表示not a number  当无法计算结果时用他表示,是合法的number类型

3. `Infinity` 表示无限大,当数值超过了js的number最大值时,就用他来表示,也是合法的number类型
```javascript
2 / 0; // Infinity
0 / 0; // NaN
```

4. 字符串,单引号双引号扩起来的文本

5. 布尔值 真假 `true` `false` 

6. `&&` 与 ,`||` 或 , `!` 非 

7. `*` JavaScript中的`==`和`===`不一样,`==`会自动转换类型进行比较,而`===`则是如数据类型不一致则返回`false`,如果一致,再比较,由于其此缺陷,我们使用`===`进行比较
```javascript
false == 0; // true
false === 0; // false
```

8. `NaN`这个特殊的number与其他number都不相等,包括他自己
```javascript
NaN === NaN; // false
```
唯一能判断`NaN`的方法是`isNaN()`函数:
```javascript
isNaN(NaN); //true
```

9. 浮点数的相等比较会出现问题,我们判断两浮点数是否相等,只能计算他们之差的绝对值是否小于某个阈值:
```javascript
1 / 3 === (1 - 2 / 3); // false
Math.abs(1 / 3 - (1 - 2 / 3)) < 0.0000001; // true
```

10. `null` 和 `undefined` 是空和未定义,区分他两并没有实际意义,大多数情况下请使用`null`,`undefined`仅在判断函数是否传递参数时使用

11. 数组,javascript中的数组可以是任意数据类型
```javascript
[1, 2, 3.14, 'Hello', null, true];
```
另一种方式是通过Array()函数实现:
```javascript
new Array(1, 2, 3); // 创建了数组[1, 2, 3]
```
出于可读性的考虑,建议使用`[]`
数组的元素可以通过索引来访问.请注意,索引的起始值为`0`:
```javascript
var arr = [1, 2, 3.14, 'Hello', null, true];
arr[0]; // 返回索引为0的元素，即1
arr[5]; // 返回索引为5的元素，即true
arr[6]; // 索引超出了范围，返回undefined
```

