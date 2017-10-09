//
//  HBApplicationItem.h
//  hbmiddleware
//
//  Created by hebca on 14-3-31.
//  Copyright (c) 2014年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBApplicationItem : NSObject

/*
 功能描述：初始化业务申请单项信息。
 参数：
 参数	        类型	             输入/输出	描述
 itemInfoData	NSDictionary*	 IN	        业务申请单项信息
 返回值：成功返回申请单信息对象，如果失败，返回nil
 */
-(id)initWithApplicationItemInfo:(NSDictionary*)itemInfoData;

/*
 功能描述：返回申请单项目的名称。
 参数：无
 返回值：成功返回申请单项目名称，如果失败，返回nil。
 */
-(NSString*)getItemName;

/*
 功能描述：返回申请单项目的中文名称。
 参数：无
 返回值：成功返回申请单项目中文名称，如果失败，返回nil。
 */
-(NSString*)getItemNameCN;

/*
 功能描述：获取申请单项目的类型。
 返回值：申请单项目的类型。
 */
-(NSString*)getItemType;

/*
 功能描述：返回申请单项目的最大长度限制。
 参数：无
 返回值：申请单项目的最大长度。
 */
-(NSInteger)getItemMaxLength;

/*
 功能描述：申请单项目是否可以为空。
 返回值：YES表示可以为空，NO表示不可以为空。
 */
-(BOOL)ItemCanBeNull;

/*
 功能描述：获取申请单项目可用的有效值，设置的申请单数据需从中选取。
 返回值：可用的有效值，nil表示服务器没有指定可选值。
 */
-(NSArray*)getValidValues;

/*
 功能描述：设置申请单项数据。
 参数：
 参数	    类型	        输入/输出	  描述
 itemData	NSString*	IN	      申请单项数据
 返回值：成功返回HB_OK，如果失败，返回错误码。
 */
-(NSInteger)setApplicationItemData:(NSString*)itemData;

/*
 功能描述：返回申请单项数据。
 参数：无
 返回值：成功返回申请单项数据，如果失败，返回nil。
 */
-(NSString*)getApplicationItemData;

@end
