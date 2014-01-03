//
//  HPSwitchCell.m
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 28/06/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import "PdSSwitchCell.h"

@implementation PdSSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (IBAction)switchHasChanged:(id)sender {
    [self.delegate switchWithIdentifier:self.identifier
                                 status:self.stateSwitch.isOn];
}
@end
