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
    Self.File{prop:alias} = Self.GetFilePrefix()
    

ModFM.ISSqlFile     PROCEDURE()
!------------------------------------------------------------------------------
    CODE
    RETURN SELF.FILE{prop:SQLDriver} 



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
    
ModFM.DBTraceOn     PROCEDURE()
!------------------------------------------------------------------------------
    CODE  
    SYSTEM{PROP:DriverTracing} = '1'
    SELF.File{PROP:TraceFile}  = 'DEBUG:'   ! sends the trace info to debugview
    SELF.File{PROP:Details}    = 1 
    SELF.File{PROP:Profile}    = 'DEBUG:'   ! sends the trace info to debugview
    SELF.File{PROP:LogSQL}     = 1

ModFM.DBTraceOff    PROCEDURE()
!------------------------------------------------------------------------------
    CODE  
    SYSTEM{PROP:DriverTracing} = ''
    SELF.File{PROP:TraceFile}  = ''
    SELF.File{PROP:Details}    = 0 
    SELF.File{PROP:Profile}    = '' 
    SELF.File{PROP:LogSQL}     = 0

ModFM.TRACE         PROCEDURE(STRING Message)  
!------------------------------------------------------------------------------
csMessage               CSTRING(1025)
    CODE
    csMessage = '[' & Self.File{PROP:Name} &']' & ' ' & CLIP(Message)
    FMODS(csMessage)