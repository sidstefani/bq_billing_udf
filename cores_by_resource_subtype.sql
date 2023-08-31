SELECT
    pricing.pricing_type AS pricing_pricing_type,
    pricing.pricing_sub_type AS pricing_pricing_sub_type,
    pricing.pricing_usage_type AS pricing_pricing_usage_type,
    COALESCE(SUM(gcp_billing_export.cost ), 0) AS gcp_billing_export_total_cost
FROM `sidney-stefani.looker_scratch.LR_CMQSD1681753303785_gcp_billing_export` AS gcp_billing_export
LEFT JOIN `sidney-stefani.looker_scratch.LR_CM1J01686322129852_pricing` AS pricing ON pricing.sku__id = gcp_billing_export.sku.id
WHERE (gcp_billing_export.service.description ) = 'Compute Engine' AND ((( gcp_billing_export.usage_start_date
     ) >= ((DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH))) AND ( gcp_billing_export.usage_start_date
     ) < ((DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH), INTERVAL 12 MONTH))))) AND (pricing.pricing_type) LIKE 'Cores%' AND (pricing.pricing_category) = 'VM'
GROUP BY
    1,
    2,
    3
ORDER BY
    1
LIMIT 500
