//
//  MBProgressHUD.h
//  Version 0.8
//  Created by Matej Bukovinski on 2.4.09.
//

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright (c) 2013 Matej Bukovinski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol MBProgressHUDDelegate;


typedef enum {
	/** Progress is shown using an UIActivityIndicatorView. This is the default. */
	MBProgressHUDModeIndeterminate,
	/** Progress is shown using a round, pie-chart like, progress view. */
	MBProgressHUDModeDeterminate,
	/** Progress is shown using a horizontal progress bar */
	MBProgressHUDModeDeterminateHorizontalBar,
	/** Progress is shown using a ring-shaped progress view. */
	MBProgressHUDModeAnnularDeterminate,
	/** Shows a custom view */
	MBProgressHUDModeCustomView,
	/** Shows only labels */
	MBProgressHUDModeText
} MBProgressHUDMode;

typedef enum {
	/** Opacity animation */
	MBProgressHUDAnimationFade,
	/** Opacity + scale animation */
	MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomOut = MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomIn
} MBProgressHUDAnimation;


#ifndef MB_INSTANCETYPE
#if __has_feature(objc_instancetype)
	#define MB_INSTANCETYPE instancetype
#else
	#define MB_INSTANCETYPE id
#endif
#endif

#ifndef MB_STRONG
#if __has_feature(objc_arc)
	#define MB_STRONG strong
#else
	#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
	#define MB_WEAK weak
#elif __has_feature(objc_arc)
	#define MB_WEAK unsafe_unretained
#else
	#define MB_WEAK assign
#endif
#endif

#if NS_BLOCKS_AVAILABLE
typedef void (^MBProgressHUDCompletionBlock)();
#endif

#define iOS_7_Above ([[UIDevice currentDevice].systemVersion floatValue]>=7.0)


/** 
 * Displays a simple HUD window containing a progress indicator and two optional labels for short messages.
 *
 * This is a simple drop-in class for displaying a progress HUD view similar to Apple's private UIProgressHUD class.
 * The MBProgressHUD window spans over the entire space given to it by the initWithFrame constructor and catches all
 * user input on this region, thereby preventing the user operations on components below the view. The HUD itself is
 * drawn centered as a rounded semi-transparent view which resizes depending on the user specified content.
 *
 * This view supports four modes of operation:
 * - MBProgressHUDModeIndeterminate - shows a UIActivityIndicatorView
 * - MBProgressHUDModeDeterminate - shows a custom round progress indicator
 * - MBProgressHUDModeAnnularDeterminate - shows a custom annular progress indicator
 * - MBProgressHUDModeCustomView - shows an arbitrary, user specified view (@see customView)
 *
 * All three modes can have optional labels assigned:
 * - If the labelText property is set and non-empty then a label containing the provided content is placed below the
 *   indicator view.
 * - If also the detailsLabelText property is set then another label is placed below the first label.
 */
@interface MBProgressHUD : UIView

/**
 * Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
 * 
 * @param view The view that the HUD will be added to
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 * @return A reference to the created HUD.
 *
 * @see hideHUDForView:animated:
 * @see animationType
 */
+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview and hides it. The counterpart to this method is showHUDAddedTo:animated:.
 *
 * @param view The view that is going to be searched for a HUD subview.
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @return YES if a HUD was found and removed, NO otherwise. 
 *
 * @see showHUDAddedTo:animated:
 * @see animationType
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds all the HUD subviews and hides them. 
 *
 * @param view The view that is going to be searched for HUD subviews.
 * @param animated If set to YES the HUDs will disappear using the current animationType. If set to NO the HUDs will not use
 * animations while disappearing.
 * @return the number of HUDs found and removed.
 *
 * @see hideHUDForView:animated:
 * @see animationType
 */
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview and returns it. 
 *
 * @param view The view that is going to be searched.
 * @return A reference to the last HUD subview discovered.
 */
+ (MB_INSTANCETYPE)HUDForView:(UIView *)view;

