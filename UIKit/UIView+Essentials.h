//
//  UIView+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"
#import "ESSEvent.h"





@interface UIView (Essentials)



#pragma mark - Snapshots
//TODO - drawViewHierarchyInRect

/// Returns snapshot of the receiver with screen scale.
- (UIImage *)snapshot;

/// Returns snapshot of the receiver with given scale.
- (UIImage *)snapshotWithScale:(CGFloat)scale;

/// Returns image view containing snapshot of the receiver.
- (UIImageView *)makeSnapshotImageView;

/// Creates snapshot image view and inserts it just above the receiver. This is intended to be invisible action for the user.
- (UIImageView *)overlayWithSnapshotImageView;



#pragma mark - Corner Radius

/// Forwards to the underlaying layer.
@property (nonatomic, readwrite) IBInspectable CGFloat cornerRadius;

/// Forwards to undelaying layer and sets rasterization scale to screen scale.
@property (nonatomic, readwrite, assign) IBInspectable BOOL shouldRasterize;



/// Opacity of background color.
@property (nonatomic, readwrite, assign) CGFloat backgroundAlpha;

/// Inverse to .hidden property.
@property BOOL isVisible;



#pragma mark - Geometry

/// Alias for .center
@property (nonatomic) IBInspectable CGPoint position;

/// Proxy for .layer.anchorPoint
@property (nonatomic) IBInspectable CGPoint relativeAnchorPoint;

/// Multiplies .relativeAnchorPoint with .bounds.size, setting this moves the receiver.
@property (nonatomic) IBInspectable CGPoint anchorPoint;

/// Changes .anchorPoint and .position so that the view doesn’t move.
- (void)moveAnchorPointTo:(CGPoint)anchorPoint;

/// Rotation around Z axis in degrees!
@property (nonatomic) IBInspectable CGFloat rotation;

/// X and Y scale, when they differ, geometric average is returned (√XY).
@property (nonatomic) IBInspectable CGFloat scale;

/// X and Y scales separately.
@property (nonatomic) IBInspectable CGSize scales;

/// Translation from .transform
@property (nonatomic) IBInspectable CGPoint translation;

/// Sets .translation relative to .position so that final position is specified point (in superview coordinates).
- (void)translateTo:(CGPoint)position;



#pragma mark - Shadow

/// Wraps all shadow attributes in single object. Color is premultiplied by alpha, since NSShadow doesn't have opacity property.
@property (nonatomic, readwrite) IBOutlet NSShadow *shadow;

/// Forwards to the underlaying layer, transforms CGSize to UIOffset.
@property (nonatomic, readwrite) IBInspectable CGPoint shadowOffset;

/// Forwards to the underlaying layer, transforms color classes.
@property (nonatomic, readwrite) IBInspectable UIColor *shadowColor;

/// Forwards to the underlaying layer.
@property (nonatomic, readwrite) IBInspectable CGFloat shadowBlurRadius;

/// Forwards to the underlaying layer.
@property (nonatomic, readwrite) IBInspectable CGFloat shadowAlpha;

/// Forwards to the underlaying layer, transforms CGPathRef to UIBezierPath and vice versa.
@property (nonatomic, readwrite) UIBezierPath *shadowPath;



#pragma mark - Border

@property (nonatomic, readwrite) IBInspectable CGFloat borderWidth;

@property (nonatomic, readwrite) IBInspectable UIColor *borderColor;



#pragma mark - Structs Adjustments

/// Allows you to quickly adjust frame.
- (void)adjustFrame:(void(^)(CGRect *frame))block;

/// Allows you to quickly adjust bounds.
- (void)adjustBounds:(void(^)(CGRect *bounds))block;

/// Allows you to quickly adjust center.
- (void)adjustCenter:(void(^)(CGPoint *center))block;

/// Allows you to quickly adjust transform.
- (void)adjustTransform:(CGAffineTransform(^)(CGAffineTransform transform))block;



/// Recursively enuemerates all subviews.
- (void)enumerateSubviewsRecursivelyWithBlock:(void (^)(UIView *view, BOOL *stop))block;


- (void)crossDissolveWithDuration:(NSTimeInterval)duration animations:(void(^)(void))animations;



#pragma mark - Interaction

- (void)addVerticalMotionEffectWithIntensity:(CGFloat)intensity;
- (void)addHorizontalMotionEffectWithIntensity:(CGFloat)intensity;

//! Creates a drag interaction and adds it to the receiver. Creates item provider from given string.
- (UIDragInteraction *)enableDragWithString:(NSString *)string;
//! Creates a drag interaction and adds it to the receiver. Creates item provider from given fileURL.
- (UIDragInteraction *)enableDragWithFileURL:(NSURL *)fileURL;
//! Creates a drag interaction and adds it to the receiver.
- (UIDragInteraction *)enableDragWithItem:(NSItemProvider *)itemProvider;

- (void)removeAllInteractions;



#pragma mark - Events

@property (readonly) ESSEvent<UIColor *> *onTintColorChange; //!< Value is current tint color.
@property (readonly) ESSEvent<UITraitCollection *> *onTraitCollectionChange; //!< Value is previous trait collection.


#pragma mark - Debugging

- (void)debugDisplayBackgrounds;
- (void)debugDisplayBorders;




@end
