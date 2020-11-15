# SuperX Dash
Plasma-based application launcher for [SuperXOS](http://superxos.com)

**Disclaimer:** The software component is currently unreleased and untested for general consumption under the SuperX OS Project.

# Screenshots
<p align="center">
  <img src="https://gist.githubusercontent.com/anupam-git/7e2701be8d330e16001e00cec6033bac/raw/68bed6d78f2d868e81d123956a02184bce15373d/ss1.png" >
  <span><b>All Applications with Pinnned Items</b></span>
</p>

<p align="center">
  <img src="https://gist.githubusercontent.com/anupam-git/7e2701be8d330e16001e00cec6033bac/raw/68bed6d78f2d868e81d123956a02184bce15373d/ss2.png" >
  <span><b>KRunner Query Result</b></span>
</p>

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
