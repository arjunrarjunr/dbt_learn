{% macro model_movie_prehook() %}
    {% set sql %}
        -- TRUNCATE TABLE DBT.RAW.RAW_MOVIES;
        CREATE
            OR REPLACE TEMPORARY TABLE DBT.RAW.TEMP_RAW_MOVIES (
                MOVIE_ID NUMBER(38, 0),
                TITLE TEXT,
                INDUSTRY TEXT,
                RELEASE_YEAR NUMBER(4, 0),
                IMDB_RATING NUMBER(2, 1),
                STUDIO TEXT,
                LANGUAGE_ID TEXT
            );
        COPY INTO DBT.RAW.TEMP_RAW_MOVIES
        FROM
            @DBT.RAW.INGEST FILE_FORMAT = (
                TYPE = CSV TRIM_SPACE = TRUE RECORD_DELIMITER = '\n' FIELD_DELIMITER = ',' PARSE_HEADER = TRUE NULL_IF = ('NULL')
            ) PURGE = TRUE MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
        INSERT INTO
            DBT.RAW.RAW_MOVIES
        SELECT
            *
        FROM
            DBT.RAW.TEMP_RAW_MOVIES;
    {% endset %}

    {% do run_query(sql) %}
    {% do log("model_movie_prehook ran successfully", info=True) %}
    
    
{% endmacro %}

