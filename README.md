_**If your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `SVProgressHUD.m` in Target Settings > Build Phases > Compile Sources._

# SweepingProgressBar

SweepingProgressBar is an improved implementation of [TYIndeterminateProgressBar](http://www.cocoacontrols.com/controls/tyindeterminateprogressbar) that appears by dropping down from the top of the view and animating smoothly back and forth until dismiss is called.

Here's a screenshot of it working:
http://cl.ly/image/3L3n3y1e2G26
![SweepingProgressBar](http://f.cl.ly/items/0M2N3n05341q1s2a1O1G/Screen%20Shot%202013-01-27%20at%203.59.13%20PM.png)

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
