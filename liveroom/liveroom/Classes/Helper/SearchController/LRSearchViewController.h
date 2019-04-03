//
//  EMSearchViewController.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/1/16.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "LRRefreshViewController.h"

#import "LRSearchBar.h"
#import "LRRealtimeSearch.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRSearchViewController : LRRefreshViewController<LRSearchBarDelegate>

@property (nonatomic) BOOL isSearching;

@property (nonatomic, strong) LRSearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) UITableView *searchResultTableView;

@end

NS_ASSUME_NONNULL_END
