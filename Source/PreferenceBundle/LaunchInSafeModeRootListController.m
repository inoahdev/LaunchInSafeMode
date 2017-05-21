#include "LaunchInSafeModeRootListController.h"

@implementation LaunchInSafeModeRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"LaunchInSafeMode" target:self] retain];
	}

	return _specifiers;
}

@end
