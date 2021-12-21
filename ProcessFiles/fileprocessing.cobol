      ******************************************************************
      * cobc (GnuCOBOL) 2.2.0                                          *
      * C version "8.1.0"                                              *
      * OS: Ubuntu 20.04.3 LTS on Windows 11 x86_64                    *
      * Kernel: 5.10.60.1-microsoft-standard-WSL2                      *
      * CPU: Intel i7-8565U (8) @ 1.992GHz                             *
      * GPU: 9113:00:00.0 Microsoft Corporation Device 008e            *
      * Memory: 523MiB / 3838MiB                                       *
      ****************************************************************** 
      * Find files, move files, read files, write files                *      
      ******************************************************************
       IDENTIFICATION DIVISION.
       program-id. FILEPROCESSING.
       
       ENVIRONMENT DIVISION.
       configuration section.
      
       input-output section.
       file-control.
       select TRANSACTIONFILE
           ASSIGN TO "files\process\test.csv"
               organization is line sequential.

       select METAFILE
           ASSIGN to "files\process\testmeta.csv"
               organization is line sequential.

       select LOGS
           ASSIGN to "files\logs\log.file" 
               organization is line sequential.
       
       DATA DIVISION.
       copy "copybooks/datasetup.cpy".

       PROCEDURE DIVISION.
       100-MAIN.
           display "starting".
           PERFORM 200-AnythingToProcess.
           display "200-done".
           PERFORM 250-GetMeta.
           display "250-done".
           PERFORM 300-ProcessTransactions.
           display "300-done".
           PERFORM 350-Verify.
           display "350-done".           
           PERFORM 400-Log.
           display "400-done".
           display "Log flag value: " LOGFLAG.         

           stop run.
           
       200-AnythingToProcess.
      * MAIN FILE FIRST
           call "CBL_CHECK_FILE_EXIST"
               USING test-file-pending,
                       ARGUMENT-2               
           end-call 
          
           if return-code not = zero  then
               
               move function CURRENT-DATE to CURRENT-DATE-AND-TIME
               
                   string CURRENT-DATE-AND-TIME
                           " not Found "
                               INTO LOGMESSAGE
                   end-string
               
               PERFORM 400-Log                
               
           else           
               call "C$COPY" using test-file-pending,path-to-process,0
               *>   see meta file check comment below
               call "C$COPY" using test-METAFILE-pending,
                   path-to-process-for-meta,0                            
       
               if return-code = zero then                
                       call "C$DELETE" using test-file-pending,0
                       call "C$DELETE" using test-METAFILE-pending,0
               else
                   display "stopping 200-"
                   stop run
               end-if                                 
           end-if    
           .       

      * META FILE CHECKS.
      * SAME AS "MAIN FILE FIRST" BUT I'VE JUST ASSUMED IF 
      * MAIN FILE EXISTS THEN META MUST EXIST AS WELL BECAUSE I'M
      * BEING LAZY     

           
       
       250-GetMeta.
           
           open input METAFILE.
               read METAFILE
                   at end set eofmeta to true
               end-read

           PERFORM until eofmeta
               
                   move metarecordcount to metaRecCount
                   move metaDRSum to metaDSum
                   move metaCRSum to metaCSum

               read METAFILE
                   at end set eofmeta to true 
               end-read 
           end-PERFORM

           close METAFILE.
           

       300-ProcessTransactions.           

           open input TRANSACTIONFILE.
           read TRANSACTIONFILE
               at end set eof to true 
           end-read 

           PERFORM until eof
               compute recCount = recCount + 1
               
               if transactionType =  "DR" then
                   compute totalDR = totalDR + function numval(amount)
               else 
                   compute totalCR = totalCR + function numval(amount)
               end-if 
           
                               
               read TRANSACTIONFILE
                   at end set eof to true 
               end-read 
             
           end-PERFORM 
           
           close TRANSACTIONFILE.
           
           
       350-Verify.
           
           move zero to LOGFLAG.
           move spaces to LOGMESSAGE.
           move function CURRENT-DATE to CURRENT-DATE-AND-TIME.           

           if reccount not = metaRecCount then 
                STRING
                   CURRENT-DATE-AND-TIME
                   
                   InvalidRecordCount
                   reccount
                   space
                   metaRecCount
                   INTO LOGMESSAGE
               end-string 
           set LOGFLAG to 1        
           PERFORM 400-log
           end-if
            

           if totalDR not = metaDSum then 
                STRING 
                   CURRENT-DATE-AND-TIME
                   
                   InvalidDrAmount
                   totalDR 
                   space
                   metaDSum
                   INTO LOGMESSAGE
                end-string 
           set LOGFLAG to 1
           PERFORM 400-log
           end-if           
           

           if totalCR not = metaCSum then 
               STRING 
                   CURRENT-DATE-AND-TIME
                   
                   InvalidCrAmount
                   totalCR
                   space 
                   metaCSum       
                   INTO LOGMESSAGE
               END-STRING
           set LOGFLAG to 1           
           PERFORM 400-log
           end-if
           
      * TODO Evaluate LOGFLAG 0 good log, 1 move files to error folder
           if LOGFLAG = 0 then
               STRING 
                   CURRENT-DATE-AND-TIME
                   
                   ValidFile
                   INTO LOGMESSAGE
               end-string 
               PERFORM 400-Log
           end-if
           .          

       400-Log.
           
           open extend  LOGS
               move LOGMESSAGE to msg           
                   write msg
                   end-write
           close LOGS

           move spaces to LOGMESSAGE.
           
           
