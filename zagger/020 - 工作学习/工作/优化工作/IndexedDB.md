---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# IndexedDB

　　IndexedDB

　　IndexedDB是一种用于客户端存储大量结构化数据的Web API，它提供了一种可以在浏览器中存储和检索数据的机制，以及在这些数据上执行复杂的查询和索引操作。IndexedDB可用于创建类似关系型数据库的数据存储系统，支持事务和索引等功能。

　　IndexedDB的主要特点包括：

　　通过使用键值对存储数据，可以快速、高效地存储和检索数据。

　　支持高级索引功能，可以对数据进行多重排序和过滤。

　　支持事务机制，可以确保数据操作的原子性和一致性。

　　支持异步API，可以在后台执行长时间运行的数据操作，而不会阻塞UI线程。

　　可以在离线环境下使用，可以缓存数据并在离线时使用。

　　以下是一个简单的IndexedDB示例，用于存储一个学生对象的数据：

　　javascriptCopy code// 打开IndexedDB数据库

　　var request = window.indexedDB.open('MyDatabase', 1);

　　// 监听数据库打开事件

　　request.onsuccess = function(event) {

　　var db = event.target.result;

　　// 创建一个数据存储对象

　　var objectStore = db.createObjectStore('students', { keyPath: 'id' });

　　// 添加一条数据

　　var student = { id: 1, name: 'Tom', age: 18 };

　　var addRequest = objectStore.add(student);

　　// 监听数据添加成功事件

　　addRequest.onsuccess = function(event) {

　　console.log('Student added to database');

　　};

　　};

　　// 监听数据库打开错误事件

　　request.onerror = function(event) {

　　console.log('Error opening database');

　　};

　　该示例中，首先使用window.indexedDB.open()方法打开一个名为MyDatabase的数据库，版本号为1。然后，在数据库打开成功后，创建了一个名为students的数据存储对象，并向其中添加了一条学生数据。最后，使用onsuccess和onerror事件监听器处理操作结果。

　　需要注意的是，IndexedDB是一个比较底层的API，使用时需要理解其复杂的概念和使用方式。同时，IndexedDB在不同浏览器中的实现方式和兼容性可能存在差异，需要进行充分的测试和验证。
