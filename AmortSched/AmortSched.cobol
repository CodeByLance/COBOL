      ******************************************************************
      * cobc (GnuCOBOL) 2.2.0                                          *
      * C version "8.1.0"                                              *
      * OS: Ubuntu 20.04.3 LTS on Windows 11 x86_64                    *
      * Kernel: 5.10.60.1-microsoft-standard-WSL2                      *
      * CPU: Intel i7-8565U (8) @ 1.992GHz                             *
      * GPU: 9113:00:00.0 Microsoft Corporation Device 008e            *
      * Memory: 523MiB / 3838MiB                                       *
      ******************************************************************
      * Simple Amortization Schedule                                   *
      ******************************************************************
       IDENTIFICATION DIVISION.
       program-id. AmortSched.

       DATA DIVISION.
       working-storage section.

       01  LoanStructure.
           05  LoanAmount          PIC 9(6)V99.
           05  AnnualInterestRate  PIC 99V99.
           05  MonthlyInterestRate PIC 99V9999.    
           05  TermMonths          PIC 999.
       
       01  PaymentStructure.
           05  MonthlyPayment      PIC 9(5)V99999.
           05  PrincipalAmount     PIC 9(5)V99999.
           05  InterestAmount      PIC 9999V99999.
           05  Balance             PIC 9(6)V99999.

       01  FormatStructures.
           05 Counter              PIC 99  value zero.
           05 FILLER               PIC X(10).
           05 Disp-PrincipalAmount PIC $$,$$$9.99.
           05 FILLER               PIC X(10).
           05 Disp-InterestAmount  PIC $$,$$$9.99.
           05 FILLER               PIC X(10).
           05 Disp-Balance         PIC $$$,$$9.99.
           05 FILLER               PIC X(10).

       01  ColumnHeader.
           05 CMonth               PIC X(5)    value "Month".
           05 FILLER               PIC X(5).
           05 CPrincipalAmount     PIC X(20)   value "Principal Amount".
           05 CInterestAmount      PIC X(15)   value "Interest Amount".
           05 FILLER               PIC X(5).
           05 CCurrentBalance      PIC X(15)   Value "Current Balance".

       01  Disp-MonthlyPayment     PIC $$,$$$9.99.
       
       
       PROCEDURE DIVISION.
      *    TODO Make user input 
           set LoanAmount to 100000.00.
           set AnnualInterestRate to 15.0.
           set TermMonths to 60.
           
           move LoanAmount to Balance.

           compute MonthlyInterestRate = (AnnualInterestRate / 100)/12.           

           compute MonthlyPayment = LoanAmount * MonthlyInterestRate
                       / (1-(1+ MonthlyInterestRate)**-TermMonths).
           
           move MonthlyPayment to Disp-MonthlyPayment.
           display "Monthly Payment " Disp-MonthlyPayment.           
           display ColumnHeader.

           perform TermMonths times 
               compute Counter = Counter + 1
               compute PrincipalAmount = 
                   MonthlyPayment - (Balance * MonthlyInterestRate)
               compute InterestAmount =
                   MonthlyPayment - PrincipalAmount
               compute Balance = Balance - PrincipalAmount

               move PrincipalAmount to Disp-PrincipalAmount
               move InterestAmount to Disp-InterestAmount
               move Balance to Disp-Balance

               display FormatStructures
           end-perform 
       stop run.