/**
 * Finds all HUD subviews and returns them.
 *
 * @param view The view that is going to be searched.
 * @return All found HUD views (array of MBProgressHUD objects).
 */
+ (NSArray *)allHUDsForView:(UIView *)view;

/**
 * A convenience constructor that initializes the HUD with the window's bounds. Calls the designated constructor with
 * window.bounds as the parameter.
 *
 * @param window The window instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the window that the HUD will be added to).
 */
- (id)initWithWindow:(UIWindow *)window;

/**
 * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
 * view.bounds as the parameter
 *
 * @param view The view instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the view that the HUD will be added to).
 */
- (id)initWithView:(UIView *)view;

/** 
 * Display the HUD. You need to make sure that the main thread completes its run loop soon after this method call so
 * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
 * (e.g., when using something like NSOperation or calling an asynchronous call like NSURLRequest).
 *
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 *
 * @see animationType
 */
- (void)show:(BOOL)animated;

/** 
 * Hide the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 *
 * @see animationType
 */
- (void)hide:(BOOL)animated;

/** 
 * Hide the HUD after a delay. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @param delay Delay in seconds until the HUD is hidden.
 *
 * @see animationType
 */
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/** 
 * Shows the HUD while a background task is executing in a new thread, then hides the HUD.
 *
 * This method also takes care of autorelease pools so your method does not have to be concerned with setting up a
 * pool.
 *
 * @param method The method to be executed while the HUD is shown. This method will be executed in a new thread.
 * @param target The object that the target method belongs to.
 * @param object An optional object to be passed to the method.
 * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will not use
 * animations while (dis)appearing.
 */
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

#if NS_BLOCKS_AVAILABLE

/**
 * Shows the HUD while a block is executing on a background queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block;

/**
 * Shows the HUD while a block is executing on a background queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * Shows the HUD while a block is executing on the specified dispatch queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue;

/** 
 * Shows the HUD while a block is executing on the specified dispatch queue, executes completion block on the main queue, and then hides the HUD.
 *
 * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will
 * not use animations while (dis)appearing.
 * @param block The block to be executed while the HUD is shown.
 * @param queue The dispatch queue on which the block should be executed.
 * @param completion The block to be executed on completion.
 *
 * @see completionBlock
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
		  completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * A block that gets called after the HUD was completely hidden.
 */
@property (copy) MBProgressHUDCompletionBlock completionBlock;

#endif

/** 
 * MBProgressHUD operation mode. The default is MBProgressHUDModeIndeterminate.
 *
 * @see MBProgressHUDMode
 */
@property (assign) MBProgressHUDMode mode;

/**
 * The animation type that should be used when the HUD is shown and hidden. 
 *
 * @see MBProgressHUDAnimation
 */
@property (assign) MBProgressHUDAnimation animationType;

/**
 * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
 * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds). 
 */
@property (MB_STRONG) UIView *customView;

/** 
 * The HUD delegate object. 
 *
 * @see MBProgressHUDDelegate
 */
@property (MB_WEAK) id<MBProgressHUDDelegate> delegate;

//任务处理结果
@property (assign) NSInteger taskResult;
//错误信息
@property (copy) NSString *errorMessage;

/** 
 * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
 * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
 * set to @"", then no message is displayed.
 */
@property (copy) NSString *labelText;

/** 
 * An optional details message displayed below the labelText message. This message is displayed only if the labelText
 * property is also set and is different from an empty string (@""). The details text can span multiple lines. 
 */
@property (copy) NSString *detailsLabelText;

/** 
 * The opacity of the HUD window. Defaults to 0.8 (80% opacity). 
 */
@property (assign) float opacity;

/**
 * The color of the HUD window. Defaults to black. If this property is set, color is set using
 * this UIColor and the opacity property is not used.  using retain because performing copy on
 * UIColor base colors (like [UIColor greenColor]) cause problems with the copyZone.
 */
@property (MB_STRONG) UIColor *color;

