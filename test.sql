-- requests (по дате Лида)

WITH requests_lead AS (
		SELECT DATE_FORMAT(r.date , '%Y-%m-%d')                                                         AS request_date_requests -- по дате Лида
			# general info
				, r.id                                                                                      AS request_id_requests
        , cur.short_name																			                                      AS currency_requests
        , CASE WHEN r.sale_type = '0' THEN 'ГП' WHEN r.sale_type = '1' THEN 'ХП' ELSE 'ХВ' END		  AS call_center_type_requests              
        , r.filial_id                                               								                AS filial_id_requests
        , CONCAT(f.name	," ", "(", f.short_name, ")")												                        AS filial_name_requests
        , oc.name                                                                                  	AS category_name_requests
        , o.offer_category																			                                    AS category_filter_requests
        , CONCAT(u.id, "_", u.name)                                                               	AS web_name_requests
        , u.is_our                                                                                 	AS is_our_requests
      # statuses
        , CASE WHEN r.status IN ('3','4','5','6','7','8','9','12','15') THEN 1 ELSE NULL END 		    AS is_approved_requests
        , CASE WHEN r.status IN ('-2', '0') THEN 1 ELSE 0 END 										                  AS is_new_lead_requests
        , CASE WHEN r.status IN ('3', '4', '5', '6', '7', '8', '9', '12', '15') THEN 1 ELSE 0 END 	AS is_send_requests
        , CASE WHEN r.status IN ('6', '7') THEN 1 ELSE 0 END 					       				                AS is_picked_up_requests
        , CASE WHEN r.status IN ('-2', '0', '2', '11', '17') THEN 1 ELSE 0 END 					          	AS is_hold_requests
        , CASE WHEN r.status IN ('10') THEN 1 ELSE 0 END 										                      	AS is_trash_requests
      # totals
				, ro.total                                                                              	  AS total_requests
    FROM requests AS r 
          LEFT JOIN filial AS f ON r.filial_id = f.id
          LEFT JOIN offers AS o ON r.offer_id = o.id
          LEFT JOIN offers_category AS oc ON o.offer_category = oc.id 
          LEFT JOIN requests_orders ro ON r.id=ro.request_id
          LEFT JOIN countries AS c ON f.country_id = c.id
          LEFT JOIN currency AS cur ON c.currency_id = cur.id
          LEFT JOIN users AS u ON r.user_id = u.id
    WHERE 1=1
          AND r.advertiser_id = 1 
          AND r.status NOT IN ('-3','-4')
          AND DATE_FORMAT(r.date , '%Y-%m-%d') >= '2023-01-01'
)

SELECT *
FROM requests_lead
