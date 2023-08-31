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
        ROUND(COALESCE(CAST( ( SUM(DISTINCT (CAST(ROUND(COALESCE( (gcp_billing_export.cost ) ,0)*(1/1000*1.0), 9) AS NUMERIC) + (cast(cast(concat('0x', substr(to_hex(md5(CAST( (gcp_billing_export.pk )  AS STRING))), 1, 15)) as int64) as numeric) * 4294967296 + cast(cast(concat('0x', substr(to_hex(md5(CAST( (gcp_billing_export.pk )  AS STRING))), 16, 8)) as int64) as numeric)) * 0.000000001 )) - SUM(DISTINCT (cast(cast(concat('0x', substr(to_hex(md5(CAST( (gcp_billing_export.pk )  AS STRING))), 1, 15)) as int64) as numeric) * 4294967296 + cast(cast(concat('0x', substr(to_hex(md5(CAST( (gcp_billing_export.pk )  AS STRING))), 16, 8)) as int64) as numeric)) * 0.000000001) )  / (1/1000*1.0) AS NUMERIC), 0), 6) - COALESCE(SUM(-1* gcp_billing_export__credits.amount   ), 0) AS gcp_billing_export_total_net_cost
FROM `ENTER ALIAS HERE` AS gcp_billing_export
LEFT JOIN UNNEST(gcp_billing_export.credits) as gcp_billing_export__credits
WHERE (gcp_billing_export.service.description ) = 'Compute Engine'
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT 500