/** 
 * The x-axis offset of the HUD relative to the centre of the superview. 
 */
@property (assign) float xOffset;

/** 
 * The y-axis offset of the HUD relative to the centre of the superview. 
 */
@property (assign) float yOffset;

/**
 * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views). 
 * Defaults to 20.0
 */
@property (assign) float margin;

/**
 * The corner radius for th HUD
 * Defaults to 10.0
 */
@property (assign) float cornerRadius;

/** 
 * Cover the HUD background view with a radial gradient. 
 */
@property (assign) BOOL dimBackground;

/*
 * Grace period is the time (in seconds) that the invoked method may be run without 
 * showing the HUD. If the task finishes before the grace time runs out, the HUD will
 * not be shown at all. 
 * This may be used to prevent HUD display for very short tasks.
 * Defaults to 0 (no grace time).
 * Grace time functionality is only supported when the task status is known!
 * @see taskInProgress
 */
@property (assign) float graceTime;

/**
 * The minimum time (in seconds) that the HUD is shown. 
 * This avoids the problem of the HUD being shown and than instantly hidden.
 * Defaults to 0 (no minimum show time).
 */
@property (assign) float minShowTime;

/**
 * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
 * If you don't set a graceTime (different than 0.0) this does nothing.
 * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
 * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
 * you need to set this property when your task starts and completes in order to have normal graceTime 
 * functionality.
 */
@property (assign) BOOL taskInProgress;

/**
 * Removes the HUD from its parent view when hidden. 
 * Defaults to NO. 
 */
@property (assign) BOOL removeFromSuperViewOnHide;

/** 
 * Font to be used for the main label. Set this property if the default is not adequate. 
 */
@property (MB_STRONG) UIFont* labelFont;

/**
 * Color to be used for the main label. Set this property if the default is not adequate.
 */
@property (MB_STRONG) UIColor* labelColor;

/**
 * Font to be used for the details label. Set this property if the default is not adequate.
 */
@property (MB_STRONG) UIFont* detailsLabelFont;

/** 
 * Color to be used for the details label. Set this property if the default is not adequate.
 */
@property (MB_STRONG) UIColor* detailsLabelColor;

/** 
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0. 
 */
@property (assign) float progress;

/**
 * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
 */
@property (assign) CGSize minSize;

/**
 * Force the HUD dimensions to be equal if possible. 
 */
@property (assign, getter = isSquare) BOOL square;

/**
 * Whether using blur background, support iOS7 above only now
 * Default YES, use blur background
 */
@property (nonatomic,assign) BOOL blur;

/**
 * lightBlur or darkBlur
 * Default NO, add light blur
 */
@property (nonatomic,assign) BOOL darkBlur;

@end


@protocol MBProgressHUDDelegate <NSObject>

@optional

/** 
 * Called after the HUD was fully hidden from the screen. 
 */
- (void)hudWasHidden:(MBProgressHUD *)hud;

@end


/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
@interface MBRoundProgressView : UIView 

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor]
 */
@property (nonatomic, MB_STRONG) UIColor *progressTintColor;

/**
 * Indicator background (non-progress) color.
 * Defaults to translucent white (alpha 0.1)
 */
@property (nonatomic, MB_STRONG) UIColor *backgroundTintColor;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end


/**
 * A flat bar progress view. 
 */
@interface MBBarProgressView : UIView

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Bar border line color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, MB_STRONG) UIColor *lineColor;

/**
 * Bar background color.
 * Defaults to clear [UIColor clearColor];
 */
@property (nonatomic, MB_STRONG) UIColor *progressRemainingColor;

