# SuperX Dash
Plasma-based application launcher for [SuperXOS](http://superxos.com)

# Build Dependencies
* QtQuick
* KF5 KIO
* KF5 Plasma

# Installation
This project uses `cmake` build system.
Run the following commands to compile and install the dashboard :

## 1. Clone this source code
```
git clone https://github.com/SuperXOS/superx-dash
```

## 2. Build the project
```
cd superx-dash
mkdir build && cd build
cmake ..
make -j$(nproc)
```

## 3. Install the Dashboard
```
sudo make -j$(nproc) install
```

After installing, add the `SuperX Application Dashboard` Widget to your plasma panel from the "Add Widgets" Menu

# Testing
The project can be tested with the `plasmawindowed` tool as a standalone application.
Install the project and run  :
```
plasmawindowed com.superxos.dash
```

# Bug Reports
Feel free to create issues in this repository to report bugs and discuss.