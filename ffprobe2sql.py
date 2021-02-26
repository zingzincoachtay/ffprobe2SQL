#!/usr/bin/python3
#import json,sys,re
import json,sys

from json2sql import *

with open(sys.argv[1],encoding='utf8') as dbp:
  db = json.load(dbp)
sqls = init_t('zin',['streams','disposition','format','tags','mp3s'])

Nstreams,Ndispo,Nformat,Ntags,Nmp3s = [ {},{},{},{},{} ]
insert = []
for k in db:
  info = db[k]
  if len(info["streams"]) > 1 :
    print( 'Notice:: file  "{}"  has another stream.'.format(k) )
  try:
    _streams = info['streams'][0]
  except:
    _streams = {}
  try:
    _format = info['format']
  except:
    _format = {}
  try:
    _dispo = _streams['disposition']
    del _streams['disposition']
  except:
    _dispo = {}
  try:
    _tags = _format['tags']
    del _format['tags']
  except:
    _tags = {}
  _mp3s = {'filepath':k}
  _streams.update(_mp3s)
  _format.update( _mp3s)
  _dispo.update(  _mp3s)
  _tags.update(   _mp3s)

  for ins in (['streams'    ,_streams]
             ,['format'     ,_format]
             ,['disposition',_dispo]
             ,['tags'       ,_tags]
             ,['mp3s'       ,_mp3s]):
    insert.append( insert_query(ins) )

  Nstreams = colsizing(Nstreams,_streams)
  Nformat  = colsizing(Nformat, _format )
  Ndispo   = colsizing(Ndispo,  _dispo  )
  Ntags    = colsizing(Ntags,   _tags   )
  Nmp3s    = colsizing(Nmp3s,   _mp3s   )

for cr8 in (['streams'    ,Nstreams]
           ,['format'     ,Nformat]
           ,['disposition',Ndispo]
           ,['tags'       ,Ntags]
           ,['mp3s'       ,Nmp3s]):
  sqls.append( create_query(cr8) )

#with open('./log.ffprobe','w') as qp:
#  qp.write( "\n".join(sqls) )
print(        "\n".join(sqls) )
#  qp.write( "\n\n"+insert )
print( "\n\n"+"\n".join(insert) )
#print( "SQL file was created: ./log.ffprobe" )

