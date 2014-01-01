//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Alan Sparrow on 12/31/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <Foundation/Foundation.h>

// a forward declaration; we'll import the header in the .m
@class RSSChannel;
@class WebViewController;

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate,
NSXMLParserDelegate>

{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    RSSChannel *channel;
}

@property (nonatomic, strong) WebViewController *webViewController;
@property (nonatomic, strong) NSNumber *numOfRows;

- (void)fetchEntries;



@end

// A new protocol named ListViewControllerDelegate
@protocol ListViewControllerDelegate

// Classes that conform to this protocol must implement this method:
- (void)listViewController:(ListViewController *)lvc
              handleObject:(id)object;

@end
