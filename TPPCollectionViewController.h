//
//  TPPCollectionViewController.h
//  PhotoPhun
//
//  Created by James Estrada on 15/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SimpleAuth/SimpleAuth.h>
#import "TPPDetailViewController.h"

extern NSString *const DATA_VERSION_DATE;
extern NSString *const DATA_FORMAT;


@interface TPPCollectionViewController : UICollectionViewController

@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *likedArray;
@property (nonatomic) NSMutableArray *venueArray;

@end
