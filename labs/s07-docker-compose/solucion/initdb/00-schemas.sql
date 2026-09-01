-- Esquemas usados a lo largo del curso.
-- cdm    : tablas OMOP CDM v5.4 (sesiones 12-18)
-- results: tablas de cohortes y resultados generados por los alumnos
-- staging: cargas intermedias
CREATE SCHEMA IF NOT EXISTS cdm;
CREATE SCHEMA IF NOT EXISTS results;
CREATE SCHEMA IF NOT EXISTS staging;

ALTER DATABASE omop SET search_path TO cdm, results, public;

COMMENT ON SCHEMA cdm IS 'OMOP Common Data Model v5.4 - datos sinteticos del curso';
COMMENT ON SCHEMA results IS 'Cohortes y resultados de los alumnos';
