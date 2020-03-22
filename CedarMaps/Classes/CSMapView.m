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

@interface CSMapView()
@property (nonatomic, strong) NSObject *localObserver;
@property (nonatomic, strong) NSString *currentStyle;
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
	[self.logoView setContentMode:UIViewContentModeScaleAspectFit];
    self.attributionButton.alpha = 0;
    self.layer.backgroundColor = [UIColor colorWithRed: 249.0/255.0 green: 245.0/255.0 blue: 237.0/255.0 alpha: 1.0].CGColor;
    
    self.localObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kCedarMapsAccessTokenIsReadeyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *token = [note.userInfo objectForKey:kCedarMapsAccessTokenIsReadeyNotification];
        [MGLAccountManager setAccessToken:token];
        
        if (!self.currentStyle) {
            [self setDefaultStyleURL];
        } else {
            [self setStyleURL:[NSURL URLWithString:self.currentStyle]];
        }
    }];
    
    if ([[CSAuthenticationManager sharedAuthenticationManager] isAccessTokenSaved]) {
        [self setDefaultStyleURL];
    }
    
    [self setNeedsLayout];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:_localObserver];
}

- (void)setStyleURL:(NSURL *)styleURL {
    if (!styleURL) {
        return;
    }
    if (!self.currentStyle && [self.currentStyle isEqualToString:styleURL.absoluteString]) {
        return;
    }
    
    self.currentStyle = styleURL.absoluteString;
    if ([styleURL.absoluteString containsString:@"access_token"]) {
        [super setStyleURL:styleURL];
    } else {
        [[CSAuthenticationManager sharedAuthenticationManager] accessToken:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (token) {
                NSString *urlStr = [NSString stringWithFormat:@"%@?access_token=%@", styleURL.absoluteString, token];
                NSString *encodedURLStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [super setStyleURL:[NSURL URLWithString:encodedURLStr]];
            }
        }];
    }
}

- (void)setDefaultStyleURL {
    __weak CSMapView *weakSelf = self;
    [[CSAuthenticationManager sharedAuthenticationManager] accessToken:^(NSString * _Nullable token, NSError * _Nullable error) {
        if (token) {
            NSString *urlStr = [NSString stringWithFormat:@"%@styles/cedarmaps.light.json?access_token=%@", [[CSAuthenticationManager sharedAuthenticationManager] baseURL], token];
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

- (NSBundle *)assetsBundle {
    NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
    NSURL *bundleURL = [podBundle URLForResource:@"Assets" withExtension:@"bundle"];
    if (bundleURL) {
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        return bundle;
    }
    return nil;
}

@end

