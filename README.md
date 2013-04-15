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






## 对于充血模型的思考



1. Model继承FMDBSet
这样它就可以把Query出来的东西，map到对象上

2. 必要接口
建表
- (void)on_create:(FMDB　*)db;

3. 可选接口

查询接口
- (NSArray *)query:(NSString *)sql  param:(NSDictionary *)param;

管理接口
- (Boolean)manage:(NSString *)sql  param:(NSDictionary *)param;


