SELECT
    gcp_billing_export.adjustment_info.description  AS gcp_billing_export_adjustment_info__description,
    CASE
        WHEN gcp_billing_export.adjustment_info.mode = 'MANUAL_ADJUSTMENT' THEN 'Manual Adjustment'
        WHEN gcp_billing_export.adjustment_info.mode = 'COMPLETE_NEGATION' THEN 'Complete Negation'
        WHEN gcp_billing_export.adjustment_info.mode = 'COMPLETE_NEGATION_WITH_REMONETIZATION' THEN 'Complete Negation with Remonetization'
        ELSE gcp_billing_export.adjustment_info.mode
    END  AS gcp_billing_export_adjustment_info__mode,
    gcp_billing_export.adjustment_info.id  AS gcp_billing_export_adjustment_info__id
FROM `sidney-stefani.looker_scratch.LR_CMQSD1681753303785_gcp_billing_export` AS gcp_billing_export
WHERE (CASE
        WHEN gcp_billing_export.adjustment_info.type = 'USAGE_CORRECTION' THEN 'Usage Correction'
        WHEN gcp_billing_export.adjustment_info.type = 'GENERAL_ADJUSTMENT' THEN 'General Adjustment'
        WHEN gcp_billing_export.adjustment_info.type = 'GOODWILL' THEN 'Goodwill'
        ELSE gcp_billing_export.adjustment_info.type
    END ) = 'Usage Correction'
GROUP BY
    1,
    2,
    3
ORDER BY
    1
LIMIT 500
