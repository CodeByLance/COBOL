       
       FILE SECTION.
       FD TRANSACTIONFILE.
       01 transactions.
           88  eof                              value   high-values.               
           05  xdate            PIC X(10)       value   spaces.
           05  description      PIC X(100)      value   spaces.
           05  amount           PIC X(9)        value   zeroes. 
           05  transactionType  PIC X(2)        value   spaces.
           05  catagory         PIC X(22)       value   spaces.
           05  accountName      PIC X(49)       value   spaces.
       
       FD  METAFILE.
       01  metadata.
           88  eofmeta                          value high-values.
           05  metarecordcount PIC X(7)         value spaces.
           05  metaDRSum       PIC X(10)        value spaces.
           05  metaCRSum       PIC X(10)        value spaces.
       
       FD  LOGS.
       01       msg            PIC X(999).    
       
       working-storage section.

       01 TOTALS.
           05  totalDR         PIC 9(7)V99      value zero.
           05  totalCR         PIC 9(7)V99      value zero.
           05  total           PIC 9(8)V99      value zero.
           05  recCount        PIC 9(7)         value zero.
           05  metaRecCount    PIC X(7)         value spaces.
           05  metaDsum        PIC 9(7)V99.                   
           05  metaCSum        PIC 9(7)V99.        

       01 MESSAGES.
           05  InvalidRecordCount PIC X(23)     value 
                   " Invalid Record Count. ". 
           05  InvalidDrAmount PIC X(17)        value
                   " Invalid DR Sum. ". 
           05  InvalidCrAmount PIC X(17)        value
                   " Invalid CR Sum. ". 
           05  ValidFile   PIC X(15)            value
                   " Valid file. ".
       
       01  LOGMESSAGE       PIC X(999).
       01  LOGFLAG          PIC 9               value zero.

       01 ARGUMENT-2. *> for check file exists
           05 File-Size-In-Bytes PIC 9(18) COMP.
           05 Mod-DD             PIC 9(2) COMP. *> Modification Time
           05 Mod-MO             PIC 9(2) COMP.
           05 Mod-YYYY           PIC 9(4) COMP. *> Modification Date
           05 Mod-HH             PIC 9(2) COMP.
           05 Mod-MM             PIC 9(2) COMP.
           05 Mod-SS             PIC 9(2) COMP.
           05 FILLER PIC 9(2) COMP. *> This will always be 00

       01  FILES-TO-PROCESS.
           05 test-file-pending    PIC X(25) value    
               "files/pending/test.csv".
           05 test-METAFILE-pending PIC X(30) value 
               "files/pending/testmeta.csv".          
           05 path-to-process      PIC X(25) value
               "files/process/test.csv".
           05 path-to-process-for-meta PIC X(30) value 
               "files/process/testmeta.csv".

       01 CURRENT-DATE-AND-TIME.
           05 CDT-Year              PIC 9(4).
           05 CDT-Month             PIC 9(2). *> 01-12
           05 CDT-Day               PIC 9(2). *> 01-31
           05 CDT-Hour              PIC 9(2). *> 00-23
           05 CDT-Minutes           PIC 9(2). *> 00-59
           05 CDT-Seconds           PIC 9(2). *> 00-59
           05 CDT-Hundredths-Secs   PIC 9(2). *> 00-99
           05 CDT-GMT-Diff-Hours    PIC S9(2)
           SIGN LEADING SEPARATE.
           05 CDT-GMT-Diff-Minutes  PIC 9(2). *> 00 or 30
