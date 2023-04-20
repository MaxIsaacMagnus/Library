* a simple model of maximization

integer Variables
    x1 number of cars
    x2 number of trucks ;

free Variable
    z total revenue ;
    
Equations
    eq_revenue revenue to be maximized
    eq_budget budget constraint
    eq_carsinbarn max number of cars in barn;
    
eq_revenue.. z =E= 2*x1 + 2.5*x2 ;

eq_budget.. x1 + 1.2*x2 =l= 3.6 ;

eq_carsinbarn.. x1 =l= 4 - x2 ;

x2.up = 2 ;

model vintage /eq_revenue, eq_budget, eq_carsinbarn/ ;

solve vintage using mip maximizing z ;

display "Solution values:"
display x1.l, x2.l, z.l ;
