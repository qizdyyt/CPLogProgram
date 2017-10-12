//
//  HBContactInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Reply
@interface HBContactInfo : NSObject
@property (nonatomic, assign) BOOL modified;   //是否需要更新本地的联系人缓存文件 YES-需要更新 NO-不需要更新
@property (nonatomic, copy) NSString *updatedTime; //联系人列表的更新时间    需要更新时返回
@property (nonatomic, copy) NSMutableArray *depts; //部门列表 HBContactDept*
@property (nonatomic, copy) NSData *jsonData; //用以保存联系人到本地
@end
