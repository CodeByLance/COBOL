       working-storage section.
       
       01 WORK-DATE.                                          
           05 WORK-MONTH           PIC 9(2).                            
           05                      PIC X.                               
           05 WORK-DAY             PIC 9(2).                            
           05                      PIC X.                               
           05 WORK-YEAR            PIC 9(4). 
       
       
       01  LoanStructure.
           05  LoanAmount               PIC 9(6)V99.
           05  TermMonths               PIC 999.           
           05  AnnualInterestRate       PIC 99V99.

           05  MonthlyInterestRate30365 PIC 99V9999.
           05  MonthlyInterestRateAC365 PIC 99V9999.
           05  MonthlyInterestRateACAC  PIC 99V9999.
           05  MonthlyInterestRate30360 PIC 99V9999.    
           
           
       
       01  PaymentStructure.
           05  MonthlyPayment30365      PIC 9(5)V99999.
           05  MonthlyPaymentAC365      PIC 9(5)V99999.
           05  MonthlyPaymentACAC       PIC 9(5)V99999.
           05  MonthlyPayment30360      PIC 9(5)V99999.
           05  PrincipalAmount30365     PIC 9(5)V99999.
           05  PrincipalAmountAC365     PIC 9(5)V99999.
           05  PrincipalAmountACAC      PIC 9(5)V99999.
           05  PrincipalAmount30360     PIC 9(5)V99999.
           05  InterestAmount30365      PIC 9999V99999.
           05  InterestAmountAC365      PIC 9999V99999.
           05  InterestAmountACAC       PIC 9999V99999.
           05  InterestAmount30360      PIC 9999V99999.
           05  Balance30365             PIC 9(6)V99999.
           05  BalanceAC365             PIC 9(6)V99999.
           05  BalanceACAC              PIC 9(6)V99999.
           05  Balance30360             PIC 9(6)V99999.
