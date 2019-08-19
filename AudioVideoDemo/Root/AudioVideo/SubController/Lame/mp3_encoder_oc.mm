//
//  mp3_encoder.m
//  AudioVideoDemo
//
//  Created by LFZ on 2019/8/18.
//  Copyright © 2019 LFZ. All rights reserved.
//

#import "mp3_encoder_oc.h"
#import "mp3_encoder.hpp"

@implementation mp3_encoder_oc

+ (void)encodePCMToMP3:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pcmStr = [documentsDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@.pcm", name]];
    NSString *mp3Str = [documentsDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@.mp3", name]];
    
    Mp3Encoder* encoder = new Mp3Encoder;
    encoder->Init([pcmStr UTF8String], [mp3Str UTF8String], 44100, 2, 16 * 1000);
    encoder->Encode();
    encoder->Destory();
}

@end
