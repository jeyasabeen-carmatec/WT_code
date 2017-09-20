//
//  similar_collectioncell.h
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface similar_collectioncell : UICollectionViewCell
@property(nonatomic,weak) IBOutlet UIImageView *IMG_similar;
@property(nonatomic,weak) IBOutlet UILabel *LBl_item_name;
@property(nonatomic,weak) IBOutlet UILabel *price;

@end
