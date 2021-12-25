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
           01  Counter                 PIC 999 value 1.
           
       PROCEDURE DIVISION.
       1000-MAIN.
           move LoanDate to WORK-DATE.
           set LoanAmount to 100000.00.
           set AnnualInterestRate to 15.00.
           set TermMonths to 60.
  
           move LoanAmount to Balance30365.
           move LoanAmount to BalanceAC365.
           move LoanAmount to BalanceACAC.
           move LoanAmount to Balance30360.
           

      *    30/365 CALCULATION  
           compute MonthlyInterestRate30365 = 
                   (AnnualInterestRate / 100) / 12.
                   
           compute MonthlyPayment30365 = 
                   LoanAmount * MonthlyInterestRate30365 / (
                       1-(1+MonthlyInterestRate30365)**-TermMonths
                   ).
           
      *    30/360 CALCULATION
           compute MonthlyInterestRate30360 = 
                   ((AnnualInterestRate/100)/360) * 30.
           compute MonthlyPayment30360 = 
                   LoanAmount * MonthlyInterestRate30360 / (
                       1-(1+MonthlyInterestRate30360)**-TermMonths
                   ).
      
           move LoanDate to WORK-DATE

           Perform TermMonths Times
               call "DaysInMonth" using by content LoanDate
                              by reference DaysInMonth

               compute PrincipalAmount30365 = MonthlyPayment30365 -
                       ( Balance30365 * MonthlyInterestRate30365 )
               compute InterestAmount30365 = 
                       MonthlyPayment30365 - PrincipalAmount30365
      
               compute PrincipalAmount30360 = MonthlyPayment30360 -
                       ( Balance30360 * MonthlyInterestRate30360 )
               compute InterestAmount30360 = 
                       MonthlyPayment30365 - PrincipalAmount30360
      

      *    AC/365 CALCULATION
               compute MonthlyInterestRateAC365 = 
                   ((AnnualInterestRate / 100) /365)*DaysInMonth
               compute MonthlyPaymentAC365 = 
                   LoanAmount * MonthlyInterestRateAC365 / (
                       1-(1+MonthlyInterestRateAC365)**-TermMonths
                   )

               compute PrincipalAmountAC365 = MonthlyPaymentAC365 -
                       ( BalanceAC365 * MonthlyInterestRateAC365 )
               compute InterestAmountAC365 = 
                       MonthlyPaymentAC365 - PrincipalAmount30365
      
      *    ACAC Calculation
               if DaysInMonth = 29 then 
                   compute MonthlyInterestRateAC365 = 
                   ((AnnualInterestRate / 100) /366)*DaysInMonth
               else 
                   compute MonthlyInterestRateAC365 = 
                   ((AnnualInterestRate / 100) /365)*DaysInMonth
               end-if

               compute MonthlyPaymentACAC = 
                   LoanAmount * MonthlyInterestRateACAC / (
                       1-(1+MonthlyInterestRateACAC)**-TermMonths
                   )

               compute PrincipalAmountACAC = MonthlyPaymentACAC -
                       ( BalanceACAC * MonthlyInterestRateACAC )
               compute InterestAmountAC365 = 
                       MonthlyPaymentACAC - PrincipalAmountACAC
          

      *    BALANCES
               compute Balance30365 = Balance30365 - 
                   PrincipalAmount30365

               compute BalanceAC365 = BalanceAC365 - 
                   PrincipalAmountAC365
           
               compute BalanceACAC = BalanceACAC - 
                   PrincipalAmountACAC

               compute Balance30360 = Balance30360 - 
                   PrincipalAmount30360


               Display LoanDate
                       " "
                       PrincipalAmount30365
                       " "
                       InterestAmount30365
                       " "
                       Balance30365
                       " "
                       Counter
      *    Set Next
               compute Counter = Counter + 1                    
               compute WORK-MONTH = WORK-MONTH + 1

               if WORK-MONTH = 13 then 
                   compute WORK-MONTH = 1
                   compute WORK-YEAR = WORK-YEAR + 1
               
               end-if

               move WORK-DATE to LoanDate
           
           end-perform

           

       stop run.  

         
