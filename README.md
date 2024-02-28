# DerivedFileManager
 Derived FileManager Example

## Overview
`DerivedFileManager` is an example project showcasing how to extend the ABC FileManager in Clarion. It includes two Clarion files: `ModFM.INC` (a class definition) and `ModFM.CLW` (source code), which derive from the ABC FileManager. This extension adds several methods to enhance the functionality of the original FileManager, making it more versatile, especially for SQL file management.

## Features
The `DerivedFileManager` class introduces the following methods to the ABC FileManager:
- `IsSQLFile`: Determines if the file is an SQL file.
- `DBTraceOn`: Activates Clarion table tracing for the file, with output directed to `OutputDebugString`.
- `DBTraceOff`: Deactivates Clarion table tracing for the file, stopping output to `OutputDebugString`.
- `TRACE`: Sends a message to `OutputDebugString`, prefixed by the table name.

Additionally, the derived `Init` method demonstrates setting the file's `PROP:Alias` to the prefix of the file, a technique beneficial for SQL definitions.

## Installation
To integrate `DerivedFileManager` into your Clarion projects, follow these steps:
1. Copy `ModFM.INC` and `ModFM.CLW` to your `ClarionDirectory\Accessories\libsrc\Win` directory.
2. For each application that requires `DerivedFileManager`, navigate to the Global Properties:
   - Go to `Actions` > `Classes` Tab > `File Management`.
   - Select `ModFM` from the FileManager dropdown menu.

This process ensures that your application uses the enhanced file management capabilities provided by `DerivedFileManager`.

## Usage
After integrating `DerivedFileManager` into your project, you can utilize the new methods in your file management routines. This extension is particularly useful for applications that work with SQL files and require detailed debugging and tracing capabilities.

## Contributing
Contributions to `DerivedFileManager` are welcome. If you have improvements or bug fixes, please open a pull request or issue in this repository.

