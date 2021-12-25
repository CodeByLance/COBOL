      ******************************************************************
      * cobc (GnuCOBOL) 2.2.0                                          *
      * C version "8.1.0"                                              *
      * OS: Ubuntu 20.04.3 LTS on Windows 11 x86_64                    *
      * Kernel: 5.10.60.1-microsoft-standard-WSL2                      *
      * CPU: Intel i7-8565U (8) @ 1.992GHz                             *
      * GPU: 9113:00:00.0 Microsoft Corporation Device 008e            *
      * Memory: 523MiB / 3838MiB                                       *
      ****************************************************************** 
      * Complex Version of Amortization Schedule accounting for        *
      * different ways lenders calculate interest.                     *      
      ******************************************************************
       IDENTIFICATION DIVISION.
       program-id. ComplexAmAched.
       
       DATA DIVISION.           
           copy "copybooks/commondata.cpy".
           01  DaysInMonth             PIC 99.
           01  LoanDate                PIC X(10) value "01/01/2021".
           01  TestDate                PIC X(10) value "02/01/2024".
           01  TestDaysInMonth         PIC 99.

       PROCEDURE DIVISION.
       1000-MAIN.
           move LoanDate to WORK-DATE.

           call "DaysInMonth" using by content TestDate
                   by reference TestDaysInMonth.

           display TestDaysInMonth.

           stop run.  

         
