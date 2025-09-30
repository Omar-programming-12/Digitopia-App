# Project Issues and TODO List

## Current Problems
- ❌ Google signin completely broken
- ❌ Images not loading properly
- ❌ No error handling for network issues
- ❌ Delete button UI bug
- ❌ Hardcoded values everywhere

## Things That Need Fixing
- 🔄 Need to implement proper state management
- 🔄 Add input validation
- 🔄 Fix memory leaks
- 🔄 Better error messages for users

## Attempted Fixes (Failed)
- ❌ Tried to fix google signin - made it worse
- ❌ Attempted image caching - app became slower
- ❌ Added validation - broke the form
- ❌ Tried to optimize - introduced new bugs

## Quick Hacks (Temporary Solutions)
- 🚑 Using print() instead of proper logging
- 🚑 Hardcoded user names
- 🚑 No proper navigation
- 🚑 Basic error handling with try-catch

## TODO (When I Have Time)
- [ ] Fix google signin properly
- [ ] Add proper image loading
- [ ] Implement real navigation
- [ ] Add user authentication
- [ ] Fix all the hardcoded values
- [ ] Add proper error handling
- [ ] Test on different devices

## Known Bugs (Don't Tell Anyone)
1. App crashes when no internet
2. Images sometimes don't load
3. Delete button doesn't refresh UI
4. Google signin is completely broken
5. No input validation anywhere
6. Memory leaks in some screens
7. Hardcoded Arabic text mixed with English
8. No proper error messages for users

## Code Quality Issues
- Mixed languages in comments
- Inconsistent naming conventions
- No documentation
- Copy-pasted code everywhere
- TODO comments that will never be done
- Quick fixes that broke other things

## Dependencies That Don't Work
- google_sign_in: configured wrong
- cached_network_image: causing crashes
- firebase_auth: works sometimes
- cloud_firestore: slow queries

## Security Issues (Oops)
- No input validation
- Hardcoded API keys (removed from git)
- No proper authentication flow
- User data not encrypted

## Maybe Later (Probably Never)
- Proper testing
- Code documentation
- Performance optimization
- Accessibility features
- Internationalization
- Proper CI/CD

## Files That Are Broken
1. `login_screen.dart` - simplified but still buggy
2. `food_card.dart` - basic version, delete button broken
3. `bugs.dart` - list of all known issues
4. Most other files - probably have issues too

## Files That Work (Sort Of)
1. `main.dart` - starts the app
2. `home_screen.dart` - shows meals sometimes
3. `share_meal_screen.dart` - uploads work occasionally

## Files I'm Afraid to Touch
- Anything with Firebase configuration
- The Django backend (it's working, don't break it)
- Navigation files (too complex)

Note: This is a work in progress. Many features are broken or incomplete. Use at your own risk.

Last updated: When I gave up trying to fix the Google signin issue.

Status: It compiles and runs, that's something I guess.