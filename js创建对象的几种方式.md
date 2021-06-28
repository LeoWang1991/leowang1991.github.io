---
title: "Js创建对象的几种方式"
date: 2021-04-19T22:08:49+08:00
draft: false
tags: [javascript,对象]
categories: [前端]
---

### 前言

1. 了解js几种创建对象的方式
2. 了解原型

<!--more-->

### 创建对象

#### 工厂模式

```javascript
function createPerson(name, age) {
  let obj = new Object();
  obj.name = name;
  obj.age = age;
  obj.sayName = function() {
    console.log(this.name)
  }
  
  return obj;
}

const p = new Person('xiaofei', 22);
```

工厂模式虽然解决了复用问题，但是没有解决对象标识问题，创建的对象`typeof p` 永远就是object类型。

#### 构造函数

最常见的方式

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.sayName = function() {
    console.log(this.name)
  }
}

const p1 = new Person('xiaofei', 20);
const p2 = new Person('xiaohong', 30);
```

和工厂模式的区别：

1. 没有显示的创建对象
2. 属性方法赋值给this
3. 没有return

理解创建的过程：

 `new` 运算符作用就是创建对象的实例。

1. 现在内存中新建一个新对象

2. 把该新对象的[[Prototype]]属性赋值为构造函数的prototype属性，这一步简言之就是原型绑定。

   `p.__proto__ = Person.prototype` 

3. this指向新对象，Person.call(p) 调用Person() 将新对象作为this传入
4. 构造函数返回非空对象，则返回该对象；否则返回刚刚创建的新对象。

既然知道了`new`构造函数的具体步骤，可以自己试着写一个FakeNew方法。 

> 弊端：每次创建实例，都会创建新的方法，不必要的开销。



#### 原型模式

1. 每个构造函数都有`prototype` 属性指向其原型对象
2. 默认情况下所有原型对象有一个`constructor`属性指向该构造函数

```javascript
function Person() {}
Person.prototype.name = 'xiaofei';

let p = new Person();
 
p.__proto__ === Person.prototype; // true 对象的隐式原型在浏览器中就是__proto__表现
p instanceof Person; // true
```



### new实现

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.sayName = function() {
    console.log(this.name)
  }
}
let p1 = new Person('xiaofei', 10);
let p2 = new Person('xiaohong', 12);

function FakeNew() {
  console.log(arguments instanceof Array);  

  let obj = new Object();
  const Constructor = [].shift.apply(arguments);
  if(typeof Constructor !== 'function') {
    throw '第一个参数,请传入构造函数';    
  }
  obj.__proto__ = Constructor.prototype;
  let res = Constructor.apply(obj, arguments);

  return typeof res === 'object' ? res : obj;  
}

const p3 = FakeNew(Person, 'xiaofei', 20);

p3.sayName();
```

注意点：

1. arguments并非是数组结构 需要进行转换
2. arguments需要去掉第一个参数即传入的构造函数，其余参数作为参数，通过obj.Contructor(arguments)调用。

