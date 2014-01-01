//
//  ChannelViewController.h
//  Nerdfeed
//
//  Created by Alan Sparrow on 1/1/14.
//  Copyright (c) 2014 Alan Sparrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@class RSSChannel;

@interface ChannelViewController : UITableViewController <ListViewControllerDelegate,
UISplitViewControllerDelegate>

{
    RSSChannel *channel;
}


@end
