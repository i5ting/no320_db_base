//
//  SQLiteOpenHelper.m
//  Gospel_IOS
//
//  Created by sang alfred on 4/13/13.
//  Copyright (c) 2013 sang alfred. All rights reserved.
//

#import "SQLiteOpenHelper.h"



#define _DBFILE_NAME [NSString stringWithFormat:@"%@",@"gospel_ios.db"]

#define _DBFILE_DIR  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];


@implementation no320_db_base_table_model

@synthesize table_name;
@synthesize old_v;
@synthesize new_v;
@synthesize open_helper;

- (id)init_with_table_name:(NSString *)name old_version:(int)old_v new_version:(int)new_v open_helper:(SQLiteOpenHelper *)helper
{
    if (self = [super init]) {
        self.table_name = name;
        self.old_v = old_v;
        self.new_v =new_v;
        self.open_helper = helper;
    }
}

@end


@implementation no320_db_base_context

@synthesize table_names;

@synthesize db;
@synthesize logsErrors;
@synthesize traceExecution;


+ (no320_db_base_context *)sharedInstance {
	static no320_db_base_context *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    return _sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
	return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#if (!__has_feature(objc_arc))

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

#endif


#pragma mark - lifecycle

- (id)init {
    if (self = [super init]) {
        NSLog(@"INFO: Begin singleton DataBaseService initialization......");
        
        self.logsErrors = NO;
        self.traceExecution = NO;
        
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_DBFILE_NAME];
        
        NSString *dir = _DBFILE_DIR;
        NSString *databasePath = [dir stringByAppendingPathComponent:_DBFILE_NAME];
        NSFileManager *tempFileManager = [NSFileManager defaultManager];
        BOOL isExisted = [tempFileManager fileExistsAtPath:databasePath];
        if (!isExisted) {
            NSLog(@"INFO_OC: 复制数据库文件 database.db from %@ to %@.", bundlePath, databasePath);
            NSError *error = nil;
            BOOL success = [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:databasePath error:&error];
            if (!success) {
                NSLog(@"ERROR_OC: Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        }
        
        db = [FMDatabase databaseWithPath:databasePath] ;
        
        //打开sql跟踪日志
        db.traceExecution = self.traceExecution;
        db.logsErrors = self.logsErrors;
        
        if (![db open]) {
            NSLog(@"INFO_OC: Failed to open database.");
//            [db release];
            return self;
        }
        
        [self call];
        
        NSLog(@"INFO_OC: End singleton DataBaseService initialization......");
    }
    return self;
}

-(void)dealloc{
//    [db close];
//    [db release];
//    [queue release];
//    [super dealloc];
}

#pragma mark - Private Methods Implemetions



#pragma mark - Public Methods Implemetions

-(NSMutableArray *)find_by_sql:(NSString *)query_sql with_rs_callback:(no320_db_base_table_model* (^)(FMResultSet *_rs,int _line_num))rs_block{
    FMResultSet *_rs = [db executeQuery:query_sql];
    NSMutableArray *ret_array =  [[NSMutableArray alloc] init];
    int line_num = 0;
    
    if (_rs) {
        while ([_rs next]) {
            @autoreleasepool {
                no320_db_base_table_model *obj = rs_block(_rs,line_num);
                
                if (obj) {
                    [ret_array addObject:obj];
                }
                
                //SAFE_RELEASE(obj);
            }
            
            line_num++;//from 0+
        }
        return ret_array ;
        
    }else {
       // SAFE_RELEASE(ret_array);
        return nil;
    }
}


-(int)find_one_column_by_sql:(NSString *)query_sql
{
    FMResultSet *s =[db executeQuery:query_sql];
    
    if ([s next]) {
        return [s intForColumnIndex:0];
    }
    
    return  0;
}



#pragma mark -

#pragma mark - Private

- (void)call
{
    return;
    for (no320_db_base_table_model *model in self.table_names) {
        if ([model.open_helper isKindOfClass:[SQLiteOpenHelper class] ]) {
            [model.open_helper onCreate:self.db];
            [model.open_helper onUpgrade:self.db old_v:model.old_v new_v:model.new_v];
        }
    }
}


@end



@implementation SQLiteOpenHelper

@synthesize context;


- (void)registerModel:(no320_db_base_table_model *)table_model
{
//    [self.table_names addObject:table_model];
    
//    [table_model.open_helper onCreate:self.db];
    //    [table_model.open_helper onUpgrade:self.db old_v:model.old_v new_v:model.new_v];
    
}


-(id)init_with_database_name:(NSString *)name old_v:(NSString *)old_v  new_v:(NSString *)new_v
{
    if (self  = [super init]) {
        self.context = [no320_db_base_context sharedInstance];
        
//        no320_db_base_table_model *m = [[no320_db_base_table_model alloc] init_with_table_name:name old_version:old_v new_version:new_v open_helper:self];
       // [self.context add_table_model:m];
    }
    return self;
}

- (void)onCreate:(FMDatabase *)db
{
    // TODO Auto-generated method stub
//    Log.i("TAG", "create table start...");
//    db.execSQL(TABLECONTACTS);
//    
//    
//    Log.i("TAG", "create table over...");
    
}


- (void)onUpgrade:(FMDatabase *)db  old_v:(int)oldVersion new_v:(int)newVersion
{
    // TODO Auto-generated method stub
//    Log.i("TAG", "contactsmanager.db Upgrade...");
//    db.execSQL("DROP TABLE IF EXISTS "+TABLE_CONTACTS);
//    onCreate(db);
//    
}

@end
