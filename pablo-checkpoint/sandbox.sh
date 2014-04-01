#Proyecto Metodos Analiticos

#Pablo Bosch



grep user_000001 userid-timestamp-artid-artname-traid-traname.tsv | cut -f4 | uniq -c | sed 's/^ *//g' | cut -d" " -f1 > user1.txt



grep 坂本龍一 userid-timestamp-artid-artname-traid-traname.tsv | cut -f1,2 | awk '{gsub("T.*Z",""); print $0;}'  > prueba.txt

cut -f2 prueba.txt | sort | uniq -c | sed 's/^ *//g'| cut -d" " -f1 > ryu.txt


#Para extraer fleet foxes
grep "Fleet Foxes" userid-timestamp-artid-artname-traid-traname.tsv | cut -f1,2 | awk '{gsub("T.*Z",""); print $0;}'  > prueba.txt

#para ver el numero de reproducciones por día
grep "Fleet Foxes" userid-timestamp-artid-artname-traid-traname.tsv| cut -f1,2 | awk '{gsub("T.*Z",""); print $0;}'|cut -f2| sort | uniq -c | sed 's/^ *//g' > FF.txt






#Para hacer la lista de fechas 
echo 2004-01-01 2009-12-31 | gawk '{
split($1,s,"-")
    split($2,e,"-")
    st=mktime(s[1] " " s[2] " " s[3] " 0 0 0")
    et=mktime(e[1] " " e[2] " " e[3] " 0 0 0")
    for (i=st;i<=et;i+=60*60*24) print strftime("%Y-%m-%d",i)
}' > full_dates.txt

#Carga las fechas a python
dates = pd.read_table("full_dates.txt", names = ['dates'], index_col = False)

#pasamos las fechas en serie
dates = pd.Series(dates.dates.transpose())

#Para Fleet Foxes (hacer lo mismo con nombre diferente para ryu)

#Para cargar los datos en python 
ff = pd.read_table("FF.txt", names = ['p','d'], sep = " ")

#Python para hacer el join
d1 = dict(zip(ff.d,ff.p))

ff_result = pd.DataFrame([[fecha,d1.get(fecha, 0)] for fecha in dates]).sort(0)

#sacamos el maximo para poner la ventana de tiempo por ahi
ff_result.ix[ff_result[1].idxmax()]


plt.plot(ff_result[1])
plt.xlabel('Dias')
plt.ylabel('Numero de reproducciones')
plt.title('Historial de Reproducciones de Fleet Foxes')
#para salvar la figura quita el comentario de la siguiente linea
#plt.savefig('fleetfoxes.pdf')
plt.show()


#============ Paquetes =============#
import pandas as pd
import numpy as np
import networkx as nx
from networkx.algorithms import bipartite
import matplotlib.pyplot as plt
from datetime import datetime

#son los paquetes que cargue pero en realidad solo utilizo 2 matplotlib y pandas 


#Nuevo código para graficar por semana
# Agrupar por semana 

date = pd.to_datetime(dates)
year, week = [datetime.strptime(dt,'%Y-%m-%d') for dt in datee].isocalendar()

full_dates = pd.DataFrame([ (x,) + x.isocalendar()[:2] for x in pd.to_datetime(dates)], columns = ['date','year', 'week'])


#Fleet Foxes por semana
ff_weekly = pd.DataFrame([pd.to_datetime(fecha).isocalendar()[:2]+(d1.get(fecha,0),) for fecha in dates], columns = ['year', 'week', 'plays'])


ff_group = ff_weekly.groupby(['year','week']).sum()

plt.plot(ff_group)
plt.show()


#Ryu
ryu = pd.read_table("ryu_dates.txt", names = ['p','d'], sep = " ")
d2 =  dict(zip(ryu.d,ryu.p))

#Ryuichi Sakamoto por semana
ryu_weekly = pd.DataFrame([pd.to_datetime(fecha).isocalendar()[:2]+(d2.get(fecha,0),) for fecha in dates], columns = ['year', 'week', 'plays'])


ryu_group = ryu_weekly.groupby(['year','week']).sum()

plt.plot(ryu_group)
plt.show()



