       working-storage section.

       01 LoanStructure.
           05 LoanAmount           PIC 9(6)V99.
           05 AnnualInterestRate   PIC 99V99.
           05 MonthlyInterestRate  PIC 9V9(5).
           05 LoanTermMonths       PIC 999.
           05 LoanDate             PIC X(10).

       01 PaymentStructure Occurs 1 to 999 times
            depending on LoanTermMonths.
           05 OpeningBalance       PIC 9(6)V9(5).
           05 PaymentAmount        PIC 9(5)V99.
           05 PrincipalAmount      PIC  9(5)V99.
           05 InterestAmount       PIC  9(5)V99.
           05 ClosingBalance       PIC  9(5)V99.

        01 WORK-DATE.
           05 WORK-MONTH           PIC 9(2).
           05                      PIC X.
           05 WORK-DAY             PIC 9(2).
           05                      PIC X.
           05 WORK-YEAR            PIC 9(4).
