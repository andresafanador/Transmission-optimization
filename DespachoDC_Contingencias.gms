sets     i    conjunto de nodos /i1,i2,i3,i4/
         l    conjunto de lineas /l1*l4/;
alias(l,k) ;

scalar Sbase     Potencia base en MVA /100/

parameters       c[i]    costo de cada planta de cada nodo en dólares por MWh
         /i1     150
          i2     170
          i3     200
          i4     230/
                 gBase[i] Despacho economico en condicion normal (con todas las lineas)

                 gMax[i] Generación máxima de cada planta en MW
         /i1    50
          i2    50
          i3   100
          i4    80/

                 d[i]    demanda nodal en MW
         /i1     20
          i2     80
          i3     50
          i4     30/
                 fMax[l] Flujos máximos de cada línea en MW
         /l1    20
          l2    20
          l3    20
          l4    10/
                x[l] Reactancias de línea en p.u.
         /l1    0.3
          l2    0.2
          l3    0.1
          l4    0.1/
                 u[l] Estado de cada linea. Opera u = 1 y no opera u = 0
         /l1    1
          l2    1
          l3    1
          l4    1/
          PI_Flow[k]     Indice de desempeño de flujos
;

table A[i,l]  Matriz de incidencia del sistema
         l1      l2      l3      l4
i1       1        1       0       0
i2      -1        0       1       0
i3       0       -1       0       1
i4       0        0      -1      -1
;

variable f0              Costo total del sistema en dólares por hora
         f1              Suma de las variables artificiales
         f[l]            Flujo por cada línea en MW
         theta[i]        ángulos de voltage nodal en radianes ;

positive variables       g[i]    Generación de cada planta en MW
                         err[i]    Variables artificiales en cada nodo (generadores ficticios) ;

equations        costo           Costo de operación
                 costoartif      Costo asociado a las variables artificiales
                 balance         Restricción de balance generación-demanda
                 genMax          Restricción de generación máxima
                 flujoMax        Restricción de flujo máximo
                 flujoMin        Restricción de flujo mínimo
                 difAngular      Restricción de flujo DC en términos de los ángulos ;

costo..          f0 =e= sum(i, c[i]*g[i]) ;
costoartif..     f1 =e= sum(i, err[i]) ;
balance[i]..     g[i] - d[i] + err[i] =e= sum(l,A[i,l] * f[l]) ;
genMax[i]..      g[i] =l= gMax[i] ;
flujoMax[l]..    f[l] =l= fMax[l] ;
flujoMin[l]..    f[l] =g= -fMax[l] ;
difAngular[l]..  f[l] =e= u[l] * Sbase * sum(i,A[i,l] * theta[i]) / x[l] ;
err.up[i] = 0 ;

* Modelo DC sin contingencia para tener un despacho económico
model DC /all/ ;
solve DC using LP minimizing f0 ;

gBase[i] = g.l[i] ;

g.fx[i] = gBase[i] ;
err.up[i] = 210 ;
* Modelo con contingencia en linea 3 y se desea determinar su impacto sobre las demas lineas
model Cont /costoartif,balance, difAngular/ ;
loop(k,
         u[l] = 1 ;
         u[k] = 0 ;
         solve Cont using LP minimizing f1 ;
         PI_Flow[k] = sum(l, power(f.l[l]/fMax[l],2))
         display u, f.l ;
);
display PI_Flow ;