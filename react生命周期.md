---
title: "React生命周期"
date: 2021-05-06T14:38:35+08:00
draft: false
tags: [react]
categories: []
---

### 前言

1. 了解相关React生命周期函数
2. 优化

### 挂载

组件实例初始化并插入到DOM过程

1. constructor(props) {super(props)}
2. static getDerivedStateFromProps(nextProps, prevState) => newState
3. render()
4. componentDidMount()

**getDerivedStateFromProps** 当组件props变化时候可以在这个api中监听到，开发过程中场景比较少，如果组件半受控，也受props影响则可以在这个api中返回新的state。



### 更新阶段

props变化 setState 或者forceUpdate() 触发

1. static getDerivedStateFromProps
2. componentShouldUpdate(nextProps, nextState) => boolean 
3. render()
4. getSnapshotBeforeUpdate(prevProps, prevState) => snapshot
5. componentDidUpdate(prevProps, prevState, snapshort)

- `getSnapshotBeforeUpdate` 顾名思义，获取快照在更新之前，使用场景比如滚动列表新增或者删除元素 需要让滚动条位置滚动到最新元素处，此时则需要在该生命周期中获取当前的dom元素数据并返回，在`componentDidUpdate`中获取后应用到dom元素上
- `componentShouldUpdate` 对props state变化进行一个浅比较，如果相同则不更新 `PureComponent`内置这个特性



### 卸载阶段

1. componentWillUnmount 该阶段主要是取消订阅之类的操作



### 坑

**浅比较的问题**

浅比较只能比较基础数据结构，如果没发生变化则吧不进行渲染。

但是对于引用类型数据，浅比较只是比较props/states数据的指向地址，真实数据是否变化并无法比较，所以会出现数据变更了但页面并没有渲染。



[componentDidUpdate里prevState和当前state值一样](https://stackoverflow.com/questions/48057906/prevstate-in-componentdidupdate-is-the-currentstate/48058492)

```javascript
addItem() {
  const { items } = this.state;
  items.push(newItem); 
  this.setState({ items });
  // good
  const newItems = [...items];
  newItems.push(newItem);
  this.setState({ items: newItems });
}
```

这种情况 我们直接取state.items操作 对于对象元素的话，在当前对象操作的话，新的state指向的对象是同一个，因为上述很多api中都会通过 `nextProps nextState` 这样的进行比较，**所以在state为对象时候 需要避免直接在state数据上做处理，**



### 其他

废弃的api

1. componentWillMount
2. componentWillReceiveProps
3. componentWillUpdate

废弃原因：因为经常被滥用[在react异步渲染](https://zh-hans.reactjs.org/blog/2018/03/27/update-on-async-rendering.html) 中问题更大，所以丢弃。



所以React异步渲染是什么？链接的文章中提到 need to learn

1. time slice

2. suspense 

   