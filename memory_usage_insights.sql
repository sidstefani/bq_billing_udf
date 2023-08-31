SELECT
    pricing.pricing_usage_type AS pricing_pricing_usage_type,
        (FORMAT_DATE('%Y-%m', gcp_billing_export.usage_start_date
    )) AS gcp_billing_export_usage_start_month,
    COALESCE(SUM(CASE
      -- VCPU RAM
        WHEN usage.pricing_unit = 'gibibyte hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- VCPU Cores
        WHEN usage.pricing_unit = 'hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- PD Storage
      -- WHEN usage.pricing_unit = 'gibibyte month' THEN ROUND(SUM(usage.amount_in_pricing_units) * 30, 2)
      ELSE  gcp_billing_export.usage.amount_in_pricing_units
    END), 0) AS gcp_billing_export_usage__amount_in_calculated_units
FROM `ENTER BILLING ALIAS` AS gcp_billing_export
LEFT JOIN `ENTER PRICING ALIAS` AS pricing ON pricing.sku__id = gcp_billing_export.sku.id
WHERE (gcp_billing_export.service.description ) = 'Compute Engine' AND ((( gcp_billing_export.usage_start_date
     ) >= ((DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH))) AND ( gcp_billing_export.usage_start_date
     ) < ((DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH), INTERVAL 12 MONTH))))) AND (pricing.pricing_type) LIKE 'RAM%' AND (pricing.pricing_category) = 'VM'
GROUP BY
    1,
    2
LIMIT 30000
