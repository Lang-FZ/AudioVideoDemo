//
//  mp3_encoder.h
//  AudioVideoDemo
//
//  Created by LFZ on 2019/8/18.
//  Copyright © 2019 LFZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface mp3_encoder_oc : NSObject

+ (void)encodePCMToMP3:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
