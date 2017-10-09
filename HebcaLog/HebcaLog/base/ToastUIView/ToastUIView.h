/***************************************************************************
 
Toast+UIView.h
Toast
Version 2.0

Copyright (c) 2013 Charles Scalesse.
 
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
***************************************************************************/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Toast)

// each makeToast method creates a view and displays it as toast
- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

// displays toast with an activity spinner
- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

// the showToast methods display any view as toast
- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

/*
 使用方法
[self.view makeToast:@"This is a piece of toast."];

[self.view makeToast:@"This is a piece of toast with a title."
                duration:3.0
                position:@"top"
                   title:@"Toast Title"];

[self.view makeToast:@"This is a piece of toast with an image."
                duration:3.0
                position:@"center"
                   image:[UIImage imageNamed:@"toast.png"]];

[self.view makeToast:@"This is a piece of toast with a title & image"
                duration:3.0
                position:@"bottom"
                   title:@"Toast Title"
                   image:[UIImage imageNamed:@"toast.png"]];


UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 400)] autorelease];
    [customView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)]; // autoresizing masks are respected on custom views
    [customView setBackgroundColor:[UIColor orangeColor]];
    
    [self.view showToast:customView
                duration:2.0
                position:@"center"];


UIImageView *toastView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast.png"]] autorelease];
    
    [self.view showToast:toastView
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(110, 110)]]; // wrap CGPoint in an NSValue object
    
    break;
}

    if (_isShowingActivity) {
        [_activityButton setTitle:@"Hide Activity" forState:UIControlStateNormal];
        [self.view makeToastActivity];
    } else {
        [_activityButton setTitle:@"Show Activity" forState:UIControlStateNormal];
        [self.view hideToastActivity];
    }
    _isShowingActivity = !_isShowingActivity;
*/


@end
