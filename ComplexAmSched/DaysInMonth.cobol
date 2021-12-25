      **************************************************************************************************************************
      * Credits to: https://stackoverflow.com/questions/6664757/any-date-should-be-converted-to-end-of-the-month-date-in-cobol *
      * answered May 21 '18 at 9:36 Srinivasan JV silver badges12                                                              *
      **************************************************************************************************************************

       IDENTIFICATION DIVISION.
       program-id. DaysInMonth.
       DATA DIVISION.                  
           copy "copybooks/commondata.cpy".       

           01 MONTH-31 PIC 9(2).                                  
               88 IS-MONTH-31 VALUES 01, 03, 05, 07, 08, 10, 12.   
               88 IS-MONTH-30 VALUES 04, 06, 09, 11.               
           01 WS-C           PIC 9(4) VALUE 0.                    
           01 WS-D           PIC 9(4) VALUE 0. 

           LINKAGE SECTION.
           01 DateIn           PIC X(10).                   
           01 DaysInMonthOut   PIC 9(2).
           
            
           
       PROCEDURE DIVISION using DateIn , DaysInMonthOut.                                    
       1000-DoDate.    
           MOVE DateIn TO WORK-DATE.
           MOVE WORK-MONTH TO MONTH-31.                       
           EVALUATE TRUE                                      
           WHEN IS-MONTH-31                                   
           MOVE 31 TO WORK-DAY                                             
           WHEN IS-MONTH-30                                    
           MOVE 30 TO WORK-DAY                                              
           WHEN OTHER                                          
           DIVIDE WORK-YEAR BY 4 GIVING WS-C REMAINDER WS-D    
           IF WS-D NOT EQUAL 0                                 
           MOVE 28 TO WORK-DAY                                 
           ELSE                                                
           MOVE 29 TO WORK-DAY                                 
           END-IF                                              
           END-EVALUATE.  
           MOVE WORK-DAY to DaysInMonthOut.
           END PROGRAM DaysInMonth.              
       
     
