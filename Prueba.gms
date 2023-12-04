Sets    i   bus /i1*i6/
        l   lines /L1*L10/
        t   time /t1*t12/
;
alias(l,k)
alias(t,j)
;

Scalar Sbase Base power in MVA /100/

Parameters  fcost[l]    Transmission costs [$ MWh Miles]
/L1 2000000
L2 2000000
L3 2000000
L4 2000000
L5 2000000
L6 2000000
L7 2000000
L8 2000000
L9 2000000
L10 2000000 /
              distance[l]    Transmision distance [Miles]
/L1 300
L2 200
L3 180
L4 100
L5 100
L6 250
L7 100
L8 250
L9 150
L10 170 /
             gBase[i] Despacho economico en condicion normal (con todas las lineas)
            
             gcost[i] generation cost[$  MWh]
/i1 150
i2 0
i3 120
i4 200
i5 0
i6 100/
             gMax[i] maximun generation in MWh
/i1 400
i2 0
i3 380
i4 270
i5 0
i6 400/

            fMax[l] maximun power flow in MW
/L1 15
L2 15
L3 10
L4 10
L5 15
L6 10
L7 10
L8 10
L9 10
L10 15 /
            nl[l] Number of transmission lines in system
/L1 1
L2 0
L3 0
L4 0
L5 1
L6 0
L7 0
L8 0
L9 0
L10 0 /
            nlo1[l] Number of transmission lines in system
/L1 40
L2 40
L3 40
L4 40
L5 40
L6 40
L7 40
L8 40
L9 40
L10 40 /

             nlMax[l] Number of max transmission lines in system
/L1 4
L2 4
L3 4
L4 4
L5 4
L6 4
L7 4
L8 4
L9 4
L10 4 /

             nlMin[l] Number of min transmission lines in system
/L1 0
L2 0
L3 0
L4 0
L5 0
L6 0
L7 0
L8 0
L9 0
L10 0 /

             u[l] Estatus de cada linea. Opera u = 1 y no opera u = 0
         /l1*l10    1/
        PI_Flow[k,j]     Indice de desempeño de flujos
        PI_PERCENT[l,t,k]
        PI_PERCENT2[l,t,k]
;
Table   A[i,l]  Incidence matrix
    L1  L2  L3  L4  l5  L6  L7  L8  L9  L10
i1  1   1   0   0   0   1   0   0   0   0
i2  -1  0   1   1   0   0   1   0   0   0
i3  0   0   -1  0   0   0   0   1   1   1
i4  0   -1  0   0   1   0   -1  0   0   0
i5  0   0   0   -1  -1  -1  0   -1  0   0
i6  0   0   0   0   0   0   0   0   -1  -1
;
Table Gcf[i,t]  Capacity Factor
    t1      t2      t3      t4      t5      t6      t7      t8      t9      t10     t11     t12    
i1  0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6
i2  0       0       0       0       0       0       0       0       0       0       0       0
i3  0.25    0.25    0.25    0.25    0.3     0.35    0.45    0.35    0.25    0.25    0.25    0.25
i4  0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6     0.6
i5  0       0       0       0       0       0       0       0       0       0       0       0
i6  0       0       0.1     0.2     9.7     0.8     0.4     0.1     0       0       0       0
;  
Table d[i,t]  Demand in day 
    t1      t2      t3      t4      t5      t6      t7      t8      t9      t10     t11     t12    
i1  0       0       0       0       0       0       0       0       0       0       0       0
i2  30      39      43      52      60      69      48      44      90      78      55      30
i3  17      22      25      30      35      40      28      25      50      45      33      18
i4  10      13      15      18      21      24      17      15      30      27      19      11
i5  20      26      30      32      38      50      40      35      60      58      40      20
i6  0       0       0       0       0       0       0       0       0       0       0       0
;
Table N[l,t]  Table of 1
    t1      t2      t3      t4      t5      t6      t7      t8      t9      t10     t11     t12    
l1  1       1       1       1       1       1       1       1       1       1       1       1
l2  1       1       1       1       1       1       1       1       1       1       1       1
l3  1       1       1       1       1       1       1       1       1       1       1       1
l4  1       1       1       1       1       1       1       1       1       1       1       1
l5  1       1       1       1       1       1       1       1       1       1       1       1
l6  1       1       1       1       1       1       1       1       1       1       1       1
l7  1       1       1       1       1       1       1       1       1       1       1       1
l8  1       1       1       1       1       1       1       1       1       1       1       1
l9  1       1       1       1       1       1       1       1       1       1       1       1
l10 1       1       1       1       1       1       1       1       1       1       1       1

;
Variables   f0       Transmission costs
            f1      Suma de las variables artificiales
            f[l,t]   Power flow in MW
            f2[l,t]   Power flow in MW
            theta[i,t]
            ;
Positive Variable   g[i,t]    generation in MWh
                    err[i,t]    Variables artificiales en cada nodo (generadores ficticios) ;
Integer  variable nlo[l];

Equations   objFn   Objective function
            costoartif      Costo asociado a las variables artificiales
            balance         Restricción de balance generación-demanda
            genMax          Restricción de generación máxima
            flujoMax        Restricción de flujo máximo
            flujoMin        Restricción de flujo mínimo
            difAngular      Restricción de flujo DC en términos de los ángulos
            FLMAX
            difAngular2
            FLMAX2
            flujoMax2        Restricción de flujo máximo
            flujoMin2       Restricción de flujo mínimo
            balance2        Restricción de balance generación-demanda
            theta2
            
           ;
objFn..
            f0 =e= sum(l,2*distance[l]*fMax[l]*nlo[l]+10*0.25*2*distance[l]*nlo[l])+sum((i,t),gcost[i]*g[i,t]*10*0.000001*8760/2);
costoartif..
            f1 =e= sum((i,t), err[i,t]) ;
balance[i,t]..
            g[i,t] - (d[i,t]*1.03**10) + err[i,t] =e= sum(l,A[i,l] * f[l,t]) ;
genMax[i,t]..
            g[i,t] =l= Gcf[i,t]*gMax[i] ;
flujoMax[l,t]..
            f[l,t] =l= FMAX[l] ;
flujoMin[l,t]..
            f[l,t] =g= -FMAX[l] ;

difAngular[l,t]..
            f[l,t] =e= u[l]* Sbase * sum(i,A[i,l] * theta[i,t]) / (distance[l]*0.001) ;
FLMAX[l]..
            FMAX[l]=e= fMax[l]*(nlo[l]+nl[l]);
*difAngular2[l,t]..
*            f2[l,t] =e= u[l]* Sbase * sum(i,A[i,l] * theta2[i,t]) / ((nlo1[l])*distance[l]*0.001) ;
*FLMAX2[l]..
*            FMAX2[l]=e= fMax[l]*(nlo1[l]);
*flujoMax2[l,t]..
*            f2[l,t] =l= fMax[l]*(nlo1[l]) ;
*flujoMin2[l,t]..
*            f2[l,t] =g= -fMax[l]*(nlo1[l]) ;
*balance2[i,t]..
*            g[i,t] - d[i,t] + err[i,t] =e= sum(l,A[i,l] * f2[l,t]) ;

err.up[i,t] = 0 ;
            
g.up[i,t] = gMax[i];
nlo.up[l]=nlMax[l];
nlo.lo[l]=0;

* Modelo DC sin contingencia para tener un despacho económico
model DC /objFn,balance,genMax,flujoMax,flujoMin,FLMAX,difAngular/ ;
solve DC using MIP minimizing f0 ;