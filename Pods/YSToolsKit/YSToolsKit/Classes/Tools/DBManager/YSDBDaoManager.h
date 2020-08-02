//
//  YSDBDaoManager.h
//  Pod
//
//  Created by Joseph Koh on 2017/5/8.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 数据库操作对象
@interface YSDBDaoManager : NSObject

/// 数据库CURD操作单例对象
/// 直接调用方法, 使用时无需手动创建数据库和表格
+ (instancetype _Nullable )shareManager;

@end

/// 数据库删除操作分类
@interface YSDBDaoManager (Delete)
/// 删除数据库中所有的表格
- (void)dropAllTable;

- (BOOL)deleteToDB:(NSObject *_Nullable)model;
- (void)deleteToDB:(NSObject *_Nullable)model callback:(void (^_Nullable)(BOOL result))block;

- (BOOL)deleteWithClass:(Class _Nullable )modelClass where:(nullable id)where;
- (void)deleteWithClass:(Class _Nullable )modelClass where:(nullable id)where callback:(void (^_Nullable)(BOOL result))block;

- (BOOL)deleteWithTableName:(NSString *_Nullable)tableName where:(nullable id)where;

@end


/// 数据库插入数据操作分类
@interface YSDBDaoManager (Insert)

- (BOOL)insertToDB:(NSObject *_Nullable)model;
- (void)insertToDB:(NSObject *_Nullable)model callback:(void (^_Nullable)(BOOL result))block;

- (BOOL)insertWhenNotExists:(NSObject *_Nullable)model;
- (void)insertWhenNotExists:(NSObject *_Nullable)model callback:(void (^_Nullable)(BOOL result))block;

@end


@interface YSDBDaoManager (Update)

- (BOOL)updateToDB:(NSObject *_Nullable)model where:(nullable id)where;
- (void)updateToDB:(NSObject *_Nullable)model where:(nullable id)where callback:(void (^_Nullable)(BOOL result))block;

- (BOOL)updateToDB:(Class _Nullable )modelClass set:(NSString *_Nullable)sets where:(nullable id)where;
- (BOOL)updateToDBWithTableName:(NSString *_Nullable)tableName set:(NSString *_Nullable)sets where:(nullable id)where;

@end


/// 数据库查询数据操作分类
@interface YSDBDaoManager (Search);

/**
 *	@brief	query table
 *
 *	@param 	modelClass      entity class
 *	@param 	where           can use NSString or NSDictionary or nil
 
 *	@param 	orderBy         The Sort: Ascending "name asc",Descending "name desc"
 For example: @"rowid desc"x  or @"rowid asc"
 
 *	@param 	offset          Skip how many rows
 *	@param 	count           Limit the number
 *
 *	@return	query finished result is an array(model instance collection)
 */
- (nullable NSMutableArray *)search:(Class _Nullable )modelClass
                              where:(nullable id)where
                            orderBy:(nullable NSString *)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;

/**
 *  query sql, query finished result is an array(model instance collection)
 *  you can use the "@t" replace Model TableName
 *  query sql use lowercase string
 *  查询的sql语句 请使用小写 ，否则会不能自动获取 rowid
 *  example:
 NSMutableArray *array = [[LKDBHelper getUsingLKDBHelper] searchWithSQL:@"select * from @t where blah blah.." toClass:[ModelClass class]];
 *
 */
- (nullable NSMutableArray *)searchWithSQL:(NSString *_Nullable)sql toClass:(nullable Class)modelClass;

/**
 *  @brief don't do any operations of the sql
 */
- (nullable NSMutableArray *)searchWithRAWSQL:(NSString *_Nullable)sql toClass:(nullable Class)modelClass;

/**
 *  query sql, query finished result is an array(model instance collection)
 *  you can use the "@t" replace Model TableName and replace all ? placeholders with the va_list
 *  example:
 NSMutableArray *array = [[LKDBHelper getUsingLKDBHelper] searc:[ModelClass class] withSQL:@"select rowid from name_table where name = ?", @"Swift"];
 *
 */
- (nullable NSMutableArray *)search:(Class _Nullable )modelClass withSQL:(NSString *_Nullable)sql, ...;

/**
 columns may NSArray or NSString   if query column count == 1  return single column string array
 other return models entity array
 */
- (nullable NSMutableArray *)search:(Class _Nullable )modelClass
                             column:(nullable id)columns
                              where:(nullable id)where
                            orderBy:(nullable NSString *)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;

/**
 *  @brief  async search
 */
- (void)search:(Class _Nullable )modelClass
         where:(nullable id)where
       orderBy:(nullable NSString *)orderBy
        offset:(NSInteger)offset
         count:(NSInteger)count
      callback:(void (^_Nullable)(NSMutableArray * _Nullable array))block;

///return first model or nil
- (nullable id)searchSingle:(Class _Nullable )modelClass where:(nullable id)where orderBy:(nullable NSString *)orderBy;


@end
