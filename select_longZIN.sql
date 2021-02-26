
select filepath,duration from format where duration > 300 and filepath !~ 'DJ Mix' order by duration desc;

