//
//  HPStepperCell.h
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 06/09/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PdSStepperCellDelegate <NSObject>
@required
-(void)stepperWithIdentifier:(NSInteger)identifier setValue:(double)value;
@end


@interface PdSStepperCell : UITableViewCell

/**
 *  The delegate
 */
@property (assign,nonatomic) id<PdSStepperCellDelegate>delegate;

/**
 *  If the pivot is 5 the value will be between -5 and 5
 */
@property (assign,nonatomic) double pivot;

/**
 *  The label
 */
@property (weak, nonatomic) IBOutlet UILabel *incrementLabel;

/**
 *  The stepper
 */
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

/**
 *  The identifier to deal with multiple occurence delegation
 */
@property (nonatomic)NSInteger identifier;

/**
 *  The message (check displayIndexes)
 */
@property (copy,nonatomic)NSString *message;

/**
 *  When set to YES the message includes a signed display of the value 
 *  For ex : "Score +3" where +3 is "%@" format specifier
 *  Else you can set any message.
*/
@property (nonatomic)BOOL displayIndexes;

/**
 *  Called on stepper has changed
 *  Handles the delegate
 *
 *  @param sender the stepper
 */
- (IBAction)stepperValueHasChanged:(id)sender;


/**
 * The public method to set the stepper value
 **/
- (void)setStepperValue:(double)value;


@end

