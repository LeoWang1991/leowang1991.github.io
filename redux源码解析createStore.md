---
title: "Redux源码解析createStore"
date: 2021-04-24T22:25:29+08:00
draft: false
tags: [redux]
categories: [前端]
---

### 前言

该文章主要记录看redux源码时候遇到的疑惑点以及解惑



### 笔记

redux源码很短，主要核心内容就`createStore`自己在阅读的时候遇到一些问题，记录下。

redux的使用原则大概：单一数据源store，数据源只能通过`dispatch`方式改变，编写纯函数来修改执行。

```javascript
/*
 * @Author: wangjx
 * @Date: 2021-04-24 21:28:20
 * @Description: redux 源码理解demo
 */

import { createStore } from '../index.js';

const initialState = {
  count: 1
}

const reducer = (state = initialState, action) => {
  switch(action.type) {
    case 'ADD': return {
      ...state,
      count: state.count + 1
    };
    case 'MIN': return {
      ...state,
      count: state.count - 1
    };
    default: return state;
  }
}

const logState = () => {
  console.log(store.getState())
}

// 创建store时候会默认执行一次dispatch，得到初始化state值。
const store = createStore(reducer);
store.subscribe(function() {
  console.log(`当前状态`, store.getState());
})

logState();

// logState();
// store.dispatch({ type: 'ADD' })
// logState();
// store.dispatch({ type: 'MIN' })
// logState();
```



### ensureCanMutateNextListeners

为什么需要nextListeners，都在currentListeners上进行不就ok了。

查了一些资料了解到这么设计是因为：

**我们在dispatch过程中 就是那个listeners遍历执行过程中，在这期间我们subscribe/subscribe操作，如果只有currentListeners一个数组来保存的话，则在操作当前数组的时候，当前数组也发生了变化，就会有些问题**

![H1JEqn](https://blog-img-1256179672.cos.ap-shanghai.myqcloud.com/img/H1JEqn.png)

![iVppLO](https://blog-img-1256179672.cos.ap-shanghai.myqcloud.com/img/iVppLO.png)

改下`dispatch` 源码来验证下，

![image-20210424234941472](https://blog-img-1256179672.cos.ap-shanghai.myqcloud.com/img/image-20210424234941472.png)

`store.dispatch({ type: 'ADD' });` 这个操作在此时只调用第一个订阅函数。而应该把后面的一些订阅情况考虑过来。所以需要引入`nextListeners` 来解决这个问题，每次执行时候currentListeners=nextListeners保存一份当前时间节点的订阅事件快照。至于后续的变动改变发生在`nextListeners`中。

