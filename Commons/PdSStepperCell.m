//
//  HPScoreCell.m
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 06/09/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import "PdSStepperCell.h"

@implementation PdSStepperCell

@synthesize pivot = _pivot;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (double)pivot{
    return _pivot;
}

- (void)setPivot:(double)pivot{
    _pivot=pivot;
    self.stepper.minimumValue=0.0;
    self.stepper.wraps=NO;
    self.stepper.continuous=YES;
    self.stepper.maximumValue=_pivot*2.0;
    self.stepper.stepValue=1.0;
}

- (IBAction)stepperValueHasChanged:(id)sender{
    //WTLog(@"stepperValueHasChanged : %f (Min %f / Max %f | step %f) ",self.stepper.value,self.stepper.minimumValue,self.stepper.maximumValue,self.stepper.stepValue);
    
    [self setStepperValue:self.stepper.value];
}


- (void)setStepperValue:(double)value{
    self.stepper.value=value;
    if(self.pivot){
        [self.delegate stepperWithIdentifier:self.identifier
                                    setValue:value];
        int displayValue=(int)value-self.pivot;
        NSString *signedDisplayString=@"";
        if(displayValue>=0){
            signedDisplayString=[NSString stringWithFormat:@"+ %i",abs(displayValue)];
        }else{
            signedDisplayString=[NSString stringWithFormat:@"- %i",abs(displayValue)];
        }
        if(self.message){
            if(self.displayIndexes){
            [self.incrementLabel setText:[NSString stringWithFormat:self.message,signedDisplayString]];
            }else{
                [self.incrementLabel setText:self.message];
            }
        }else{
            [self.incrementLabel setText:[NSString stringWithFormat:@"%@",signedDisplayString]];
        }
    }else{
        [self.incrementLabel setText:@"ERROR NO PIVOT"];
    }

}


@end