# SecureEnclaveCrash
STR:
Run on iOS Simulator version 13 (Tested on 13.4 and 13.5)
Crash on `SecKeyCreateRandomKey`
![Crash Screenshot](Images/crash.png)

I've tried adding Swift Error Breakpoint, Exception Breakpoint, Symbolic Breakpoint, activating address sanitizer and zombie objects but I don't still get any useful information.