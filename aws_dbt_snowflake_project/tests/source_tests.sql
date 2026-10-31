{{
    config(
        severity = 'warn'
        )
}}

select 
    1
FROM 
    {{ source('staging', 'bookings')}}
WHERE
    BOOKING_AMOUNT  < 200 