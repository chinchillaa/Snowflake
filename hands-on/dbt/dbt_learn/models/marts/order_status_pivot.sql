{# 注文ステータス別のカウントをピボットするモデル #}
{# F=完了(Fulfilled), O=未処理(Open), P=保留(Pending) #}
{% set statuses = ['F', 'O', 'P'] %}

select
    customer_id,
    count(*) as total_orders,
    {% for status in statuses%}
    {# 各ステータスに該当する注文数をカウント #}
    count(case when order_status = '{{ status }}' then 1 end) as status_{{ status }}_count
    {% if not loop.last %},{# 最後のカラム以外はカンマを付与 #}
    {% endif %}
    {% endfor%}
from {{ ref('stg_orders')}}
group by customer_id