SELECT * 
FROM `first-1-448418.SUMMMERPROJECT.SUMPROJ` limit 100;

-- define sales funnel and diff stages

with funnel_stages as (

select
  count(distinct case when event_type = 'page_view'  then user_id end) as stage_views,
count(distinct case when event_type = 'add_to_cart'  then user_id end) as stage_2_cart,
count(distinct case when event_type = 'checkout_start'  then user_id end) as stage_3_checkout,
count(distinct case when event_type = 'payment_info'  then user_id end) as stage_4_payment,
count(distinct case when event_type = 'purchase'  then user_id end) as stage_5_purchase

FROM `first-1-448418.SUMMMERPROJECT.SUMPROJ`

  WHERE event_date >= TIMESTAMP(DATE_SUB(DATE '2026-02-10', INTERVAL 30 DAY))
)

select * from funnel_stages;


-- conversion rates throuigh funnel

with funnel_stages as (

select
  count(distinct case when event_type = 'page_view'  then user_id end) as stage_views,
count(distinct case when event_type = 'add_to_cart'  then user_id end) as stage_2_cart,
count(distinct case when event_type = 'checkout_start'  then user_id end) as stage_3_checkout,
count(distinct case when event_type = 'payment_info'  then user_id end) as stage_4_payment,
count(distinct case when event_type = 'purchase'  then user_id end) as stage_5_purchase

FROM `first-1-448418.SUMMMERPROJECT.SUMPROJ`

  WHERE event_date >= TIMESTAMP(DATE_SUB(DATE '2026-02-10', INTERVAL 30 DAY))
)
select 
stage_views,
stage_2_cart,
round(stage_2_cart * 100 / stage_views) as view_to_cart_rate,

stage_3_checkout,
round(stage_3_checkout * 100 / stage_2_cart) as cart_to_rate,

stage_4_payment,
round(stage_4_payment * 100 / stage_3_checkout) as checkout_to_payment_rate,

stage_5_purchase,
round(stage_5_purchase * 100 / stage_4_payment) as payment_to_purchase_rate,

round(stage_5_purchase * 100 / stage_views) as overall_conversion_rate


from funnel_stages;


-- funnel by source

with source_funnel as (
select
traffic_source,
count(distinct case when event_type = 'page_view'  then user_id end) as views,
count(distinct case when event_type = 'add_to_cart'  then user_id end) as cart,
count(distinct case when event_type = 'purchase'  then user_id end) as purchases

FROM `first-1-448418.SUMMMERPROJECT.SUMPROJ`

  WHERE event_date >= TIMESTAMP(DATE_SUB(DATE '2026-02-10', INTERVAL 30 DAY))
group by traffic_source

)

select
traffic_source,
views,
cart,
purchases,
round(cart * 100 / views) as cart_conversion_rate,
round(purchases * 100 / views) as purchase_conversion_rate,

round(purchases * 100 / cart) as cart_to_purchase_conversion_rate,

from source_funnel
order by purchases desc;

-- time to conversion analysis

with user_journey as (
select
user_id,
min(case when event_type = 'page_view'  then event_date end) as view_time,
min(case when event_type = 'add_to_cart'  then event_date end) as cart_time,
min(case when event_type = 'purchase'  then event_date end) as purchase_time

FROM `first-1-448418.SUMMMERPROJECT.SUMPROJ`

  WHERE event_date >= TIMESTAMP(DATE_SUB(DATE '2026-02-10', INTERVAL 30 DAY))
group by user_id
having min(case when event_type = 'purchase' then event_date end) is not null

)

select
count(*) as converted_users,
round(avg(timestamp_diff(cart_time, view_time, MINUTE)),2) as avg_view_to_cart_min,
round(avg(timestamp_diff(purchase_time, cart_time, MINUTE)),2) as avg_cart_to_purchase_min,
round(avg(timestamp_diff(purchase_time, view_time, MINUTE)),2) as avg_total_journey_min,

from user_journey;

-- revenue funnel analysis

with funnel_revenue as (
select
count(distinct case when event_type = 'page_view' then user_id end) as total_visitors,
count(distinct case when event_type = 'purchase' then user_id end) as total_buyers,
sum(case when event_type = 'purchase' then amount end) as total_revenue,
count(case when event_type = 'purchase' then 1 end) as total_orders,

FROM `first-1-448418.SUMMMERPROJECT.SUMPROJ`

  WHERE event_date >= TIMESTAMP(DATE_SUB(DATE '2026-02-10', INTERVAL 30 DAY))

)

select
total_visitors,
total_buyers,
total_orders,
total_revenue,
total_revenue / total_orders as avg_order_value,
total_revenue / total_buyers as revenue_per_buyer,
total_revenue / total_visitors as revenue_per_visitor


from funnel_revenue
