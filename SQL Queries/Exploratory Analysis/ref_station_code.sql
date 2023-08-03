 SELECT n.station_id AS new_id,
    o.id AS old_id,
    n.name AS station_name,
    n.district,
    n.deployment_year,
    n.total_docks,
    n.latitude,
    n.longitude
   FROM new_station n
     LEFT JOIN old_station o ON o.name = n.name;