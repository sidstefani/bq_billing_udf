SELECT
    case when gcp_billing_export.sku.description like"%N1%" then "N1"
          when gcp_billing_export.sku.description like "%N2D%" then "N2D"
          when gcp_billing_export.sku.description like "%N2%" then "N2"
          when gcp_billing_export.sku.description like "%E2%" then "E2"
          when gcp_billing_export.sku.description like "%Sole Tenant%" then "Sole Tenant"
          when gcp_billing_export.sku.description like "%C2%" then "C2"
          when gcp_billing_export.sku.description like "%M2%" then "M2"
          when gcp_billing_export.sku.description like "%Commitment v1: Cpu in%" then "N1"
          when gcp_billing_export.sku.description like "%Commitment v1: Ram in%" then "N1"
          else "Other" end AS gcp_billing_export_machine_type,
    CASE
          WHEN gcp_billing_export.currency = 'USD' THEN '$'
          WHEN gcp_billing_export.currency = 'EUR' THEN '€'
          WHEN gcp_billing_export.currency = 'JPY' THEN '¥'
          WHEN gcp_billing_export.currency = 'AUD'THEN 'A$'
          WHEN gcp_billing_export.currency = 'BRL'THEN 'R$'
          WHEN gcp_billing_export.currency = 'CAD'THEN 'C$'
          WHEN gcp_billing_export.currency = 'HKD' THEN 'HK$'
          WHEN gcp_billing_export.currency = 'INR' THEN '₹'
          WHEN gcp_billing_export.currency = 'IDR' THEN 'Rp'
          WHEN gcp_billing_export.currency = 'ILS' THEN '₪'
          WHEN gcp_billing_export.currency = 'MXN' THEN 'Mex$'
          WHEN gcp_billing_export.currency = 'NZD' THEN 'NZ$'
          WHEN gcp_billing_export.currency = 'GBP' THEN '£'
          ELSE CONCAT(gcp_billing_export.currency, ' ')
        END AS gcp_billing_export_currency_symbol,
    COALESCE(SUM(gcp_billing_export.cost ), 0) AS gcp_billing_export_total_cost,
        COALESCE(SUM(gcp_billing_export.cost ), 0) - COALESCE(SUM(( ( SELECT SUM(-gcp_billing_export__credits.amount) FROM UNNEST(gcp_billing_export.credits) as gcp_billing_export__credits  )  ) ), 0) AS gcp_billing_export_total_net_cost
FROM `sidney-stefani.looker_scratch.LR_CMQSD1681753303785_gcp_billing_export` AS gcp_billing_export
GROUP BY
    1,
    2
ORDER BY
    3 DESC
LIMIT 500
