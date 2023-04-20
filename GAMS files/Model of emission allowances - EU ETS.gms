Sets
    t time period /0*30/
    t0(t) Period t=0
    ts(t) Simulation periods
    ts2(t) Simulation periods except t=1
    tn(t) Last period
    ;

    t0(t) = yes$(ord(t) eq 1) ;
    ts(t) = yes$(ord(t) gt 1) ;
    ts2(t) = yes$(ord(t) gt 1 and ord(t) lt card(t)) ;
    tn(t) = yes$(ord(t) eq card(t)) ;

Scalars
    r interest rate
    bet Threshold for cancelling allowances
    p0 Average price in 2020 (t=0)
    d0 demand in 2020 (t=0)
    apar Parameter alpha in demand function
    bpar Parameter beta in demand function
    ;

* Interest rate   
    r = 0.05 ;
* Assumed share of auctioning
    bet = 0.57 ;
* Average price in 2020
    p0 = 24.76 ;
* Demand in 2020
    d0 = 1380.2 ;
    bpar = 8.492 ;
    apar = (d0 + p0*bpar) ;
    
Parameters
    s(t) Fixed supply of allowances (unadjusted)
    alpha(t) Withdrawal rate-share of allowance volume entering into the MSR
    ;
    
    s(t)$(ord(t) eq 1) = 1859;
    s(t)$(ord(t) gt 1) = 1859 - (ord(t)-1)*43.003515;
    alpha(t)$(ord(t) le 4) = 0.24;
    alpha(t)$(ord(t) gt 4) = 0.12;
    
Positive Variables
    p(t) Price
    d(t) Demand for allowances
    CumD Cumulative demand for allowances
    m_in(t) Inflow of allowances into the MSR
    m_out(t) Outflow out of the MSR and into the market
    M(t) Size of the MSR
    C(t) Cancellation of allowances
    CumC Cumulative cancellation of allowances
    ;
    
Variables
    B(t) Banking of allowances
    ;

Equations
    EQ1(t) Allowances entering into MSR
    EQ2(t) Allowances taken out of MSR
    EQ3(t) Cancellation of allowances
    EQ4(t) Size of the MSR
    EQ5(t) Market balance
    EQ6(t) Price over time
    EQ7(t) Demand for allowances
    
    EQ3SUM Cumulative cancellation of allowances
    EQ7SUM Cumulative demand for allowances
    ;
    
    EQ1(t)$(ts(t)).. m_in(t) =E= MAX(0, alpha(t)*B(t-1)*(B(t-1) - 833))*(B(t-1) - 833) /
((B(t-1) - 833)*(B(t-1)-833)+0.01) ;

    EQ2(t)$(ts(t)).. m_out(t) =E= MIN(M(t-1),(MAX(0, 100*(400 - B(t-1)))*(400 - B(t-1)) /
((400 - B(t-1))*(400 - B(t-1)) + 0.01))) ;
   
    EQ3(t)$(ord(t) gt 2).. C(t) =E= MAX(0, M(t)-bet*s(t) ) ;
    
    EQ4(t)$(ts(t)).. M(t) =E= M(t-1) + m_in(t) - m_out(t) - C(t-1) ;
    
    EQ5(t)$(ts(t)).. s(t) - m_in(t) + m_out(t) =E= d(t) + B(t) - B(t-1) ;
    
    EQ6(t)$(ts2(t)).. p(t+1) =E= p(t)*(1+r) ;

    EQ7(t)$(ts(t)).. d(t) =E= (apar - bpar*p(t)) ;

    EQ3SUM.. CumC =E= sum(t,C(t)) ;
    
    EQ7SUM.. CumD =E= sum(t,d(t)) ;
    
* Model with MSR
Model MSR_YES /EQ1.m_in, EQ2.m_out, EQ3.C, EQ4.M,
EQ5.p, EQ6.B, EQ7.d, EQ3SUM.CumC, EQ7SUM.CumD / ;

* Fix initial values of variables (year 2020)
M.fx("0")=1924 ;
B.fx("0")=1579 ;

m_in.fx("0")=0 ;
m_out.fx("0")=0 ;
d.fx("0")=0 ;
C.fx(t)$(ord(t) le 3)=0 ;


* Last period constraints
M.fx(t)$tn(t)=0 ;
B.fx(t)$(ord(t) eq card(t))=0 ;

* Ensure that prices are strictly Positive
p.lo(t) = 0.1 ;

* Number of iterations in the simulation
option iterlim=100000;
* Time limit for the simulation solver
option reslim=2000.0;
* Maximum number of rows listed in one equation block (default=3)
option limrow=10;

*** Help GAMS find the wanted equilibrium (due to possible multiple equilibria)
*p.up("1")=26 ;
*** Note: This command is only needed if there are have more than 1 equilibria.
***This is however not the case in the scenario when t is defined as /0*30/

* Solve the model
Solve MSR_YES using mcp;


display CumD.l, CumC.l ;
display p.l ;
