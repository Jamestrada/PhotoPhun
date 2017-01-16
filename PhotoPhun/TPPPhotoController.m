//
//  TPPPhotoController.m
//  PhotoPhun
//
//  Created by James Estrada on 16/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

#import "TPPPhotoController.h"

@implementation TPPPhotoController

+(void)imageForPhoto:(NSDictionary*)photo size:(NSString*)size completion:(void(^)(UIImage *image))completion{
    
    if(photo == nil || size == nil || completion == nil){
        NSLog(@"missing argument for imageForPhoto");
        return;
    }
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@%@%@", [photo valueForKeyPath:@"response.venue.bestPhoto.prefix"], size, [photo valueForKeyPath:@"response.venue.bestPhoto.suffix"]];
    
    //NSString *key = urlString; //SAMCache doesn't work with characters before a forward slash
    NSString *key = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@""]; //need to remove forward slashes to form a valid key that works with SAMCache
    UIImage *cachedPhoto = [[SAMCache sharedCache]imageForKey:key];
    //we will check if there's already an image with the imageForKey key.
    if(cachedPhoto){
        completion(cachedPhoto);
        return;
    }
    //if there's not an image, we will download the bestPhoto and cache it
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [[NSData alloc]initWithContentsOfURL:location]; //location saved on file
        UIImage *image = [[UIImage alloc]initWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    
    [task resume];
}

@end
