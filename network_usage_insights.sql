SELECT
    pricing.pricing_type AS pricing_pricing_type,
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
FROM `sidney-stefani.looker_scratch.LR_CMQSD1681753303785_gcp_billing_export` AS gcp_billing_export
LEFT JOIN `sidney-stefani.looker_scratch.LR_CM1J01686322129852_pricing` AS pricing ON pricing.sku__id = gcp_billing_export.sku.id
WHERE (gcp_billing_export.service.description ) = 'Compute Engine' AND ((( gcp_billing_export.usage_start_date
     ) >= ((DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH))) AND ( gcp_billing_export.usage_start_date
     ) < ((DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH), INTERVAL 12 MONTH))))) AND ((pricing.pricing_type) LIKE 'Egress%' OR (pricing.pricing_type) LIKE 'Ingress%') AND (pricing.pricing_category) = 'Network'
GROUP BY
    1,
    2
LIMIT 30000

-- sql for creating the total and/or determining pivot columns
SELECT
    pricing.pricing_type AS pricing_pricing_type,
    COALESCE(SUM(CASE
      -- VCPU RAM
        WHEN usage.pricing_unit = 'gibibyte hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- VCPU Cores
        WHEN usage.pricing_unit = 'hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- PD Storage
      -- WHEN usage.pricing_unit = 'gibibyte month' THEN ROUND(SUM(usage.amount_in_pricing_units) * 30, 2)
      ELSE  gcp_billing_export.usage.amount_in_pricing_units
    END), 0) AS gcp_billing_export_usage__amount_in_calculated_units
FROM `sidney-stefani.looker_scratch.LR_CMQSD1681753303785_gcp_billing_export` AS gcp_billing_export
LEFT JOIN `sidney-stefani.looker_scratch.LR_CM1J01686322129852_pricing` AS pricing ON pricing.sku__id = gcp_billing_export.sku.id
WHERE (gcp_billing_export.service.description ) = 'Compute Engine' AND ((( gcp_billing_export.usage_start_date
     ) >= ((DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH))) AND ( gcp_billing_export.usage_start_date
     ) < ((DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH), INTERVAL 12 MONTH))))) AND ((pricing.pricing_type) LIKE 'Egress%' OR (pricing.pricing_type) LIKE 'Ingress%') AND (pricing.pricing_category) = 'Network'
GROUP BY
    1
ORDER BY
    1
LIMIT 50