/**
 * Bar progress color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, MB_STRONG) UIColor *progressColor;

@end

typedef enum {
    MMBlurUndefined = 0,
    MMStaticBlur = 1,
    MMLiveBlur = 2
} MMBlurType;

@class MMBlurComponents;

@interface MMBlurView : UIView

+ (MMBlurView *) load:(UIView *) view;
+ (MMBlurView *) loadWithLocation:(CGPoint) point parent:(UIView *) view;
+ (MMBlurView *) loadWithLocation:(CGPoint) point parent:(UIView *) view frame:(CGRect)frame;
- (void) unload;
- (void) blurWithColor:(MMBlurComponents *) components;
//For realtime animate
- (void) blurWithColor:(MMBlurComponents *) components updateInterval:(float) interval;

@end

@interface MMBlurComponents : NSObject

@property(nonatomic) CGFloat radius;
@property(nonatomic, MB_STRONG) UIColor *tintColor;
@property(nonatomic, assign) CGFloat saturationDeltaFactor;
@property(nonatomic) UIImage *maskImage;

///Light color effect.
+ (MMBlurComponents *) lightEffect;

///Dark color effect.
+ (MMBlurComponents *) darkEffect;

///Coral color effect.
+ (MMBlurComponents *) coralEffect;

///Neon color effect.
+ (MMBlurComponents *) neonEffect;

///Sky color effect.
+ (MMBlurComponents *) skyEffect;

@end

@interface UIImage (ImageEffects)

- (UIImage *)applyBlurWithCrop:(CGRect) bounds resize:(CGSize) size blurRadius:(CGFloat) blurRadius tintColor:(UIColor *) tintColor saturationDeltaFactor:(CGFloat) saturationDeltaFactor maskImage:(UIImage *) maskImage;

@end

/*
 使用例子
#define SCREENSHOT_MODE 0


@implementation HudDemoViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
	UIView *content = [[self.view subviews] objectAtIndex:0];
#if SCREENSHOT_MODE
	[content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
#endif
	((UIScrollView *)self.view).contentSize = content.bounds.size;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	UIView *content = [[self.view subviews] objectAtIndex:0];
	((UIScrollView *)self.view).contentSize = content.bounds.size;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)showSimple:(id)sender {
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithLabel:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithDetailsLabel:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"updating data";
	HUD.square = YES;
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithLabelDeterminate:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWIthLabelAnnularDeterminate:(id)sender {
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeAnnularDeterminate;
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithLabelDeterminateHorizontalBar:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate bar mode
	HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
	
	HUD.delegate = self;
	
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithCustomView:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = @"Completed";
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:3];
}

- (IBAction)showWithLabelMixed:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Connecting";
	HUD.minSize = CGSizeMake(135.f, 135.f);
	
	[HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showUsingBlocks:(id)sender {
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"With a block";
	
	[hud showAnimated:YES whileExecutingBlock:^{
		[self myTask];
	} completionBlock:^{
		[hud removeFromSuperview];
		[hud release];
	}];
#endif
}

- (IBAction)showOnWindow:(id)sender {
	// The hud will dispable all input on the window
	HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
	[self.view.window addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showURL:(id)sender {
	NSURL *URL = [NSURL URLWithString:@"http://a1408.g.akamai.net/5/1408/1388/2005110403/1a1a1ad948be278cff2d96046ad90768d848b41947aa1986/sample_iPod.m4v.zip"];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection start];
	[connection release];
	
	HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
	HUD.delegate = self;
}


- (IBAction)showWithGradient:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showTextOnly:(id)sender {
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = @"Some message...";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:3];
}

- (IBAction)showWithColor:(id)sender{
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set the hud to display with a color
	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	
	HUD.delegate = self;
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(3);
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
}

- (void)myMixedTask {
	// Indeterminate mode
	sleep(2);
	// Switch to determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Progress";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
	// Back to indeterminate mode
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Cleaning up";
	sleep(2);
	// UIImageView is a UIKit class, we have to initialize it on the main thread
	__block UIImageView *imageView;
	dispatch_sync(dispatch_get_main_queue(), ^{
		UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
		imageView = [[UIImageView alloc] initWithImage:image];
	});
	HUD.customView = [imageView autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
	sleep(2);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	expectedLength = MAX([response expectedContentLength], 1);
	currentLength = 0;
	HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

@end
*/