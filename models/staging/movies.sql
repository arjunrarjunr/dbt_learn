{ { config(
    materialized = 'table',
    pre_hook = [
            "{{model_movie_prehook()}}"

        ]
) } }
select movie_id,
    title,
    industry,
    release_year,
    imdb_rating,
    studio,
    language_id,
    year(current_timestamp()) - year(release_year) as movie_age
from { { source('raw', 'raw_movies') } }