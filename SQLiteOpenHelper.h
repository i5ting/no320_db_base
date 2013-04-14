//
//  SQLiteOpenHelper.h
//  Gospel_IOS
//
//  Created by sang alfred on 4/13/13.
//  Copyright (c) 2013 sang alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"


@protocol no320_db_base_table_model_manage_protocol <NSObject>

- (void)onCreate:(FMDatabase *)db;
- (void)onUpgrade:(FMDatabase *)db  old_v:(int)oldVersion new_v:(int)newVersion;
- (void)onDrop:(FMDatabase *)db;

- (void)load;
- (void)loadById:(int)mid;


@end


@class SQLiteOpenHelper;
@interface no320_db_base_table_model : NSObject

@property(nonatomic,retain,readwrite) NSString *table_name;
@property(nonatomic,assign,readwrite) int old_v;
@property(nonatomic,assign,readwrite) int new_v;
@property(nonatomic,retain,readwrite) SQLiteOpenHelper *open_helper;

- (id)init_with_table_name:(NSString *)name old_version:(int)old_v new_version:(int)new_v open_helper:(SQLiteOpenHelper *)helper;

@end

@interface no320_db_base_context : NSObject{
    FMDatabaseQueue *queue;
}

+ (id)sharedInstance;

@property(nonatomic,retain,readwrite) FMDatabase *db;
@property(nonatomic,assign,readwrite) BOOL traceExecution;
@property(nonatomic,assign,readwrite) BOOL logsErrors;


@property(nonatomic,retain,readonly) NSMutableArray *table_names;




/**
 *
 *
 *
 */
-(NSMutableArray *)find_by_sql:(NSString *)query_sql with_rs_callback:( no320_db_base_table_model *(^)(FMResultSet *_rs/*result set*/,int _line_num/*record in result number(from 0)*/))rs_block NS_AVAILABLE(10_6, 4_0);


/**
 * 所有返回一个字段的，都可以使用此
 *
 *
 */
-(int)find_one_column_by_sql:(NSString *)query_sql;


@end

@interface SQLiteOpenHelper : NSObject


@property(nonatomic,retain,readwrite) no320_db_base_context *context;

//super(context, DATABASE_NAME, null, DATABASE_VERSION);
-(id)init_with_database_name:(NSString *)name old_v:(NSString *)old_v  new_v:(NSString *)new_v  ;

- (void)registerModel:(no320_db_base_table_model *)table_model;

- (void)onCreate:(FMDatabase *)db;

- (void)onUpgrade:(FMDatabase *)db  old_v:(int)oldVersion new_v:(int)newVersion;

@end
