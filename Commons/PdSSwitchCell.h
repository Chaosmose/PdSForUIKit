//
//  HPSwitchCell.h
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 28/06/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PdSSwitchCellDelegate <NSObject>
@required
-(void)switchWithIdentifier:(NSInteger)identifier status:(BOOL)status;
@end

@interface PdSSwitchCell : UITableViewCell

@property (assign,nonatomic) id<PdSSwitchCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UISwitch *stateSwitch;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (nonatomic)NSInteger identifier;

- (IBAction)switchHasChanged:(id)sender;


@end
