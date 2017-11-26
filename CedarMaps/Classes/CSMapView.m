//
//  CSMapView.m
//  CedarMaps
//
//  Created by Saeed Taheri on 10/22/17.
//

#import "CSMapView.h"
#import "CSAuthenticationManager.h"

@interface MGLMapView()
- (MGLAnnotationImage *)defaultAnnotationImage;
@end

@implementation CSMapView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame styleURL:(NSURL *)styleURL {
    self = [super initWithFrame:frame styleURL:styleURL];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup {
    NSBundle *bundle = [self assetsBundle];
    [self.logoView setImage:[UIImage imageNamed:@"cedarmaps" inBundle:bundle compatibleWithTraitCollection:nil]];
    self.attributionButton.alpha = 0;
    self.layer.backgroundColor = [UIColor colorWithRed: 249.0/255.0 green: 245.0/255.0 blue: 237.0/255.0 alpha: 1.0].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCedarMapsAccessTokenIsReadeyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *token = [note.userInfo objectForKey:kCedarMapsAccessTokenIsReadeyNotification];
        [MGLAccountManager setAccessToken:token];
        [self setupStyleURL];
    }];
    
    if ([[CSAuthenticationManager sharedAuthenticationManager] isAccessTokenSaved]) {
        [self setupStyleURL];
    }
    
    [self setNeedsLayout];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupStyleURL {
    __weak CSMapView *weakSelf = self;
    [[CSAuthenticationManager sharedAuthenticationManager] accessToken:^(NSString * _Nullable token, NSError * _Nullable error) {
        if (token) {
            NSString *urlStr = [NSString stringWithFormat:@"%@tiles/light.json?access_token=%@", [[CSAuthenticationManager sharedAuthenticationManager] baseURL], token];
            NSString *encodedURLStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [weakSelf setStyleURL:[NSURL URLWithString:encodedURLStr]];
        }
    }];
}

- (MGLAnnotationImage *)defaultAnnotationImage
{
    MGLAnnotationImage *annotationImage = [super defaultAnnotationImage];
    
    NSBundle *bundle = [self assetsBundle];
    if (bundle) {
        UIImage *image = [UIImage imageNamed:@"cedarmaps_default" inBundle:bundle compatibleWithTraitCollection:nil];
        image = [image imageWithAlignmentRectInsets:
                 UIEdgeInsetsMake(0, 0, image.size.height / 2, 0)];
        
        if (image) {
            [annotationImage setImage:image];
        }
    }

    return annotationImage;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat rightInset = self.contentInset.right + 8;
    CGFloat bottomInset = self.contentInset.bottom + 8;
    if (@available(iOS 11.0, *)) {
        rightInset += self.safeAreaInsets.right;
        bottomInset += self.safeAreaInsets.bottom;
    }
    
    self.logoView.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.logoView.bounds) - rightInset,
                                     CGRectGetHeight(self.bounds) - CGRectGetHeight(self.logoView.bounds) - bottomInset,
                                     CGRectGetWidth(self.logoView.bounds),
                                     CGRectGetHeight(self.logoView.bounds));
}

- (NSBundle *)assetsBundle {
    NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
    NSURL *bundleURL = [podBundle URLForResource:@"CedarMaps" withExtension:@"bundle"];
    if (bundleURL) {
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        return bundle;
    }
    return nil;
}

@end

