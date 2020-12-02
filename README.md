# thepcosprotocol_app

The PCOS Protocol App.

## Running the app

The PCOS Protocol app is built using Flutter.

There are three flavors for the app:
    - dev
    - staging
    - prod
    
To build and run the app locally using Android Studio you can use the Configurations dropdown to
choose which flavor you wish to build and run.

To build and run from the command line use one of the following commands:

flutter run --target lib/main_dev.dart --flavor dev
flutter run --target lib/main_staging.dart --flavor staging
flutter run --target lib/main_prod.dart --flavor prod

Each flavor can be installed on a simulator/emulator or on a physical device side by side.

A banner is displayed top left in the app showing which flavor is running, and another banner top 
right showing whether the app is running in debug mode. Long pressing on the flavor banner displays 
details of the device the app is running on.

