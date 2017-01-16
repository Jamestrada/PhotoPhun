//
//  TPPUICollectionViewCell.m
//  PhotoPhun
//
//  Created by James Estrada on 15/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

#import "TPPUICollectionViewCell.h"
#import "TPPPhotoController.h"

@implementation TPPUICollectionViewCell

-(void)setPhotoData:(NSDictionary *)photoData{
    _photoData = photoData;
    
    [TPPPhotoController imageForPhoto:photoData size:@"100x100" completion:^(UIImage *image) {
        self.photoView.image = image;
    }];
}
@end
