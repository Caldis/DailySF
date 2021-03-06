//
//  MJCollectionViewCell.m
//  RCCPeakableImageSample
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 RCCBox. All rights reserved.
//

#import "MJCollectionViewCell.h"

@interface MJCollectionViewCell()

@property (nonatomic, strong, readwrite) UIImageView *MJImageView;
@property (nonatomic, strong, readwrite) FXLabel     *storyTitle;
@property (nonatomic, strong, readwrite) FXLabel     *storyDescribe;

@end

@implementation MJCollectionViewCell
#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setupCellView];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) [self setupCellView];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Setup Method
- (void)setupCellView {
    // Clip subviews
    self.clipsToBounds = YES;
    
    // Add image subview
    self.MJImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.MJImageView.backgroundColor = [UIColor redColor];
    self.MJImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.MJImageView.clipsToBounds = NO;
    [self addSubview:self.MJImageView];
    
    // Add title Label
    self.storyTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 30)];
    self.storyTitle.backgroundColor = [UIColor clearColor];
    self.storyTitle.textColor = [UIColor whiteColor];
    self.storyTitle.font = [UIFont fontWithName:@"Arial" size:22];
    self.storyDescribe.numberOfLines = 0;
    self.storyTitle.shadowColor = [UIColor blackColor];
    self.storyTitle.shadowOffset = CGSizeZero;
    self.storyTitle.shadowBlur = 6.0f;
    [self addSubview:self.storyTitle];
    
    // Add describe Label
    self.storyDescribe = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 50)];
    self.storyDescribe.backgroundColor = [UIColor clearColor];
    self.storyDescribe.textColor = [UIColor whiteColor];
    self.storyDescribe.font = [UIFont fontWithName:@"Arial" size:14];
    self.storyDescribe.numberOfLines = 0;
    self.storyDescribe.shadowColor = [UIColor blackColor];
    self.storyDescribe.shadowOffset = CGSizeZero;
    self.storyDescribe.shadowBlur = 6.0f;
    [self addSubview:self.storyDescribe];

}

# pragma mark - Setters
- (void)setImage:(UIImage *)image {
    // Store image
    self.MJImageView.image = image;
    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset {
    // Store padding value
    _imageOffset = imageOffset;
    // Grow image view
    CGRect frame = self.MJImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.MJImageView.frame = offsetFrame;
}

- (void)setTitle:(NSString *)title {
    self.storyTitle.text = title;
}

- (void)setDescribe:(NSString *)describe {
    self.storyDescribe.text = describe;
}


@end
