# DerivedFileManager

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

### Turning Tracing On and Off
To control tracing for a specific file manager instance, you can use the `DBTraceOn` and `DBTraceOff` methods. Here's how you might do it:

```clarion
! To turn on tracing for a table
ACCESS:TableName.DBTraceOn()

! To turn off tracing for the same table
ACCESS:TableName.DBTraceOff()

! Sending a custom trace message
ACCESS:TableName.TRACE('Your custom message here')

