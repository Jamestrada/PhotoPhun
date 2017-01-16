//
//  TPPDetailViewController.h
//  PhotoPhun
//
//  Created by James Estrada on 16/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPPCollectionViewController.h"

@interface TPPDetailViewController : UIViewController

@property (nonatomic)NSDictionary *photo;
@property (nonatomic)IBOutlet UIImageView *imageView;
@property (nonatomic)IBOutlet UIView *backgroundView;
@property (nonatomic)IBOutlet UIView *centerView;
@property (nonatomic)IBOutlet UITextView *tipView;
@property (nonatomic)NSString *tipString;

@end
