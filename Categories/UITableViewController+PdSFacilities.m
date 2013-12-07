//
//  UITableViewController+PdSFacilities.m
//  Pods
//
//  Created by Benoit Pereira da Silva on 07/12/2013.
//
//

#import "UITableViewController+PdSFacilities.h"

@implementation UITableViewController (PdSFacilities)


-(BOOL)indexPathIsTheLastInSection:(NSIndexPath*)indexPath{
    NSInteger c=[self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    return (indexPath.row==(c-1));
}

@end
