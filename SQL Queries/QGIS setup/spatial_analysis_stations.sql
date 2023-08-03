ALTER TABLE stations_all
ADD COLUMN geom geometry(point,4326);

UPDATE stations_all
SET geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);
