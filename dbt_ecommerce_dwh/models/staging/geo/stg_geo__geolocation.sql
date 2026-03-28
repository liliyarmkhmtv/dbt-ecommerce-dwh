with source as (
        select * from {{ source('geo', 'geolocation') }}
  ),
  renamed as (
    select
        cast(geolocation_zip_code_prefix as string) as zip_code_prefix,
        geolocation_lat             as lat,
        geolocation_lng             as lng,
        geolocation_city            as city,
        geolocation_state           as state
    from source
  )
  select * from renamed