                    MEMBER()
    PRAGMA ('define(init_priority=>19)')
    INCLUDE('ModFM.inc'),ONCE
    INCLUDE('ABUTIL.INC'),ONCE

                    MAP
                        MODULE('win32')
                            FMODS(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
                        END 
                    END


ModFM.Init          PROCEDURE(File File, ErrorClass E)

    CODE
    
    Parent.Init(File,E)
    
    !Below Can Be Removed
    !Set alias so file will always user the Prefix in SQL queries
    !This is simplified, you may need to handle SQL Keywords
    IF SELF.ISSqlFile() THEN
        Self.File{prop:alias} = Self.GetFilePrefix()
    END
    

ModFM.ISSqlFile     PROCEDURE()
!------------------------------------------------------------------------------
    CODE
    RETURN SELF.FILE{prop:SQLDriver} 


!------------------------------------------------------------------------------
! GetFilePrefix method
! 
! Summary:
! Extracts the prefix from the first field's label of a file associated with the current object.
!
! Description:
! This method retrieves the label of the first field of the file associated with the current object.
! It then determines the length of this field label and searches for the presence of either a ':'
! or '.' character within the label to demarcate the prefix. The method extracts and returns this
! prefix. If the demarcating character is not found, the entire field label is considered the prefix.
! Additionally, the method logs the extracted prefix for tracing purposes.
!
! Parameters:
! None
!
! Returns:
! CSTRING(21): The extracted prefix from the first field's label of the file.
!
! Example Usage:
! PREFIX_VAR = Access:SomeFile.GetFilePrefix()
!
! Notes:
! - The file's first field label is expected to contain a prefix followed by either ':' or '.' as a separator.
! - This method utilizes the `Self` reference to access properties and methods of the current object instance.
! - Trace logging is performed to facilitate debugging and traceability of the prefix extraction process.
!------------------------------------------------------------------------------

ModFM.GetFilePrefix Procedure()
!------------------------------------------------------------------------------
Prefix                  CSTRING(21)
PrefixPos               Long
FieldNameLen            Long
FirstFieldName          CSTRING(257)
    Code
    FirstFieldName = Self.File{PROP:Label,1}
    FieldNameLen = Len(FirstFieldName)
    PrefixPos = Instring(':',FirstFieldName,1,1)
    If Not PrefixPos
        PrefixPos = Instring('.',FirstFieldName,1,1)
    END
    If PrefixPos
        Prefix = FirstFieldName[1 : PrefixPos-1]
    END
    !Trace line here for example
    Self.TRACE('Prefix returning: ' & Prefix)
    Return Prefix


!------------------------------------------------------------------------------
! DBTraceOn method
!
! Summary:
! Enables database trace logging for the current file associated with the object.
!
! Description:
! This method activates trace logging for the database file associated with the
! current object instance. Trace information, including database operations and
! potentially SQL statements, is directed to a debug view tool for real-time monitoring
! and debugging. The method checks if the file is an SQL file and, if so, explicitly
! enables logging of SQL statements. The use of 'DEBUG:' as the profile destination
! indicates that the trace output is sent to an external debugging utility that captures
! debug output, such as DebugView on Windows.
!
! Parameters:
! None
!
! Returns:
! None
!
! Example Usage:
! Access:SomeFile.DBTraceOn()
!
! Notes:
! - The method modifies the PROP:Details and PROP:Profile properties of the file
!   to enable detailed tracing and set the output destination to a debugging utility.
! - For SQL-based files, PROP:LogSQL is set to 1 to enable logging of SQL queries.
! - This method is useful for debugging complex database interactions and optimizing
!   SQL query performance.
! - Reference: Discussion on enabling driver trace logging on ClarionHub
!   (https://clarionhub.com/t/re-driver-trace-logging-to-debugview-using-prop-profile-debug/7020).
!------------------------------------------------------------------------------
ModFM.DBTraceOn     PROCEDURE()
!------------------------------------------------------------------------------
    CODE  
    SELF.File{PROP:Details}    = 1 
    SELF.File{PROP:Profile}    = 'DEBUG:'   ! sends the trace info to debugview
    IF SELF.ISSqlFile() THEN
        SELF.File{PROP:LogSQL} = 1
    END

!------------------------------------------------------------------------------
! DBTraceOff Method
!
! Summary:
! Disables detailed tracing and profiling for database operations.
!
! Description:
! This method deactivates tracing and profiling of database operations by resetting properties
! on the file associated with the current object. It effectively stops the redirection of trace
! information to DebugView. Additionally, if the associated file is an SQL file, SQL query logging
! is also deactivated. This method is typically invoked to cease detailed monitoring of database
! operations, either at the end of a debugging session or when such detailed tracing is no longer
! necessary, thereby helping to reduce potential performance overhead.
!
! References:
! - Further discussion on driver trace logging can be found at ClarionHub:
!   https://clarionhub.com/t/re-driver-trace-logging-to-debugview-using-prop-profile-debug/7020
!
! Parameters:
! None
!
! Returns:
! None
!
! Example Usage:
! ACCESS:SomeFile.DBTraceOff()
!
! Notes:
! - It's important to invoke this method at the conclusion of debugging or monitoring sessions
!   to ensure that performance is not adversely affected by unnecessary logging activities.
! - This method assumes DebugView or similar tools were previously used for capturing trace
!   outputs during active database operation monitoring.
!------------------------------------------------------------------------------
ModFM.DBTraceOff    PROCEDURE()
!------------------------------------------------------------------------------
    CODE  

    SELF.File{PROP:Details}    = 0 
    SELF.File{PROP:Profile}    = '' 
    IF SELF.ISSqlFile() THEN
        SELF.File{PROP:LogSQL} = 0
    END

!------------------------------------------------------------------------------
! TRACE Method
!
! Summary:
! Logs a custom message to the debugging output with added context.
!
! Description:
! This method constructs a message string by appending the provided message to the
! name of the file associated with the current object, formatted with brackets. It then
! calls the external FMODS procedure to send this formatted message to the debugging output,
! typically viewable in tools like DebugView. This method is useful for detailed debugging
! and logging purposes, allowing developers to trace program flow or data values at runtime
! with contextual information.
!
! Parameters:
! - Message (STRING): The message to be logged. This content is user-defined and typically
!   contains information relevant to the current state or behavior being traced.
!
! Returns:
! None
!
! External Dependencies:
! - FMODS: An external procedure defined to interact with the Windows API function
!   'OutputDebugStringA', facilitating the redirection of the message to the debug output.
!   This function is declared with the PASCAL calling convention and marked RAW to pass
!   the message string directly to the external function without any Clarion runtime processing.
!
! Example Usage:
! ACCESS:SomeFile.TRACE('This is a debug message.')
!
! Notes:
! - The effectiveness of this method depends on the presence of an external tool capable
!   of capturing and displaying the debug output, such as DebugView.
! - This method concatenates the file name and the provided message, enhancing the
!   debug message's informational value by including the context directly associated with
!   the current object's file.
!------------------------------------------------------------------------------
ModFM.TRACE         PROCEDURE(STRING Message)  
!------------------------------------------------------------------------------
csMessage               CSTRING(1025)
    CODE
    csMessage = '[' & Self.File{PROP:Name} &']' & ' ' & CLIP(Message)
    FMODS(csMessage)