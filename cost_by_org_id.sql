SELECT
    REGEXP_EXTRACT( gcp_billing_export.project.ancestry_numbers,"^/([0-9]+)")  AS gcp_billing_export_gcp_org_id,
    COALESCE(SUM(gcp_billing_export.cost ), 0) AS gcp_billing_export_total_cost
FROM `ENTER BILLING ALIAS` AS gcp_billing_export
WHERE ((( gcp_billing_export.usage_start_date
     ) >= ((DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -5 MONTH))) AND ( gcp_billing_export.usage_start_date
     ) < ((DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE('America/Los_Angeles'), MONTH), INTERVAL -5 MONTH), INTERVAL 6 MONTH)))))
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT 500
