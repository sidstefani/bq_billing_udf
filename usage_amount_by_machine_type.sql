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
    COALESCE(SUM(CASE
      -- VCPU RAM
        WHEN usage.pricing_unit = 'gibibyte hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- VCPU Cores
        WHEN usage.pricing_unit = 'hour' THEN  gcp_billing_export.usage.amount_in_pricing_units  /24
      -- PD Storage
      -- WHEN usage.pricing_unit = 'gibibyte month' THEN ROUND(SUM(usage.amount_in_pricing_units) * 30, 2)
      ELSE  gcp_billing_export.usage.amount_in_pricing_units
    END), 0) AS gcp_billing_export_usage__amount_in_calculated_units
FROM `ENTER ALIAS HERE` AS gcp_billing_export
WHERE (gcp_billing_export.service.description ) = 'Compute Engine' AND (CASE
      -- VCPU RAM
        WHEN gcp_billing_export.usage.pricing_unit = 'gibibyte hour' THEN 'GB'
      -- VCPU Cores
        WHEN gcp_billing_export.usage.pricing_unit = 'hour' THEN 'Count'
      -- PD Storage
      -- WHEN usage.pricing_unit = 'gibibyte month' THEN ROUND(SUM(usage.amount_in_pricing_units) * 30, 2)
      ELSE gcp_billing_export.usage.pricing_unit END) = 'Count'
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT 500
