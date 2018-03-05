#### 问题原因

> 由于JDK是国际版的，在编译的时候，如果我们没有用-encoding参数指定我们的JAVA源程的编码格式，则javac.exe首先获得我们操作系统默认采用的编码格式，也即在编译java程时，若我们不指定源程序文件的编码格式，JDK首先获得操作系统的file.encoding参数(它存的就是操作系统默认的编码格式，如WIN2k，它的值为GBK)，然后JDK就把我们的java源序从file.encoding编码格式转化为JAVA内部默认的UNICODE格式放入内存中。然后，java把转换后的unicode格式的文件进行编译成.class类文件，此时.class文件是UNICODE编码的，它暂放在内存中，紧接着，JDK将此以UNICODE编码的编译后的class文件保存到我们的操作系统中形成我们见到的.class文件。对我们来说，我们最终获得的.class文件是内容以UNICODE编码格式保存的类文件，它内部包含我们源程序中的中文字符串，只不过此时它己经由file.encoding格式转化为UNICODE格式了。当我们不加设置就编译时，相当于使用了参数：javac -encoding gbk XX.java，当然就会出现不兼容的情况。
#### 解决方案

> 解决办法是：应该使用-encoding参数指明编码方式：javac -encoding UTF-8 XX.java下面是详细的操作流程！