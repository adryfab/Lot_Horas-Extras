use HorasExtSup
go

-- select * from tbHorasExtras where activo = 1

declare @hora_50 as int;
declare @min_50 as int;
declare @hora_per as int;
declare @min_per as int;

SELECT 
@hora_50=((SUM(DATEPART(HOUR, horas50 )) )+(SUM(DATEPART(MINUTE, horas50 )) )/60) 
,@min_50=(SUM(DATEPART(MINUTE, horas50 )) )%60 
,@hora_per=((SUM(DATEPART(HOUR, HorasPermiso )) )+(SUM(DATEPART(MINUTE, HorasPermiso )) )/60) 
,@min_per=(SUM(DATEPART(MINUTE, HorasPermiso )) )%60 
from [tbHorasExtras] 

select	 convert(varchar,@hora_50)+':'+convert(varchar,@min_50) as 'total50'
		,convert(varchar,@hora_per)+':'+convert(varchar,@min_per) as 'totalPer'

if (@min_50 >= @min_per)
begin
	--select '@min_50 >= @min_per'
	select 
			--horas_h50
		  --, horas_per
		   horas_h50-horas_per as 'totalHoras'
		  --, minutos_h50
		  --, minutos_per
		  , minutos_h50-minutos_per as 'totalMinutos'
	from (
		SELECT ((SUM(DATEPART(HOUR, horas50 )) )+(SUM(DATEPART(MINUTE, horas50 )) )/60) as horas_h50,(SUM(DATEPART(MINUTE, horas50 )) )%60 as minutos_h50, 
		((SUM(DATEPART(HOUR, HorasPermiso )) )+(SUM(DATEPART(MINUTE, HorasPermiso )) )/60) as horas_per,(SUM(DATEPART(MINUTE, HorasPermiso )) )%60 as minutos_per
		from [tbHorasExtras] 
	) a
end
else 
begin
	--select '@min_50 < @min_per'
	select 
			--horas_h50
		  --, horas_per
		  --, minutos_h50
		  --, minutos_per
		   horas_h50-horas_per-1 as 'totalHoras'
		 , ((minutos_h50-(minutos_per+60))+60)*(-1) as 'totalMinutos'
	from (
		SELECT ((SUM(DATEPART(HOUR, horas50 )) )+(SUM(DATEPART(MINUTE, horas50 )) )/60) as horas_h50,(SUM(DATEPART(MINUTE, horas50 )) )%60 as minutos_h50, 
		((SUM(DATEPART(HOUR, HorasPermiso )) )+(SUM(DATEPART(MINUTE, HorasPermiso )) )/60) as horas_per,(SUM(DATEPART(MINUTE, HorasPermiso )) )%60 as minutos_per
		from [tbHorasExtras] 
	) a
end 
