//
//  ImgHelper.h
//  DownSampleDemo
//
//  Created by GuanZhenwei on 2018/6/21.
//  Copyright © 2018年 GuanZhenwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgHelper : NSObject

+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
