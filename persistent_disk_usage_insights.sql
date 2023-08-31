SELECT
    (gcp_billing_export.usage_start_date
    ) AS gcp_billing_export_usage_start_date,
    pricing.pricing_type AS pricing_pricing_type,
    CASE
      -- VCPU RAM
        WHEN gcp_billing_export.usage.pricing_unit = 'gibibyte hour' THEN 'GB'
      -- VCPU Cores
        WHEN gcp_billing_export.usage.pricing_unit = 'hour' THEN 'Count'
      -- PD Storage
      -- WHEN usage.pricing_unit = 'gibibyte month' THEN ROUND(SUM(usage.amount_in_pricing_units) * 30, 2)
      ELSE gcp_billing_export.usage.pricing_unit END AS gcp_billing_export_usage__calculated_unit,
    COALESCE(SUM(CASE
      -- VCPU RAM
        WHEN usage.pricing_unit = 'gibibyte hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- VCPU Cores
        WHEN usage.pricing_unit = 'hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- PD Storage
      -- WHEN usage.pricing_unit = 'gibibyte month' THEN ROUND(SUM(usage.amount_in_pricing_units) * 30, 2)
      ELSE  gcp_billing_export.usage.amount_in_pricing_units
    END), 0) AS gcp_billing_export_usage__amount_in_calculated_units
FROM `ALIAS BILLING EXPORT` AS gcp_billing_export
LEFT JOIN `ALIAS PRICING EXPORT` AS pricing ON pricing.sku__id = gcp_billing_export.sku.id
WHERE (gcp_billing_export.service.description ) = 'Compute Engine' AND ((( gcp_billing_export.usage_start_date
     ) >= ((DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH))) AND ( gcp_billing_export.usage_start_date
     ) < ((DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH), INTERVAL 12 MONTH))))) AND (pricing.pricing_category) = 'Persistent Disk'
GROUP BY
    1,
    2,
    3
ORDER BY
    1 DESC
LIMIT 500

-- sql for creating the total and/or determining pivot columns
SELECT
    COALESCE(SUM(CASE
      -- VCPU RAM
        WHEN usage.pricing_unit = 'gibibyte hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- VCPU Cores
        WHEN usage.pricing_unit = 'hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- PD Storage
      -- WHEN usage.pricing_unit = 'gibibyte month' THEN ROUND(SUM(usage.amount_in_pricing_units) * 30, 2)
      ELSE  gcp_billing_export.usage.amount_in_pricing_units
    END), 0) AS gcp_billing_export_usage__amount_in_calculated_units
FROM `ALIAS BILLING EXPORT` AS gcp_billing_export
LEFT JOIN `ALIAS PRICING EXPORT` AS pricing ON pricing.sku__id = gcp_billing_export.sku.id
WHERE (gcp_billing_export.service.description ) = 'Compute Engine' AND ((( gcp_billing_export.usage_start_date
     ) >= ((DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH))) AND ( gcp_billing_export.usage_start_date
     ) < ((DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -12 MONTH), INTERVAL 12 MONTH))))) AND (pricing.pricing_category) = 'Persistent Disk'
LIMIT 1
