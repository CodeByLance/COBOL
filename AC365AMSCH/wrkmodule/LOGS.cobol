       IDENTIFICATION DIVISION.
       program-id. LOGS.
       ENVIRONMENT DIVISION.
       input-output section.
           file-control.
               select LogFile ASSIGN TO "LOGS\log.dat"
                   organization is line sequential.
       DATA DIVISION.
       FILE SECTION.
       FD  LogFile.
           01 LogRecord.
               05  LogMessage                  PIC X(106).


       LINKAGE SECTION.
           01 LogMessageIn                     PIC X(106).

       PROCEDURE DIVISION using LogMessageIn.
       1000-LogIt.

           move LogMessageIn to LogRecord.
           Open Extend LogFile
               Write LogRecord
           Close LogFile
           .
           end program LOGS.
