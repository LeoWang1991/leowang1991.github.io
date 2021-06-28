---
title: "对js事件循环的理解"
date: 2020-06-11T19:33:04+08:00
draft: false
tags: []
categories: ['前端']
img: 'https://tva1.sinaimg.cn/large/007S8ZIlgy1gfol9ad22bj31400u0x6p.jpg'
---
#### 前言
1. 了解js作为单线程处理事件的顺序
2. 宏任务和微任务 同步任务 异步任务
3. setTimeout/setInterval


<!--more-->
#### JavaScript是怎么运行的

运行时（运行时环境），由浏览器js引擎来执行，提供运行一个运行环境，提供解释编译、自动内存管理、对象模型、核心库等功能。在Node上也使用了`Google V8 engine` 提供运行时，但是没有局限于其事件循环；而是使用了`libuv`库(c语言编写)与V8的时间循环一同工作，从而扩展了可以在后台所做的事。



#### 事件循环

js作为的单线程去处理事件的策略。单线程的好处就是可以避免并发问题，缺点就是容易造成阻塞事件一件件去处理，如果某个事件耗时太长后面的任务也必须等着，比如网页中超清图片加载很慢，比如去请求数据如果同步处理，则需要等待数据请求完成再去执行后面的任务。

为了避免上述问题通常我们通过异步回调函数的方式来实现`非阻塞I/O操作`。`Event Loop`就是为了解决这个问题，*Event Loop是一个程序结构，用于等待和发送消息和事件* 

在程序中设置两个线程：

1. 主线程：负责程序本身的运行
2. Event Loop线程（消息线程）：负责主线程与其他进程(各种IO操作)的通信
   ![](http://www.ruanyifeng.com/blogimg/asset/201310/2013102004.png)



#### 任务队列，同步任务和异步任务

任务分为两种： 同步任务和异步任务。同步任务指在主线程上排队等待执行的任务，按顺序执行；异步任务指的是不进入主线程，而进入`任务队列 task queue`的任务，只有`任务队列`通知主线程，某个异步任务可以执行才会进入主线程执行，可以理解为用于存放事件的队列，当执行一个异步任务时候就相对于执行了该任务的回调函数。

通常io(ajax获取数据)、用户/浏览器自执行事件(onclick onload等)以及定时器(setTimeout setInterval)都可以算异步操作。

![image-20200610234118496](https://tva1.sinaimg.cn/large/007S8ZIlly1gfol64am4lj30vj0qc47b.jpg)



#### 宏任务和微任务

除了上述广义的同步异步任务，对任务更加细致的划分。

1. macrotask宏任务，包括`整体代码script` `setTimeout` `setInterval`
2. microtask微任务，`Promise` `process.nextTick` `then`

每次Event Loop的过程如下：

1. js解释器识别所有js代码，将同步代码放到主线程执行，异步的放到Event Table执行。这也是第一次宏任务执行完毕。
2. 接下来执行所有的微任务

反复循环上述1 2。



#### setTimeout

setTimeout(fn, 3000)。这里并不是3s就会执行，这里的时间3s**并不是3s后立马会在主线程执行fn函数而是3s后放入任务队列中，如果主线程没有执行的代码且队列中没有其他靠前的任务则取出来执行** 大部分情况因为执行很快所以感知不到。



#### 理解

个人理解，事件循环机制就是js作为一门单线程语言去执行各种任务时候根据最优的规则将任务分优先级依次递归去执行js任务(代码)。



#### 参考

[MDN-并发模型和事件循环](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/EventLoop)
[这一次彻底弄懂js执行机制](https://juejin.im/post/59e85eebf265da430d571f89)
[什么是Event Loop](http://www.ruanyifeng.com/blog/2013/10/event_loop.html)
[再谈Event Loop](http://www.ruanyifeng.com/blog/2014/10/event-loop.html)

