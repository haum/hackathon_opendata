# coding: utf-8

#import insee codes
import csv
insee = dict()
with open('../data/insee.csv','rb') as inseefile:
    inseereader = csv.reader(inseefile, delimiter=',',quotechar='"')
    for row in inseereader:
        insee[row[3]] = row[0]

#import buses POI
import json
jsonfile = open('../data/tis/tis2014_mercator.json','r')
data = json.loads(jsonfile.read())
points = data.get('features')

for point in points:
        point['properties']['highway'] = 'bus_stop'
        point['properties']['name'] = insee[point.get('properties').get('COD_COMM')] + ' - ' + point.get('properties').get('NOM')

        networks = [] 
        if (point['properties']['TIS_CG'] == 'Oui'):
            networks.append('TIS')
        if  (point['properties']['TSQ_CG'] == 'Oui'):
            networks.append('TSQ')

        point['properties']['network'] = (',').join(networks)

        del point['properties']['NOM']
        del point['properties']['COD_COMM']
        del point['properties']['COD_ARRET']
        del point['properties']['TSQ_CG']
        del point['properties']['TIS_CG']
        del point['properties']['FID']
        del point['properties']['OBJECTID']
        del point['properties']['NUM_OBJ']

jsonoutput = open('../data/tis/tis2014_cleaned.geojson','wb')
json.dump(data, jsonoutput, sort_keys=True, indent=1, separators=(',', ': '))
jsonoutput.close()


