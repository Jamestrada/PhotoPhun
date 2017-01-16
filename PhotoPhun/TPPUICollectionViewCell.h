//
//  TPPUICollectionViewCell.h
//  PhotoPhun
//
//  Created by James Estrada on 15/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMCache/SAMCache.h>

@interface TPPUICollectionViewCell : UICollectionViewCell

@property (nonnull) IBOutlet UIImageView *photoView;
@property (nonnull, nonatomic) NSDictionary *photoData;

@end
