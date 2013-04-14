# No320 db base

基于fmdb和sqlite的封装


## 配置步骤

1. git submodule add https://github.com/ccgus/fmdb.git fmdb


2. 除了fmdb.m外，src和extra都加入到工程里。


3. 增加sqlite3.dylib




## 设计思路

context：负责完成dbtable的创建，和销毁


SQLiteOpenHelper：

QueryProtocol

CustomTable 继承自SQLiteOpenHelper，自动建表

queryClass继承CustomTable and实现QueryProtocol，完成查询功能


Gospel_SQLiteOpenHelper *helper = [Gospel_SQLiteOpenHelper alloc] init:@"ddd"]

【helper registerModel:new Model()】;






