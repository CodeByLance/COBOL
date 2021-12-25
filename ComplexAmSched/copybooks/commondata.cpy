       working-storage section.
       
       01 WORK-DATE.                                          
           05 WORK-MONTH           PIC 9(2).                            
           05                      PIC X.                               
           05 WORK-DAY             PIC 9(2).                            
           05                      PIC X.                               
           05 WORK-YEAR            PIC 9(4). 
       
       
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
