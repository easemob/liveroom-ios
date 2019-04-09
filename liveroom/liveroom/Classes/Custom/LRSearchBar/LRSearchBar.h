//
//  TCSearchBar.h
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/3.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRSearchBarDelegate;
@interface LRSearchBar : UIView

@property (nonatomic, weak) id<LRSearchBarDelegate> delegate;

@property (nonatomic, strong) UITextField *textField;

@end

@protocol LRSearchBarDelegate <NSObject>

@optional

- (void)searchBarShouldBeginEditing:(LRSearchBar *)searchBar;

- (void)searchBarCancelAction:(LRSearchBar *)searchBar;

- (void)searchTextDidChangeWithString:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
