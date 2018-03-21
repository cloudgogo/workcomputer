#### 让DIV块在页面的某个位置固定的css代码  

> 首先，我们将目光投向了CSS规范，我想很多人和我一样很快就想到了position属性，说到定位，我们很容易想到这个属性。   

这个属性一共有四个选项：`static`、`relative`、`absolute`、`fixed`。很高兴，我们在阅读了相关的注释后，我们大概能看到`fixed`是比较符合我们的需求的：   
fixed:    
位置被设置为 `fixed` 的元素，可定位于相对于浏览器窗口的指定坐标。此元素的位置可通过 left、top、right 以及bottom 属性来规定。不论窗口滚动与否，元素都会留在那个位置。工作于 IE7（strict 模式）。 
于是我们很快就有了以下的代码，不过很遗憾，IE中并不能通过严格的测试，但是FireFox中却可以通过测试！    
   
**复制代码代码如下:**


```html
<html> 
<head> 
<!--http://volnet.cnblogs.com--> 
<title>Only fit FireFox! :(</title> 
<!--Some thing about the fixed style!--> 
<style type="text/css"> 
.fixed_div{ 
position:fixed; 
left:200px; 
bottom:20px; 
width:400px; 
} 
</style> 
</head> 
<body> 
<div class="fixed_div" style="border:1px solid #200888;">content, I'm content</div> 
<div style="height:888px;"></div> 
</body> 
</html> 
```

不管上面上面说的IE7的strict模式，很显然，除了IE7，我们的挑战还有包括IE6在内的一大堆未知的因素。很显然，虽然这个方法通过了FireFox，但我们还是宣告失败了。     
难道我们只能使用JavaScript让这一切继续“卡”下去么？（我指的是用JavaScript的时候效果很卡）     
当然不行，我们的症结究竟在哪？我们该如何去解除它呢？带着这样的郁闷，我们需要开始新的探险。     
HTML究竟是啥？     
这个问题换在别的地方问，您可能要搬出一大堆的文档来告诉我HTML的定义，但这里我并不需要那么完整的答案。我们知道HTML是由一大堆的<tag></tag>组成的，而这一大堆的<tag></tag>组合在一起，它们的结构就像一棵树，是的，HTML的代码就是被解释为了一棵树被浏览器所认识。它有一个根，那就是<html></html>节（root），在根节点下常见的节点中，我们通常能见到<head></head>和<body></body>两个节点，它们之下又有……     
现在回顾一下我们的问题，我们的问题是我们滚动滚动条的时候我们希望其中的一个指定的div不会跟着滚动条滚动。     
那么下面让我们来回答另一个问题，啥是滚动条？     
滚动条，顾名思义，就是可以滚动的条（ScrollBar）（废话）。准确地说，滚动条通常是我们在页面的内容超过了浏览器显示框的范围的时候，为了能够让有限的空间展示无限的内容所作出的一个妥协的元素，使用它可以让我们查看当前页面内容之外部分的内容。     
说到这里您估计都还很清楚，但既然我说滚动条也是一个元素，那么它是不是也在我们的HTML中呢？又或者它是浏览器的固有的一部分？     
如果您觉得它是HTML中的一部分，那么您就对了，因为它是依附容器而存在的，而默认产生滚动条的容器是<body></body>或者<html></html>节，它并不是浏览器固有的一部分，浏览器只是默认完整展示了一整个html文档，并不知道它中间的内容究竟是否需要滚动条的支持。 
那么让我们回顾上面的那几行代码吧，假设fixed对您当前（失败）的浏览器无效的话，那么我们来看看它们的结构，外面是html标签，向内是body标签，再向内则是div标签，div标签很明显是它们的一部分，这样假设我们的div标签所设置的定位属性无论如何（四个可能的属性皆没起到什么作用）改变不了自身显示状况。我们能否更换一个思路呢？ 
刚才我说了，滚动条是容器所固有的，不管是外面那个滚动条，还是里面那个滚动条。那么我能否让这个需要固定的div和那个body或者html容器脱离关系呢？ 
看到滚动条的控制可以通过CSS的overflow的几个属性来控制，想必大家都不陌生了。（陌生的朋友点击相关链接即可进入查看） 
那么我是否可以自己设置两个完全隔离的div来模拟这种场景呢？（虽说是模拟，但是效果一模一样噢～） 

复制代码代码如下:
```html
<html> 
<head> 
<title></title> 
<style type="text/css"> 
html,body { 
overflow:hidden; 
margin:0px; 
width:100%; 
height:100%; 
} 
.virtual_body { 
width:100%; 
height:100%; 
overflow-y:scroll; 
overflow-x:auto; 
} 
.fixed_div { 
position:absolute; 
z-index:2008; 
bottom:20px; 
left:40px; 
width:800px; 
height:40px; 
border:1px solid red; 
background:#e5e5e5; 
} 
</style> 
</head> 
<body> 
<div class="fixed_div">I am still here!</div> 
<div class="virtual_body"> 
<div style="height:888px;"> 
I am content ! 
</div> 
</div> 
</body> 
</html> 
```
**分析**： 
html,body：将默认可能会随机出现的滚动条，完全地隐藏了，这样不管您放了啥内容，它们都不会出来了。     
.virtual_body：顾名思义，就是一个假的body了，它被设置为长宽都为100%的，意思就是它利用了所有可视的浏览器窗体显示所有的内容，并垂直允许出现滚动条。     
.fixed_div：这下它可以利用绝对值进行定位了，因为在这个场景下，这个页面100%地被那个假冒的body给独霸了，而滚动条反正也出不来，您就可以自认为是在某个点蹲坑了，绝对安全。     
想必您通过这些代码已经了解了新的方法不过是将一个div换作了之前的body。