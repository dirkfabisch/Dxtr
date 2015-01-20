# Dxtr
iOS App for reading Dexcom sensor data

Based on the work from Stephen Black (http://stephenblackwasalreadytaken.github.io/DexDrip).

It uses the DexDrip Wixel Hardware described on his site.

The iOS app will connect tor the HW via Bluetooth and read the sensor data via wifi.

## Done
* Basic Setup
* Discover DexDrip HW automatically (no BlueTooth pairing needed)
* Connect to DexDrip and read raw data
* Create database stub

## Working on
* Store data in DB

## Backlog
* Get calibration data
* calculate BG value from raw data
* display BG value as graph

tbc

### Building the app
I use sketch for my graphic ressources and add all assets automatically in the asset catalog.

I added a build phase for that: "Insert Sketch Ressources" using sketchtool for that. based on an idea from Matt Zanchelli (http://mdznr.roon.io/automatically-exporting-assets-from-sketch-into-xcode)

```
# AppIcon
/usr/local/bin/sketchtool export artboards "$PROJECT_DIR"/"Graphics Resources/AppIcon.sketch" --output="$PROJECT_DIR"/"$PROJECT_NAME"/Images.xcassets/AppIcon.appiconset --formats="png"
```
