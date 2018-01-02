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

12. 对象 javascript 是一组由键-值组成的无序集合,例如:
```javascript
var person = {
    name: 'Bob',
    age: 20,
    tags: ['js', 'web', 'mobile'],
    city: 'Beijing',
    hasCar: true,
    zipcode: null
};
```
获取对象的属性 对象名.属性名

13. 变量 ,和中学代数方程的变量是一个含义,它可以是任意数据类型
变量在javascript中就是用一个变量名表示,变量名是大小写英文,数值,`$`和`_`的组合,不能用数字开头,变量名也不能是javascript关键字,如`if`,`while`等.申明一个变量用`var`语句,比如:
```javascript
var a; // 申明了变量a，此时a的值为undefined
var $b = 1; // 申明了变量$b，同时给$b赋值，此时$b的值为1
var s_007 = '007'; // s_007是一个字符串
var Answer = true; // Answer是一个布尔值true
var t = null; // t的值是null
```
变量名也可是中文,但请不要使用

在javascript中使用`=`对变量进行赋值. 可以把任意数据类型赋值给变量,同一变量可以反复赋值,而且可以是不同类型的变量,但是要注意只能用`var`申明一次,例如:
```javascript
var a =123 //a的值是整数123
a=`ABC` //a变为字符串
```
这种变量本身类型不固定的语言称之为动态语言,java是静态语言,而python是动态语言

>tips:使用`console.log(a)`代替`alert()`会在使用时更为舒适

赋值语句的`=`不能等同于数学中的`=`.
在计算中计算机会优先处理`=`右侧的表达式,如`x=x+2`


14. strict模式
javascript在设计之初,为了方便初学者学习,并不强制要求用`var`申明变量.这个设计错误带来了严重后果:一个变量如果不用`var`申明就被使用,那么该变量就自动申明为全局变量:
```javascript
i=10; //i现在是全局变量
```

在同一页面调用不同的javascript文件,如果都使用了没有用`var`申明,且变量名一样的变量,将造成变量相互影响,产生难以调试的错误结果

使用`var`申明的变量则不是全局变量,他的范围被限制在该变量被申明的函数体内,同名变量在不同的函数体中互不冲突

为了修补javascript这一严重设计缺陷,ECMA在后续规范中退出了strict模式,在strict模式下运行javascript代码,强制通过var申明变量,未使用var声明变量就使用的,将导致运行错误.

启用strict模式的方法就是在javascript代码的第一行写上:

```javascript
`use strict`
```
这是一个字符串,不支持strict模式的浏览器会把它当做一个字符串语句执行,支持strict,模式的浏览器将开启strict模式运行javascript

测试浏览器是否能支持strict模式:运行代码，如果浏览器报错，请修复后再运行。如果浏览器不报错，说明你的浏览器太古老了，需要尽快升级。

不用var申明的变量会被视为全局变量，为了避免这一缺陷，所有的JavaScript代码都应该使用strict模式。我们在后面编写的JavaScript代码将全部采用strict模式。


## 字符串
1. 特殊情况
`"I'm OK"` or `'I\'m \"OK\"!';`

2. 转义字符`\`

3. 多行字符串用`\`...\``
```html
`这是一个
多行
字符串`;
```