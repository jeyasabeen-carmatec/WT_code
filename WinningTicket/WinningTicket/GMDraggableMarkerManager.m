//
//  GMDraggableMarkerManager.m
//  GoogleMapsDragAndDrop
//
//  Created by Robert Weindl on 6/30/13.
//
//

#import "GMDraggableMarkerManager.h"
#import <QuartzCore/CALayer.h>

// Default distance between touch point and position of the marker.
#define MARKER_ANIMATE_UP_DISTANCE 0.1f

// Default distance the marker jumps at the end of the drag gesture.
#define MARKER_ANIMATE_DOWN_DISTANCE 0.1f

// Default duration of marker jump up animation at start of the drag gesture.
#define MARKER_ANIMATE_UP_DEFAULT_DURATION 0.1f

// Default total duration of marker jump animation at end of the drag gesture.
#define MARKER_ANIMATE_DOWN_DEFAULT_DUATION 0.1f

// Default total duration of marker jump animation to the initial position at end of the drag gesture.
#define MARKER_ANIMATE_DOWN_TO_INITIAL_POSITION_DEFAULT_DUATION 0.1f

@interface GMDraggableMarkerManager()

@property (weak, nonatomic, readwrite) GMSMapView *mapView;
@property (weak, nonatomic, readwrite) id<GMDraggableMarkerManagerDelegate> delegate;

@property (strong, nonatomic, readwrite) GMSMarker *marker;
@property (strong, nonatomic, readwrite) UIImageView *markerImageView;
@property (strong, nonatomic, readwrite) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic, readwrite) NSMutableSet *markers;

@property (assign, nonatomic, readwrite) BOOL didDragMarker;
@property (assign, nonatomic, readwrite) BOOL didTapMarker;
@property (assign, nonatomic, readwrite) CGRect markerHitRect;
@property (assign, nonatomic, readwrite) CLLocationCoordinate2D initialMarkerPosition;

@end

@implementation GMDraggableMarkerManager

#pragma mark - Private Class methods

