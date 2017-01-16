//
//  TPPPhotoController.h
//  PhotoPhun
//
//  Created by James Estrada on 16/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SAMCache/SAMCache.h>

@interface TPPPhotoController : NSObject

+(void)imageForPhoto:(NSDictionary*)photo size:(NSString*)size completion:(void(^)(UIImage *image))completion;


@end
