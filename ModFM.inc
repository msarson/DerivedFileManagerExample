!ABCIncludeFile
    INCLUDE('ABFILE.INC'),ONCE


ModFM               CLASS(FileManager),TYPE,MODULE('ModFM.clw'),LINK('ModFM.clw')
Init                    PROCEDURE(File File,ErrorClass EC),DERIVED
IsSQLFile               PROCEDURE(),BYTE
GetFilePrefix           PROCEDURE (),STRING,PROTECTED
DBTraceOn               PROCEDURE()
DBTraceOff              PROCEDURE()
TRACE                   PROCEDURE(STRING Message)
                    END




   