// Remove the GMSBlockingGestureRecognizer of the GMSMapView.
+ (void)removeGMSBlockingGestureRecognizerFromMapView:(GMSMapView *)mapView
{
    for (id gestureRecognizer in mapView.gestureRecognizers)
    {
        if (![gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            [mapView removeGestureRecognizer:gestureRecognizer];
        }
    }
}

#pragma mark - Lifecycle.
- (id)initWithMapView:(GMSMapView *)mapView delegate:(id<GMDraggableMarkerManagerDelegate>)delegate
{
    self = [super init];
    if (nil != self)
    {
        // Initialization of the map and delegates.
        self.delegate = delegate;
        self.mapView = mapView;
        
        // Initialize the markers set.
        self.markers = [[NSMutableSet alloc] init];
        
        // Initialize the marker UIImageView.
        self.markerImageView = [[UIImageView alloc] init];
        [self.mapView addSubview:self.markerImageView];
        
        // Initialize marker animation properties
        self.markerAnimateUpDistance = MARKER_ANIMATE_UP_DISTANCE;
        self.markerAnimateDownDistance = MARKER_ANIMATE_DOWN_DISTANCE;
        self.markerAnimateUpDuration = MARKER_ANIMATE_UP_DEFAULT_DURATION;
        self.markerAnimateDownDuration = MARKER_ANIMATE_DOWN_DEFAULT_DUATION;
        self.markerAnimateDownToInitialPositionDuration = MARKER_ANIMATE_DOWN_TO_INITIAL_POSITION_DEFAULT_DUATION;
        
        // Remove the GMSBlockingGestureRecognizer
        [GMDraggableMarkerManager removeGMSBlockingGestureRecognizerFromMapView:_mapView];
        
        // Add a custom long press gesture recognizer to the map.
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        self.longPressGestureRecognizer.minimumPressDuration = 0.1f;
        [self.mapView addGestureRecognizer:_longPressGestureRecognizer];
    }
    return self;
}

#pragma mark - Public Methods.
- (void)addDraggableMarker:(GMSMarker *)marker
{
    [self.markers addObject:marker];
}

- (void)removeDraggableMarker:(GMSMarker *)marker
{
    [self.markers removeObject:marker];
}

- (void)removeAllDraggableMarkers
{
    [self.markers removeAllObjects];
}

- (NSArray *) draggableMarkers
{
    return [self.markers allObjects];
}

#pragma mark - Gesture Reconizer.
- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)recognizer
{
    // Extract the touch point on the GoogleMaps view.
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    
    // Before the rect can be created the closest marker to the touch point must be determined.
    if (UIGestureRecognizerStateBegan == recognizer.state)
    {
        // Call the mapView:didLongPressAtCoordinate: delegate method.
        // This method has the same functionality than the method mapView:didBeginDraggingMarker:.
        // The method is implemented to avoid conflicts with the GMSMapViewDelegate.
        if ([self.delegate respondsToSelector:@selector(mapView:didLongPressAtCoordinate:)])
        {
            [self.delegate mapView:self.mapView didLongPressAtCoordinate:[self.mapView.projection coordinateForPoint:touchPoint]];
        }
        
        // Determine the closest marker.
        self.marker = [self determineClosestMarkerForTouchPoint:touchPoint];
        
        // Load the UIImageView for the marker.
        [self loadImageViewForMarker:self.marker];
        
        // Rect used to determine if user actually touched the closest marker.
        self.markerHitRect = self.markerImageView.frame;
    }
    
    // Check if a close by marker could be determined.
    if (nil != self.marker)
    {
        CGPoint markerPoint = [self.mapView.projection pointForCoordinate:self.marker.position];
         
        // In the UIGestureRecognizerStateBegan there must be a check if there was a long press on the marker.
        if (UIGestureRecognizerStateBegan == recognizer.state)
        {
            // Check if touch point is in the rect.
            if (CGRectContainsPoint(self.markerHitRect, touchPoint))
            {
                // Display the marker's UIImageView.
                [self.markerImageView.layer setOpacity:1.0f];
                
                // Deselect the current on the map view selected marker if it is not the long pressed one.
                if (self.mapView.selectedMarker != self.marker)
                {
                    self.mapView.selectedMarker = nil;
                }
                
                // Disable the gestures of the GoogleMaps view for a better user experience.
                [self enableGoogleMapViewSettings:NO];
                
                // Save that the marker was tapped.
                self.didTapMarker = YES;
                
                // Save the initial marker position.
                self.initialMarkerPosition = self.marker.position;
                                
                // Remove the marker of the mapView.
                self.marker.map = nil;
                
                // Animate the marker.
                CGRect newFrame = self.markerImageView.frame;
                newFrame.origin.y -= (markerPoint.y - touchPoint.y) + self.markerAnimateUpDistance;
                [UIView animateWithDuration:self.markerAnimateUpDuration
                                 animations:^(void)
                                 {
                                     self.markerImageView.frame = newFrame;
                                 }
                                 completion:^(BOOL finished)
                                 {
                                    // Notify delegate of drag event at end of initial animation
                                    if ([self.delegate respondsToSelector:@selector(mapView:didBeginDraggingMarker:)])
                                    {
                                        [self.delegate mapView:self.mapView didBeginDraggingMarker:self.marker];
                                    }
                                 }];

            }
            else
            {
                // No marker was hit so reset the draggable marker manager.
                [self resetDraggableMarkerManager];
            }
        }
        else if (UIGestureRecognizerStateChanged == recognizer.state)
        {            
            // Check if the marker was long pressed before.
            if (self.didTapMarker)
            {
                // The user started to drag the marker, so there is no longer any intention to restore the old state.
                if (!CGRectContainsPoint(self.markerHitRect, touchPoint) &&
                    NO == self.didDragMarker)
                {
                    // The marker was dragged.
                    self.didDragMarker = YES;
                }
                
                // Move the image view to the correct position for the updated touch point.
                CGSize imageSize = self.markerImageView.image.size;
                self.markerImageView.frame = CGRectMake(touchPoint.x - (self.marker.groundAnchor.x * imageSize.width),
                                                        touchPoint.y - (self.marker.groundAnchor.y * imageSize.height) - self.markerAnimateUpDistance,
                                                        imageSize.width,
                                                        imageSize.height);
                                
                // Check if there was a significant change of the initial position in comparison to the touch point.
                if (YES == self.didDragMarker)
                {
                    // Notify the delegate of a drag event.
                    if ([self.delegate respondsToSelector:@selector(mapView:didDragMarker:)])
                    {
                        [self.delegate mapView:self.mapView didDragMarker:self.marker];
                    }
                }
            }
        }
        else if (UIGestureRecognizerStateEnded == recognizer.state)
        {
            __block CGRect newFrame = self.markerImageView.frame;
            
            // Only store the new position of the marker if the marker was dragged.
            CLLocationCoordinate2D markerPosition;
            if (!self.didDragMarker)
            {
                // Restore the initial marker position.
                markerPosition = self.initialMarkerPosition;
            }
            else
            {
                // Determine the new marker position.
                CGSize imageSize = self.markerImageView.image.size;
                CGPoint newMarkerOrigin = CGPointMake(newFrame.origin.x + (self.marker.groundAnchor.x * imageSize.width),
                                                      newFrame.origin.y + (self.marker.groundAnchor.y * imageSize.height));
                markerPosition = [self.mapView.projection coordinateForPoint:newMarkerOrigin];
            }
            
            // Animate the marker to jump up.
            newFrame.origin.y -= self.markerAnimateDownDistance;
            [UIView animateWithDuration:(self.markerAnimateDownDuration/2.0)
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^(void)
                             {
                                self.markerImageView.frame = newFrame;
                             }
                             completion:^(BOOL finished)
                             {
                                 // Animate the marker to land again.
                                 [UIView animateWithDuration:(self.markerAnimateDownDuration/2.0)
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^(void)
                                                  {
                                                      newFrame.origin.y += self.markerAnimateDownDistance;
                                                      self.markerImageView.frame = newFrame;
                                                  }
                                                  completion:^(BOOL finished)
                                                  {           
                                                      if (NO == self.didDragMarker)
                                                      {
                                                          // Marker was not dragged so animate it back to its inital position.
                                                          [UIView animateWithDuration:self.markerAnimateDownToInitialPositionDuration
                                                                                delay:0
                                                                              options:UIViewAnimationOptionCurveLinear
                                                                           animations:^(void)
                                                                           {
                                                                               newFrame = self.markerHitRect;
                                                                               self.markerImageView.frame = newFrame;
                                                                           }
                                                                           completion:^(BOOL finished)
                                                                           {
                                                                               // Finally, update the position of the marker we are dragging.
                                                                               self.marker.position = markerPosition;
                                                               
                                                                               // And add it back on the map.
                                                                               self.marker.map = self.mapView;
                                                                               
                                                                               // Fade out the markerImageView to avoid blinking of the marker.
                                                                               [UIView animateWithDuration:0.10
                                                                                                     delay:0
                                                                                                   options:UIViewAnimationOptionCurveLinear                                                                                animations:^(void)
                                                                                                {
                                                                                                    [self.markerImageView.layer setOpacity:0.0f];
                                                                                    
                                                                                                }
                                                                                                completion:^(BOOL finished)
                                                                                                {
                                                                                    
                                                                                                    // Notify delegate before we reset.
                                                                                                    if ([self.delegate respondsToSelector:@selector(mapView:didCancelDraggingMarker:)])
                                                                                                    {
                                                                                                        [self.delegate mapView:self.mapView didCancelDraggingMarker:self.marker];
                                                                                                    }
                                                                                                    // Reset the draggable marker manager.
                                                                                                    [self resetDraggableMarkerManager];
                                                                                }];
                                                                           }];
                                                       }
                                                       else
                                                       {
                                                           // Finally, update the position of the marker we are dragging.
                                                           self.marker.position = markerPosition;
                                                           
                                                           // And add it back on the map.
                                                           self.marker.map = self.mapView;
                                                           
                                                           // Fade out the markerImageView to avoid blinking of the marker.
                                                           [UIView animateWithDuration:0.10
                                                                                 delay:0
                                                                               options:UIViewAnimationOptionCurveEaseIn
                                                                            animations:^(void){
                                                                                [self.markerImageView.layer setOpacity:0.0f];
                                                                                
                                                                            }
                                                                            completion:^(BOOL finished)
                                                                            {
                                                                                // Notify delegate before we reset.
                                                                                if ([self.delegate respondsToSelector:@selector(mapView:didEndDraggingMarker:)])
                                                                                {
                                                                                    [self.delegate mapView:self.mapView didEndDraggingMarker:self.marker];
                                                                                }
                                                                                // Reset the draggable marker manager.
                                                                                [self resetDraggableMarkerManager];
                                                                            }];

                                                       }
                                                  }];
                             }];                        
        }
        else
        {
            // Reset the draggable marker manager.
            [self resetDraggableMarkerManager];
        }
    }
    else
    {
        // Reset the draggable marker manager.
        [self resetDraggableMarkerManager];
    }
}

