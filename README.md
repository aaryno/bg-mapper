

docker run -it -v $HOME/personal/asdm/data/imagery:/imagery  ghcr.io/osgeo/gdal bash
root@163b59b85ebf:/# cd /imagery      
root@163b59b85ebf:/imagery# /usr/bin/gdal_retile.py -v -r bilinear -levels 4 -ps 2048 2048 -co 
"TILED=YES" -co "COMPRESS=JPEG" -targels srctDir tuma_pyramid2 Tumamoc_ortho/Tumamoc_ortho.jp2


docker run -it -v $HOME/personal/asdm/data/imagery:/imagery "/usr/bin/gdal_retile.py -v -r bilinear -levels 4 -ps 2048 2048 -co "TILED=YES" -co "COMPRESS=JPEG" -targetDir /imagery/tuma_pyramid2 /imagery/Tumamoc_ortho/Tumamoc_ortho.jp2


## 9/17/2022
New plan:
- postgres backend database for user estimates
- titler dynamic tiling to serve backend
- cog backend for imagery


```
make dev-up
```

curl -X 'GET' \
  'http://127.0.0.1:8000/cog/bounds?url=http%3A%2F%2F127.0.0.1%3A8000%2Fimagery%2F20230305_171333_ssc2d1_0001_pansharpened_clip_cog.tif' \ 
  -H 'accept: application/json'
{"detail":"Range downloading not supported by this server!"}%  


curl -X 'GET' \
  'http://127.0.0.1:8000/cog/bounds?url=http%3A%2F%2F127.0.0.1%3A8000%2Fimagery' \ 
  -H 'accept: application/json'
{"detail":"Range downloading not supported by this server!"}%  

http://127.0.0.1:8000/imagery

docker run --name nginx -p 8082:80 -v /Users/aaryn/personal/asdm/data/imagery/:/usr/share/nginx/html:ro -d nginx

http://127.0.0.1:8082/pusch_cog_march2023_skysatscene_pansharpened_udm2/composite_file_format.tif