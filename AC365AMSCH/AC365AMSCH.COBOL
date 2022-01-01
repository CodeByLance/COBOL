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
      * Balance should go to zero for a true amortization              *
      * This version gets to $21.65 but not through any real scientific*
      * way. The math to make a truly consistent monthly payment amount*
      * with a zerp closing balance at the end of the term is elusive  *
      * at best.                                                       *
      * Actual/365 Interest calculation is done by using the actual    *
      * number of days in the month and also accounts for a leap year  *
      * where there is an extra day of interest calculated.            *
      * See lines 74 - 79 below.                                       *
      ******************************************************************
       IDENTIFICATION DIVISION.
       program-id. AC365AMSCH.

       DATA DIVISION.
       copy "copybooks/workingdta.cpy".

       01  RecordCounter               PIC 99.
       01  LoopCounter                 PIC 9(4) value 0001.
       01  DaysInMonth                 PIC 99.
       01  SeedPaymentAmount           PIC 9(5)V99.
       01  RecurringPaymentAmount      PIC 9(5)V99.
       01  SeedFactor                  PIC 9V9(5) value 0.02350.
       01  LogMessage                  PIC X(106) value spaces.
       01  msg                         PIC X(80) value spaces.

       01  debug   pic X.

       PROCEDURE DIVISION.
       999-Setup.
           move 100000.00 to LoanAmount.
           compute SeedPaymentAmount = LoanAmount * SeedFactor.
           move SeedPaymentAmount to RecurringPaymentAmount.

       1000-Begin.

           move 15.00 to AnnualInterestRate.
           move 060 to LoanTermMonths.
           move "01/01/2021" to LoanDate.
           move LoanDate to WORK-DATE.
           move 1 to RecordCounter.

           move LoanAmount to OpeningBalance(1).
           move SeedPaymentAmount to PaymentAmount(1).

           String "Begin "
                  "LA " LoanAmount " LT "LoanTermMonths " LD " LoanDate
                  " OB " OpeningBalance(RecordCounter) " SA "
                      SeedPaymentAmount
                       into msg.
           perform 2000-Logs.

           perform 1010-TheLoop.

           string "END. $" ClosingBalance(RecordCounter - 1)
               " Loop Count "LoopCounter into msg.
           perform 2000-Logs.
           perform 7000-DisplayLog.
           stop run.

       1010-TheLoop.
           perform LoanTermMonths times

               call "wrkmodule\DaysInMonth" using WORK-DATE
                   by reference DaysInMonth

               compute MonthlyInterestRate =
                          ((AnnualInterestRate / 100) / 365) *
                               DaysInMonth

               compute PrincipalAmount(RecordCounter) =
                           PaymentAmount(RecordCounter) -
                               (OpeningBalance(RecordCounter) *
                                   MonthlyInterestRate)

               compute InterestAmount(RecordCounter) =
                           PaymentAmount(RecordCounter) -
                               PrincipalAmount(RecordCounter)

               compute ClosingBalance(RecordCounter) =
                           OpeningBalance(RecordCounter) -
                               PrincipalAmount(RecordCounter)
      * if ClosingBalance is > OpeningBalance then do a reset


               ADD 1 to RecordCounter

               move ClosingBalance(RecordCounter - 1) to
                       OpeningBalance(RecordCounter)

               move RecurringPaymentAmount to
                   PaymentAmount(RecordCounter)

               ADD 1 to WORK-MONTH

               if WORK-MONTH = 13 then
                   move 1 to WORk-MONTH
                   ADD 1 to WORK-YEAR
               end-if

               if ClosingBalance(RecordCounter - 1) >
                       OpeningBalance(RecordCounter - 1) then

                   string  " Closing Balance higher than opening "
                               LoopCounter
                               into msg
                   perform 2000-Logs
                   perform 8000-ClearTable
                   move 1 to RecordCounter
                   add 1 to LoopCounter
                   subtract 50 from SeedPaymentAmount
                   perform 1000-Begin

               end-if

           end-perform

           if ClosingBalance(LoanTermMonths) > 100.00 then

               string " Last closing is not below 100 "
                  ClosingBalance(LoanTermMonths) " "
                  LoopCounter
                  into msg
               perform 2000-Logs


               add 1 to LoopCounter
               ADD 100 to SeedPaymentAmount
               string " new Seed Payment "
                       SeedPaymentAmount
                       into msg
               perform 2000-Logs
               string OpeningBalance(LoanTermMonths) " "
                   PaymentAmount(LoanTermMonths) " "
                   PrincipalAmount (LoanTermMonths) " "
                   InterestAmount (LoanTermMonths) " "
                   ClosingBalance(LoanTermMonths)
                           into msg
               perform 2000-Logs

               perform 8000-ClearTable
               move 1 to RecordCounter
               perform 1000-Begin
           end-if
           .



      * if last ClosingBalance not near 0 then adjust seed and redo loop
       2000-Logs.
           STRING function current-date
                           "          "
                           msg
                            into LogMessage.
           call "wrkmodule\LOGS" using LogMessage.
           move spaces to msg.


       7000-DisplayLog.
           subtract 1 from RecordCounter.
           Display RecordCounter " "
                   MonthlyInterestRate " "
                   OpeningBalance(RecordCounter) " "
                   PaymentAmount(RecordCounter) " "
                   PrincipalAmount(RecordCounter) " "
                   InterestAmount(RecordCounter) " "
                   ClosingBalance(RecordCounter).

       8000-ClearTable.
           move 1 to RecordCounter.
           perform LoanTermMonths times
               move zeros to PaymentStructure(RecordCounter)
               ADD 1 to RecordCounter
           end-perform
           move "Table Cleared " to msg.
           perform 2000-Logs.
