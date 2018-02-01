//
//  VC_select_Hole.m
//  WinningTicket
//
//  Created by jeya sabeen on 04/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import "VC_select_Hole.h"
#import "VC_score_collection.h"

@interface VC_select_Hole () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation VC_select_Hole

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_VIEW];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_SCRL_contents layoutIfNeeded];
    [_SCRL_contents setContentSize:CGSizeMake(_SCRL_contents.frame.size.width, _VW_contents.frame.origin.y + _VW_contents.frame.size.height)];
}

#pragma mark - COllection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VC_score_collection *cell = (VC_score_collection *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.num_label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
   
    cell.des_lbl.text = @"Eagle";
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return CGSizeMake(self.view.frame.size.width/3 -10 , 120);
    }
    else
    {
        return CGSizeMake(self.view.frame.size.width/3 -10 , 80);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.cornerRadius = cell.contentView.frame.size.width / 2;
    cell.contentView.backgroundColor = [UIColor greenColor];
        
    NSLog(@"Selected index = %ld",(long)indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.0];
}

#pragma mark - Uiview customisation
-(void) setup_VIEW
{
    _collec_contents.dataSource = self;
    _collec_contents.delegate = self;
    [_collec_contents reloadData];
    [_collec_contents layoutIfNeeded];
    
    CGRect frame_rect = _collec_contents.frame;
    frame_rect.size.height = _collec_contents.contentSize.height;
    _collec_contents.frame = frame_rect;
    
    frame_rect = _BTN_continue.frame;
    frame_rect.origin.y = _collec_contents.frame.origin.y + _collec_contents.frame.size.height + 10;
    _BTN_continue.frame = frame_rect;
    
    CGRect frame_VW = _VW_contents.frame;
    frame_VW.size.height = _BTN_continue.frame.origin.y + _BTN_continue.frame.size.height + 10;
    frame_VW.size.width = self.view.frame.size.width;
    _VW_contents.frame = frame_VW;
    
    [_SCRL_contents addSubview:_VW_contents];
    
    [_BTN_continue addTarget:self action:@selector(ACTIN_continue) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Uibutton Actions
-(void) ACTIN_continue
{
    [self performSegueWithIdentifier:@"enter_GAME" sender:self];
}

@end