#pragma mark - Map Control.
// Enables or disables all GoogleMap View Settings.
- (void)enableGoogleMapViewSettings:(BOOL)enable {

    if (enable)
    {
        self.mapView.settings.scrollGestures = YES;
        self.mapView.settings.zoomGestures = YES;
        self.mapView.settings.tiltGestures = YES;
        self.mapView.settings.rotateGestures = YES;
    }
    else
    {
        self.mapView.settings.scrollGestures = NO;
        self.mapView.settings.zoomGestures = NO;
        self.mapView.settings.tiltGestures = NO;
        self.mapView.settings.rotateGestures = NO;
    }
}

#pragma mark - Helper methods.
// Determine the closest marker.
- (GMSMarker *)determineClosestMarkerForTouchPoint:(CGPoint)touchPoint
{
    // Initialize the return value.
    GMSMarker *resultMarker = nil;
    
    // Initialize the initial distance as the maximum of CGFloat.
    CGFloat smallestDistance = CGFLOAT_MAX;
    CGFloat distance = CGFLOAT_MAX;
    
    // Determine the closest draggable marker to the current touch point
    for (GMSMarker *marker in self.markers)
    {
        CGPoint markerPoint = [self.mapView.projection pointForCoordinate:marker.position];
        CGFloat xDistance = (touchPoint.x - markerPoint.x);
        CGFloat yDistance = (touchPoint.y - markerPoint.y);
        distance = sqrt((xDistance * xDistance) + (yDistance * yDistance));
        
        // Check if a closer marker was found.
        if (distance <= smallestDistance)
        {            
            resultMarker = marker;
            smallestDistance = distance;
        }
    }
    return resultMarker;
}

