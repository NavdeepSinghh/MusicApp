//
//  ViewController.h
//  MusicApp
//
//  Created by Navdeep  Singh on 7/7/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewContolMedia;
- (IBAction)play:(id)sender;
- (IBAction)stop:(id)sender;

@end

