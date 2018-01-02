# html review
## lable
标签|含义|备注
:--:|:--|:--
`<html>`|定义html文档|
`<body>`|定义文档的主体|
`<h1>-<h6>`|html标题|
`<p>`|html段落|
`<a>`|链接|`<a href="http://www.w3school.com.cn">This is a link</a>`
`<img>`|图像|`<img src="w3school.jpg" width="104" height="142"/>`
`<br />`|换行|
`<hr />`|水平线|



## 属性
属性|含义|备注
:--:|:--|:--
class|规定元素的类名(classname)|
id|规定唯一id|
style|规定元素的行内样式(inline style)|


## 回顾记录
1. 开放标签和闭合标签:由于标签通常成对出现,开始的标签叫开放标签,结束的标签叫闭合标签

2. HTML 提示：使用小写标签    
HTML 标签对大小写不敏感：`<P>` 等同于 `<p>`。许多网站都使用大写的 HTML 标签。   
W3School 使用的是小写标签，因为万维网联盟（W3C）在 HTML 4 中推荐使用小写，而在未来 (X)HTML 版本中强制使用小写。

3. 属性值应该始终包括在引号内.如遇情况请使用转义字符

4. `<br>`还是`<br />`,您也许发现 `<br>` 与 `<br />` 很相似。    
在 XHTML、XML 以及未来的 HTML 版本中，不允许使用没有结束标签（闭合标签）的 HTML 元素。    
即使 `<br>` 在所有浏览器中的显示都没有问题，使用 `<br />` 也是更长远的保障。

5. 换行请使用`<br />`而不是`<p></p>`

6. html样式:文本颜色及样式有旧的标签,我们这里不再使用,我们用style属性为文本增加样式,example:
```html
<html>
<body>
<h1 style="font-family:verdana">A heading</h1>
<p style="font-family:arial;color:red;font-size:20px;">A paragraph.</p>
<h1 style="text-align:center">This is a heading</h1>
<p>The heading above is aligned to the center of this page.</p>
</body>
<body style="background-color:yellow">
<h2 style="background-color:red">This is a heading</h2>
<p style="background-color:green">This is a paragraph.</p>
</body>
</html>

```

7. html链接 target属性
```html
<a href="http://www.w3school.com.cn/" target="_blank">Visit W3School!</a>
```
上行会在新的窗口打开文档



8. 锚: `<a>`标签中name属性规定锚(anchor)的名称.可以通过name属性创建HTML页面的书签 ,书签不会以任何方式显示,他对读者是不可见的
实例
首先，我们在 HTML 文档中对锚进行命名（创建一个书签）：
```html
<a name="tips">基本的注意事项 - 有用的提示</a>
```
然后，我们在同一个文档中创建指向该锚的链接：
```html
<a href="#tips">有用的提示</a>
```
您也可以在其他页面中创建指向该锚的链接：
```html
<a href="http://www.w3school.com.cn/html/html_links.asp#tips">有用的提示</a>
```
在上面的代码中，我们将 `#` 符号和锚名称添加到 URL 的末端，就可以直接链接到 tips 这个命名锚了。