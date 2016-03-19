//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookForTesting.h"
#import "VeeContact.h"
#import "VeeContactColors.h"
#import "VeecontactsForTestingFactory.h"
#import <XCTest/XCTest.h>

@interface VeeContactColorsTests : XCTestCase

@property (nonatomic, strong) VeeContactColors* veeContactColorsWithDefaultPalette;
@property (nonatomic, strong) VeeContactColors* veeContactColorsWithCustomPalette;
@end

static NSArray<id<VeeContactProt>>* randomVeeContacts;

@implementation VeeContactColorsTests

#pragma mark - Class setup

+ (void)setUp
{
    randomVeeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:50];
}

- (void)setUp
{
    [super setUp];
    _veeContactColorsWithDefaultPalette = [[VeeContactColors alloc] initWithVeeContactsDefaultColorPalette];
    _veeContactColorsWithCustomPalette = [[VeeContactColors alloc] initWithVeeContactsColorPalette:[self customColors]];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init tests

- (void)testInitWithDefaultColorPalette
{
    BOOL isDefaultPaletteCorrect = [_veeContactColorsWithDefaultPalette.veecontactColorsPalette isEqual:[_veeContactColorsWithDefaultPalette valueForKey:@"defaultColors"]];
    NSAssert(isDefaultPaletteCorrect, @"VeeContactColors default palette is not correct");
}

- (void)testInitWithCustomPalette
{
    NSAssert(_veeContactColorsWithCustomPalette.veecontactColorsPalette, @"VeeContactColors custom palette is not set");
}

#pragma mark - Default palette

- (void)testDefaultPaletteHasMoreThanTenColors
{
    BOOL defaultPaletteHasMoreThanTenColors = [_veeContactColorsWithDefaultPalette.veecontactColorsPalette count] > 10;
    NSAssert(defaultPaletteHasMoreThanTenColors, @"VeeContactColors has %zd colors but it should have > 10 colors", [_veeContactColorsWithDefaultPalette.veecontactColorsPalette count]);
}

#pragma mark - Colors

- (void)testDefaultPaletteColorForNilVeeContactShouldBeLightGray
{
    UIColor* colorForNilVeecontact = [_veeContactColorsWithDefaultPalette colorForVeeContact:nil];
    BOOL isColorForNilVeecontactLightGray = [colorForNilVeecontact isEqual:[UIColor lightGrayColor]];
    NSAssert(isColorForNilVeecontactLightGray, @"Color for nil veeContact is not lightGrayColor");
}

- (void)testCustomPaletteColorForNilVeeContactShouldBeLightGray
{
    UIColor* colorForNilVeecontact = [_veeContactColorsWithCustomPalette colorForVeeContact:nil];
    BOOL isColorForNilVeecontactLightGray = [colorForNilVeecontact isEqual:[UIColor lightGrayColor]];
    NSAssert(isColorForNilVeecontactLightGray, @"Color for nil veeContact is not lightGrayColor");
}

- (void)testColorForSameVeecontactsShouldBeEqual
{
    VeeContact* v1 = [randomVeeContacts firstObject];
    VeeContact* v2 = [randomVeeContacts firstObject]; //TODO: should be a copy
    UIColor* colorForVeecontact1 = [_veeContactColorsWithDefaultPalette colorForVeeContact:v1];
    UIColor* colorForVeecontact2 = [_veeContactColorsWithDefaultPalette colorForVeeContact:v2];
    BOOL colorsAreEqual = [colorForVeecontact1 isEqual:colorForVeecontact2];
    NSAssert(colorsAreEqual, @"Colors for same veeContact are not equal");
}

- (void)testColorsRandomnessDistribution
{
    NSMutableArray<UIColor*>* colors = [NSMutableArray new];
    for (VeeContact* veeContact in randomVeeContacts) {
        [colors addObject:[_veeContactColorsWithCustomPalette colorForVeeContact:veeContact]];
    }

    NSSet* colorsWithoutDuplicates = [NSSet setWithArray:colors];
    NSUInteger duplicateColors = [colors count] - [colorsWithoutDuplicates count];
    BOOL areDuplicateColorsLessThanHalf = duplicateColors < ([colors count] / 2);
    NSAssert(areDuplicateColorsLessThanHalf, @"Too many duplicate colors");
}

#pragma mark - Private utils

- (NSArray<UIColor*>*)customColors
{
    NSMutableArray<UIColor*>* customColors = [NSMutableArray array];
    for (float hue = 0.0; hue < 1.0; hue += 0.02) {
        UIColor* color = [UIColor colorWithHue:hue saturation:0.5 brightness:0.5 alpha:1.0];
        [customColors addObject:color];
    }
    return customColors;
}

@end
