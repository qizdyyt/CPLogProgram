//
//  HBContactDept.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Reply_sub
@interface HBContactDept : NSObject
@property (nonatomic, copy) NSString *deptid;    //部门id
@property (nonatomic, copy) NSString *deptname;  //部门名称
@property (nonatomic, copy) NSMutableArray *depts; //部门列表 HBContactDept*
@property (nonatomic, copy) NSMutableArray *contacts; //联系人列表 HBContact*
@property (nonatomic, strong) HBContactDept * parentGroup;    //上级分组
@property (nonatomic, assign) BOOL selected;     //该组是否为选中状态
@end