// Reset the draggable marker manager.
- (void)resetDraggableMarkerManager
{
    // Reset the control properties.
    self.didTapMarker = NO;
    self.didDragMarker = NO;
    
    // Enable the gestures of the GoogleMaps view for a better user experience.
    [self enableGoogleMapViewSettings:YES];
    
    // The marker is no longer selected.
    self.marker = nil;

    // Remove the GMSBlockingGestureRecognizer.
    [GMDraggableMarkerManager removeGMSBlockingGestureRecognizerFromMapView:self.mapView];
}

// Generate an UIImageView for the marker used for animation.
- (void)loadImageViewForMarker:(GMSMarker *)marker
{
    if (nil != marker)
    {
        // Get the current marker image or use the default marker image supplied in the Google Maps bundle.
        UIImage *currentMarkerImage;
        if (nil != self.marker.icon)
        {
            currentMarkerImage = self.marker.icon;
        }
        else
        {
            currentMarkerImage = [UIImage imageNamed:@"GoogleMaps.bundle/default_marker"];
        }
        
        // Receive the point in the view for the marker.
        CGPoint markerPoint = [self.mapView.projection pointForCoordinate:marker.position];
        
        [self.markerImageView setImage:currentMarkerImage];
        [self.markerImageView setFrame: CGRectMake(markerPoint.x - (self.marker.groundAnchor.x * currentMarkerImage.size.width),
                                                   markerPoint.y - (self.marker.groundAnchor.y * currentMarkerImage.size.height),
                                                   currentMarkerImage.size.width,
                                                   currentMarkerImage.size.height)];

    }
}

@end
