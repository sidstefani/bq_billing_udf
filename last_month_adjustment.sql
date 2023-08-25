SELECT
    gcp_billing_export.adjustment_info.description  AS gcp_billing_export_adjustment_info__description,
    CASE
        WHEN gcp_billing_export.adjustment_info.type = 'USAGE_CORRECTION' THEN 'Usage Correction'
        WHEN gcp_billing_export.adjustment_info.type = 'GENERAL_ADJUSTMENT' THEN 'General Adjustment'
        WHEN gcp_billing_export.adjustment_info.type = 'GOODWILL' THEN 'Goodwill'
        ELSE gcp_billing_export.adjustment_info.type
    END  AS gcp_billing_export_adjustment_info__type,
    CASE
        WHEN gcp_billing_export.adjustment_info.mode = 'MANUAL_ADJUSTMENT' THEN 'Manual Adjustment'
        WHEN gcp_billing_export.adjustment_info.mode = 'COMPLETE_NEGATION' THEN 'Complete Negation'
        WHEN gcp_billing_export.adjustment_info.mode = 'COMPLETE_NEGATION_WITH_REMONETIZATION' THEN 'Complete Negation with Remonetization'
        ELSE gcp_billing_export.adjustment_info.mode
    END  AS gcp_billing_export_adjustment_info__mode,
    gcp_billing_export.adjustment_info.id  AS gcp_billing_export_adjustment_info__id
FROM `sidney-stefani.looker_scratch.LR_CMQSD1681753303785_gcp_billing_export` AS gcp_billing_export
WHERE ((( date(CAST(substring(gcp_billing_export.invoice.month,1,4) AS int),CAST(substring(gcp_billing_export.invoice.month,5,2) AS int),01) ) >= ((DATE('2022-04-01'))) AND ( date(CAST(substring(gcp_billing_export.invoice.month,1,4) AS int),CAST(substring(gcp_billing_export.invoice.month,5,2) AS int),01) ) < ((DATE_ADD(DATE('2022-04-01'), INTERVAL 1 MONTH)))))
GROUP BY
    1,
    2,
    3,
    4
ORDER BY
    1
LIMIT 500
