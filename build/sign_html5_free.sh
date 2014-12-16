#!/bin/sh
# 事前工作：
# 1、复制1024.png和icon.icns到Contents/Resources目录下
# 2、修改Contents目录下的info.plist，增加Application Category::Graphics Design

chmod -R 777 ../app/HTML5SlideshowMakerFree.app
rm "../app/HTML5SlideshowMakerFree.app/Contents/Frameworks/Adobe AIR.framework/Versions/Current/Resources/WebKit.dylib"

codesign -f -v -s "3rd Party Mac Developer Application: iYoya Inc." "../app/HTML5SlideshowMakerFree.app/Contents/Frameworks/Adobe AIR.framework/Versions/1.0/Resources/AdobeCP15.plugin"
codesign -f -v -s "3rd Party Mac Developer Application: iYoya Inc." "../app/HTML5SlideshowMakerFree.app/Contents/Frameworks/Adobe AIR.framework/Versions/1.0/Resources/Flash Player.plugin"
codesign -f -v -s "3rd Party Mac Developer Application: iYoya Inc." "../app/HTML5SlideshowMakerFree.app/Contents/Frameworks/Adobe AIR.framework/Versions/1.0/Resources/adobecp.plugin"
codesign -f -v -s "3rd Party Mac Developer Application: iYoya Inc." "../app/HTML5SlideshowMakerFree.app/Contents/Frameworks/Adobe AIR.framework/Versions/1.0"

codesign -f --entitlements toview.entitlements -v -s "3rd Party Mac Developer Application: iYoya Inc." "../app/HTML5SlideshowMakerFree.app/Contents/Resources/assets/toview"
codesign -f --entitlements html5_slide.entitlements -v -s "3rd Party Mac Developer Application: iYoya Inc." "../app/HTML5SlideshowMakerFree.app"

productbuild --component ../app/HTML5SlideshowMakerFree.app /Applications ../HTML5SlideshowMakerFree120.pkg --sign "3rd Party Mac Developer Installer: iYoya Inc."

#sudo installer -store -pkg "/Users/iyoya/Documents/HTML5SlideshowMakerFree110.pkg" -target /
