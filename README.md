_**If your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `SVProgressHUD.m` in Target Settings > Build Phases > Compile Sources._

# SweepingProgressBar

SweepingProgressBar is an improved implementation of [TYIndeterminateProgressBar](http://www.cocoacontrols.com/controls/tyindeterminateprogressbar) that appears by dropping down from the top of the view and animating smoothly back and forth until dismiss is called.


## Installation

* Drag the `SweepingProgressBar/SweepingProgressBar` folder into your project.
* Add the **QuartzCore** framework to your project.

## Usage

(see sample Xcode project in `/Demo`)

SweepingProgressBar is created as a singleton (i.e. it doesn't need to be explicitly allocated and instantiated; you directly call `[SweepingProgressBar method]`).

### Showing the bar

You can show the status of inderterminate tasks using:

```objective-c
+ (void)showInView:(UIView *)view;
+ (void)showInView:(UIView *)view backgroundColor: cbgColor indicatorColor: cindicatorColor borderColor: cborderColor;
```

To dismiss the progress bar, use

```objective-c
+ (void)dismiss;
```
