PdSForUIKit
===========

A set of usefull categories bases classes for UIKit. 


## Installation using cocoapods

    Add this line to your pod file 
    pod 'PdSForUIKit', {:git => 'https://github.com/benoit-pereira-da-silva/PdSForUIKit.git'}

## UIView+RectCorner Magic extension 

With PdSForUIKit you can mask a UITableViewCell, or any other with round corner and add custom borders without sacrifying performance.

###  UIAPPEARANCE support :

	[[PdSUITableViewCell appearance] setRectCorners:UIRectCornerAllCorners];
    [[PdSUITableViewCell appearance] setRadius:10.f];
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    [[PdSUITableViewCell appearance] setPadding:UIEdgeInsetsMake(10.f, 20.f, 20.f,0.f)];
   
You can support round corner and borders with UIAPPEARANCE Proxy support  any UIView descendent only by :

    #import "UIView+RectCorners.h"
    
    And overriding : 
    
    - (void)layoutSubviews{
	    [self remaskIfNecessary];
    	[super layoutSubviews];
	}
	
I have included base classes samples  PdSUITableViewCell, PdSUIView and PdSUIButton


### Using the categories facilities selector :
	

    [self setRectCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                  radius:7.f
            withPadding:UIEdgeInsetsMake(5.f, 20.f, 0.f, 20.f)];

    [cell setRectCorners:UIRectCornerTopLeft|UIRectCornerTopRight
               radius:7.f
                  top:5.f
               bottom:0.f
                 left:20.f
                right:20.f];
 	... 
 
	