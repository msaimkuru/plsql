DECLARE 
    CURSOR C1 IS
    SELECT 'Afghanistan' as COUNTRY, 'AF' as Alpha_2_Country_Code, 'AFG' as Alpha_3_Country_Code, 4 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Albania' as COUNTRY, 'AL' as Alpha_2_Country_Code, 'ALB' as Alpha_3_Country_Code, 8 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Algeria' as COUNTRY, 'DZ' as Alpha_2_Country_Code, 'DZA' as Alpha_3_Country_Code, 12 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'American Samoa' as COUNTRY, 'AS' as Alpha_2_Country_Code, 'ASM' as Alpha_3_Country_Code, 16 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Andorra' as COUNTRY, 'AD' as Alpha_2_Country_Code, 'AND' as Alpha_3_Country_Code, 20 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Angola' as COUNTRY, 'AO' as Alpha_2_Country_Code, 'AGO' as Alpha_3_Country_Code, 24 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Anguilla' as COUNTRY, 'AI' as Alpha_2_Country_Code, 'AIA' as Alpha_3_Country_Code, 660 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Antarctica' as COUNTRY, 'AQ' as Alpha_2_Country_Code, 'ATA' as Alpha_3_Country_Code, 10 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Antigua and Barbuda' as COUNTRY, 'AG' as Alpha_2_Country_Code, 'ATG' as Alpha_3_Country_Code, 28 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Argentina' as COUNTRY, 'AR' as Alpha_2_Country_Code, 'ARG' as Alpha_3_Country_Code, 32 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Armenia' as COUNTRY, 'AM' as Alpha_2_Country_Code, 'ARM' as Alpha_3_Country_Code, 51 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Aruba' as COUNTRY, 'AW' as Alpha_2_Country_Code, 'ABW' as Alpha_3_Country_Code, 533 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Australia' as COUNTRY, 'AU' as Alpha_2_Country_Code, 'AUS' as Alpha_3_Country_Code, 36 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Austria' as COUNTRY, 'AT' as Alpha_2_Country_Code, 'AUT' as Alpha_3_Country_Code, 40 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Azerbaijan' as COUNTRY, 'AZ' as Alpha_2_Country_Code, 'AZE' as Alpha_3_Country_Code, 31 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bahamas (the)' as COUNTRY, 'BS' as Alpha_2_Country_Code, 'BHS' as Alpha_3_Country_Code, 44 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bahrain' as COUNTRY, 'BH' as Alpha_2_Country_Code, 'BHR' as Alpha_3_Country_Code, 48 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bangladesh' as COUNTRY, 'BD' as Alpha_2_Country_Code, 'BGD' as Alpha_3_Country_Code, 50 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Barbados' as COUNTRY, 'BB' as Alpha_2_Country_Code, 'BRB' as Alpha_3_Country_Code, 52 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Belarus' as COUNTRY, 'BY' as Alpha_2_Country_Code, 'BLR' as Alpha_3_Country_Code, 112 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Belgium' as COUNTRY, 'BE' as Alpha_2_Country_Code, 'BEL' as Alpha_3_Country_Code, 56 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Belize' as COUNTRY, 'BZ' as Alpha_2_Country_Code, 'BLZ' as Alpha_3_Country_Code, 84 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Benin' as COUNTRY, 'BJ' as Alpha_2_Country_Code, 'BEN' as Alpha_3_Country_Code, 204 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bermuda' as COUNTRY, 'BM' as Alpha_2_Country_Code, 'BMU' as Alpha_3_Country_Code, 60 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bhutan' as COUNTRY, 'BT' as Alpha_2_Country_Code, 'BTN' as Alpha_3_Country_Code, 64 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bolivia (Plurinational State of)' as COUNTRY, 'BO' as Alpha_2_Country_Code, 'BOL' as Alpha_3_Country_Code, 68 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bonaire, Sint Eustatius and Saba' as COUNTRY, 'BQ' as Alpha_2_Country_Code, 'BES' as Alpha_3_Country_Code, 535 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bosnia and Herzegovina' as COUNTRY, 'BA' as Alpha_2_Country_Code, 'BIH' as Alpha_3_Country_Code, 70 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Botswana' as COUNTRY, 'BW' as Alpha_2_Country_Code, 'BWA' as Alpha_3_Country_Code, 72 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bouvet Island' as COUNTRY, 'BV' as Alpha_2_Country_Code, 'BVT' as Alpha_3_Country_Code, 74 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Brazil' as COUNTRY, 'BR' as Alpha_2_Country_Code, 'BRA' as Alpha_3_Country_Code, 76 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'British Indian Ocean Territory (the)' as COUNTRY, 'IO' as Alpha_2_Country_Code, 'IOT' as Alpha_3_Country_Code, 86 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Brunei Darussalam' as COUNTRY, 'BN' as Alpha_2_Country_Code, 'BRN' as Alpha_3_Country_Code, 96 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Bulgaria' as COUNTRY, 'BG' as Alpha_2_Country_Code, 'BGR' as Alpha_3_Country_Code, 100 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Burkina Faso' as COUNTRY, 'BF' as Alpha_2_Country_Code, 'BFA' as Alpha_3_Country_Code, 854 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Burundi' as COUNTRY, 'BI' as Alpha_2_Country_Code, 'BDI' as Alpha_3_Country_Code, 108 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cabo Verde' as COUNTRY, 'CV' as Alpha_2_Country_Code, 'CPV' as Alpha_3_Country_Code, 132 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cambodia' as COUNTRY, 'KH' as Alpha_2_Country_Code, 'KHM' as Alpha_3_Country_Code, 116 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cameroon' as COUNTRY, 'CM' as Alpha_2_Country_Code, 'CMR' as Alpha_3_Country_Code, 120 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Canada' as COUNTRY, 'CA' as Alpha_2_Country_Code, 'CAN' as Alpha_3_Country_Code, 124 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cayman Islands (the)' as COUNTRY, 'KY' as Alpha_2_Country_Code, 'CYM' as Alpha_3_Country_Code, 136 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Central African Republic (the)' as COUNTRY, 'CF' as Alpha_2_Country_Code, 'CAF' as Alpha_3_Country_Code, 140 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Chad' as COUNTRY, 'TD' as Alpha_2_Country_Code, 'TCD' as Alpha_3_Country_Code, 148 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Chile' as COUNTRY, 'CL' as Alpha_2_Country_Code, 'CHL' as Alpha_3_Country_Code, 152 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'China' as COUNTRY, 'CN' as Alpha_2_Country_Code, 'CHN' as Alpha_3_Country_Code, 156 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Christmas Island' as COUNTRY, 'CX' as Alpha_2_Country_Code, 'CXR' as Alpha_3_Country_Code, 162 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cocos (Keeling) Islands (the)' as COUNTRY, 'CC' as Alpha_2_Country_Code, 'CCK' as Alpha_3_Country_Code, 166 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Colombia' as COUNTRY, 'CO' as Alpha_2_Country_Code, 'COL' as Alpha_3_Country_Code, 170 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Comoros (the)' as COUNTRY, 'KM' as Alpha_2_Country_Code, 'COM' as Alpha_3_Country_Code, 174 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Congo (the Democratic Republic of the)' as COUNTRY, 'CD' as Alpha_2_Country_Code, 'COD' as Alpha_3_Country_Code, 180 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Congo (the)' as COUNTRY, 'CG' as Alpha_2_Country_Code, 'COG' as Alpha_3_Country_Code, 178 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cook Islands (the)' as COUNTRY, 'CK' as Alpha_2_Country_Code, 'COK' as Alpha_3_Country_Code, 184 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Costa Rica' as COUNTRY, 'CR' as Alpha_2_Country_Code, 'CRI' as Alpha_3_Country_Code, 188 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Croatia' as COUNTRY, 'HR' as Alpha_2_Country_Code, 'HRV' as Alpha_3_Country_Code, 191 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cuba' as COUNTRY, 'CU' as Alpha_2_Country_Code, 'CUB' as Alpha_3_Country_Code, 192 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Curaçao' as COUNTRY, 'CW' as Alpha_2_Country_Code, 'CUW' as Alpha_3_Country_Code, 531 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Cyprus' as COUNTRY, 'CY' as Alpha_2_Country_Code, 'CYP' as Alpha_3_Country_Code, 196 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Czechia' as COUNTRY, 'CZ' as Alpha_2_Country_Code, 'CZE' as Alpha_3_Country_Code, 203 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Côte d''Ivoire' as COUNTRY, 'CI' as Alpha_2_Country_Code, 'CIV' as Alpha_3_Country_Code, 384 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Denmark' as COUNTRY, 'DK' as Alpha_2_Country_Code, 'DNK' as Alpha_3_Country_Code, 208 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Djibouti' as COUNTRY, 'DJ' as Alpha_2_Country_Code, 'DJI' as Alpha_3_Country_Code, 262 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Dominica' as COUNTRY, 'DM' as Alpha_2_Country_Code, 'DMA' as Alpha_3_Country_Code, 212 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Dominican Republic (the)' as COUNTRY, 'DO' as Alpha_2_Country_Code, 'DOM' as Alpha_3_Country_Code, 214 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Ecuador' as COUNTRY, 'EC' as Alpha_2_Country_Code, 'ECU' as Alpha_3_Country_Code, 218 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Egypt' as COUNTRY, 'EG' as Alpha_2_Country_Code, 'EGY' as Alpha_3_Country_Code, 818 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'El Salvador' as COUNTRY, 'SV' as Alpha_2_Country_Code, 'SLV' as Alpha_3_Country_Code, 222 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Equatorial Guinea' as COUNTRY, 'GQ' as Alpha_2_Country_Code, 'GNQ' as Alpha_3_Country_Code, 226 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Eritrea' as COUNTRY, 'ER' as Alpha_2_Country_Code, 'ERI' as Alpha_3_Country_Code, 232 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Estonia' as COUNTRY, 'EE' as Alpha_2_Country_Code, 'EST' as Alpha_3_Country_Code, 233 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Eswatini' as COUNTRY, 'SZ' as Alpha_2_Country_Code, 'SWZ' as Alpha_3_Country_Code, 748 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Ethiopia' as COUNTRY, 'ET' as Alpha_2_Country_Code, 'ETH' as Alpha_3_Country_Code, 231 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Falkland Islands (the) [Malvinas]' as COUNTRY, 'FK' as Alpha_2_Country_Code, 'FLK' as Alpha_3_Country_Code, 238 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Faroe Islands (the)' as COUNTRY, 'FO' as Alpha_2_Country_Code, 'FRO' as Alpha_3_Country_Code, 234 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Fiji' as COUNTRY, 'FJ' as Alpha_2_Country_Code, 'FJI' as Alpha_3_Country_Code, 242 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Finland' as COUNTRY, 'FI' as Alpha_2_Country_Code, 'FIN' as Alpha_3_Country_Code, 246 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'France' as COUNTRY, 'FR' as Alpha_2_Country_Code, 'FRA' as Alpha_3_Country_Code, 250 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'French Guiana' as COUNTRY, 'GF' as Alpha_2_Country_Code, 'GUF' as Alpha_3_Country_Code, 254 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'French Polynesia' as COUNTRY, 'PF' as Alpha_2_Country_Code, 'PYF' as Alpha_3_Country_Code, 258 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'French Southern Territories (the)' as COUNTRY, 'TF' as Alpha_2_Country_Code, 'ATF' as Alpha_3_Country_Code, 260 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Gabon' as COUNTRY, 'GA' as Alpha_2_Country_Code, 'GAB' as Alpha_3_Country_Code, 266 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Gambia (the)' as COUNTRY, 'GM' as Alpha_2_Country_Code, 'GMB' as Alpha_3_Country_Code, 270 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Georgia' as COUNTRY, 'GE' as Alpha_2_Country_Code, 'GEO' as Alpha_3_Country_Code, 268 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Germany' as COUNTRY, 'DE' as Alpha_2_Country_Code, 'DEU' as Alpha_3_Country_Code, 276 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Ghana' as COUNTRY, 'GH' as Alpha_2_Country_Code, 'GHA' as Alpha_3_Country_Code, 288 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Gibraltar' as COUNTRY, 'GI' as Alpha_2_Country_Code, 'GIB' as Alpha_3_Country_Code, 292 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Greece' as COUNTRY, 'GR' as Alpha_2_Country_Code, 'GRC' as Alpha_3_Country_Code, 300 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Greenland' as COUNTRY, 'GL' as Alpha_2_Country_Code, 'GRL' as Alpha_3_Country_Code, 304 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Grenada' as COUNTRY, 'GD' as Alpha_2_Country_Code, 'GRD' as Alpha_3_Country_Code, 308 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Guadeloupe' as COUNTRY, 'GP' as Alpha_2_Country_Code, 'GLP' as Alpha_3_Country_Code, 312 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Guam' as COUNTRY, 'GU' as Alpha_2_Country_Code, 'GUM' as Alpha_3_Country_Code, 316 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Guatemala' as COUNTRY, 'GT' as Alpha_2_Country_Code, 'GTM' as Alpha_3_Country_Code, 320 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Guernsey' as COUNTRY, 'GG' as Alpha_2_Country_Code, 'GGY' as Alpha_3_Country_Code, 831 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Guinea' as COUNTRY, 'GN' as Alpha_2_Country_Code, 'GIN' as Alpha_3_Country_Code, 324 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Guinea-Bissau' as COUNTRY, 'GW' as Alpha_2_Country_Code, 'GNB' as Alpha_3_Country_Code, 624 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Guyana' as COUNTRY, 'GY' as Alpha_2_Country_Code, 'GUY' as Alpha_3_Country_Code, 328 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Haiti' as COUNTRY, 'HT' as Alpha_2_Country_Code, 'HTI' as Alpha_3_Country_Code, 332 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Heard Island and McDonald Islands' as COUNTRY, 'HM' as Alpha_2_Country_Code, 'HMD' as Alpha_3_Country_Code, 334 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Holy See (the)' as COUNTRY, 'VA' as Alpha_2_Country_Code, 'VAT' as Alpha_3_Country_Code, 336 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Honduras' as COUNTRY, 'HN' as Alpha_2_Country_Code, 'HND' as Alpha_3_Country_Code, 340 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Hong Kong' as COUNTRY, 'HK' as Alpha_2_Country_Code, 'HKG' as Alpha_3_Country_Code, 344 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Hungary' as COUNTRY, 'HU' as Alpha_2_Country_Code, 'HUN' as Alpha_3_Country_Code, 348 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Iceland' as COUNTRY, 'IS' as Alpha_2_Country_Code, 'ISL' as Alpha_3_Country_Code, 352 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'India' as COUNTRY, 'IN' as Alpha_2_Country_Code, 'IND' as Alpha_3_Country_Code, 356 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Indonesia' as COUNTRY, 'ID' as Alpha_2_Country_Code, 'IDN' as Alpha_3_Country_Code, 360 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Iran (Islamic Republic of)' as COUNTRY, 'IR' as Alpha_2_Country_Code, 'IRN' as Alpha_3_Country_Code, 364 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Iraq' as COUNTRY, 'IQ' as Alpha_2_Country_Code, 'IRQ' as Alpha_3_Country_Code, 368 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Ireland' as COUNTRY, 'IE' as Alpha_2_Country_Code, 'IRL' as Alpha_3_Country_Code, 372 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Isle of Man' as COUNTRY, 'IM' as Alpha_2_Country_Code, 'IMN' as Alpha_3_Country_Code, 833 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Israel' as COUNTRY, 'IL' as Alpha_2_Country_Code, 'ISR' as Alpha_3_Country_Code, 376 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Italy' as COUNTRY, 'IT' as Alpha_2_Country_Code, 'ITA' as Alpha_3_Country_Code, 380 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Jamaica' as COUNTRY, 'JM' as Alpha_2_Country_Code, 'JAM' as Alpha_3_Country_Code, 388 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Japan' as COUNTRY, 'JP' as Alpha_2_Country_Code, 'JPN' as Alpha_3_Country_Code, 392 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Jersey' as COUNTRY, 'JE' as Alpha_2_Country_Code, 'JEY' as Alpha_3_Country_Code, 832 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Jordan' as COUNTRY, 'JO' as Alpha_2_Country_Code, 'JOR' as Alpha_3_Country_Code, 400 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Kazakhstan' as COUNTRY, 'KZ' as Alpha_2_Country_Code, 'KAZ' as Alpha_3_Country_Code, 398 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Kenya' as COUNTRY, 'KE' as Alpha_2_Country_Code, 'KEN' as Alpha_3_Country_Code, 404 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Kiribati' as COUNTRY, 'KI' as Alpha_2_Country_Code, 'KIR' as Alpha_3_Country_Code, 296 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Korea (the Democratic People''s Republic of)' as COUNTRY, 'KP' as Alpha_2_Country_Code, 'PRK' as Alpha_3_Country_Code, 408 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Korea (the Republic of)' as COUNTRY, 'KR' as Alpha_2_Country_Code, 'KOR' as Alpha_3_Country_Code, 410 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Kuwait' as COUNTRY, 'KW' as Alpha_2_Country_Code, 'KWT' as Alpha_3_Country_Code, 414 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Kyrgyzstan' as COUNTRY, 'KG' as Alpha_2_Country_Code, 'KGZ' as Alpha_3_Country_Code, 417 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Lao People''s Democratic Republic (the)' as COUNTRY, 'LA' as Alpha_2_Country_Code, 'LAO' as Alpha_3_Country_Code, 418 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Latvia' as COUNTRY, 'LV' as Alpha_2_Country_Code, 'LVA' as Alpha_3_Country_Code, 428 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Lebanon' as COUNTRY, 'LB' as Alpha_2_Country_Code, 'LBN' as Alpha_3_Country_Code, 422 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Lesotho' as COUNTRY, 'LS' as Alpha_2_Country_Code, 'LSO' as Alpha_3_Country_Code, 426 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Liberia' as COUNTRY, 'LR' as Alpha_2_Country_Code, 'LBR' as Alpha_3_Country_Code, 430 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Libya' as COUNTRY, 'LY' as Alpha_2_Country_Code, 'LBY' as Alpha_3_Country_Code, 434 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Liechtenstein' as COUNTRY, 'LI' as Alpha_2_Country_Code, 'LIE' as Alpha_3_Country_Code, 438 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Lithuania' as COUNTRY, 'LT' as Alpha_2_Country_Code, 'LTU' as Alpha_3_Country_Code, 440 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Luxembourg' as COUNTRY, 'LU' as Alpha_2_Country_Code, 'LUX' as Alpha_3_Country_Code, 442 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Macao' as COUNTRY, 'MO' as Alpha_2_Country_Code, 'MAC' as Alpha_3_Country_Code, 446 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Madagascar' as COUNTRY, 'MG' as Alpha_2_Country_Code, 'MDG' as Alpha_3_Country_Code, 450 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Malawi' as COUNTRY, 'MW' as Alpha_2_Country_Code, 'MWI' as Alpha_3_Country_Code, 454 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Malaysia' as COUNTRY, 'MY' as Alpha_2_Country_Code, 'MYS' as Alpha_3_Country_Code, 458 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Maldives' as COUNTRY, 'MV' as Alpha_2_Country_Code, 'MDV' as Alpha_3_Country_Code, 462 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Mali' as COUNTRY, 'ML' as Alpha_2_Country_Code, 'MLI' as Alpha_3_Country_Code, 466 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Malta' as COUNTRY, 'MT' as Alpha_2_Country_Code, 'MLT' as Alpha_3_Country_Code, 470 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Marshall Islands (the)' as COUNTRY, 'MH' as Alpha_2_Country_Code, 'MHL' as Alpha_3_Country_Code, 584 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Martinique' as COUNTRY, 'MQ' as Alpha_2_Country_Code, 'MTQ' as Alpha_3_Country_Code, 474 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Mauritania' as COUNTRY, 'MR' as Alpha_2_Country_Code, 'MRT' as Alpha_3_Country_Code, 478 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Mauritius' as COUNTRY, 'MU' as Alpha_2_Country_Code, 'MUS' as Alpha_3_Country_Code, 480 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Mayotte' as COUNTRY, 'YT' as Alpha_2_Country_Code, 'MYT' as Alpha_3_Country_Code, 175 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Mexico' as COUNTRY, 'MX' as Alpha_2_Country_Code, 'MEX' as Alpha_3_Country_Code, 484 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Micronesia (Federated States of)' as COUNTRY, 'FM' as Alpha_2_Country_Code, 'FSM' as Alpha_3_Country_Code, 583 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Moldova (the Republic of)' as COUNTRY, 'MD' as Alpha_2_Country_Code, 'MDA' as Alpha_3_Country_Code, 498 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Monaco' as COUNTRY, 'MC' as Alpha_2_Country_Code, 'MCO' as Alpha_3_Country_Code, 492 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Mongolia' as COUNTRY, 'MN' as Alpha_2_Country_Code, 'MNG' as Alpha_3_Country_Code, 496 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Montenegro' as COUNTRY, 'ME' as Alpha_2_Country_Code, 'MNE' as Alpha_3_Country_Code, 499 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Montserrat' as COUNTRY, 'MS' as Alpha_2_Country_Code, 'MSR' as Alpha_3_Country_Code, 500 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Morocco' as COUNTRY, 'MA' as Alpha_2_Country_Code, 'MAR' as Alpha_3_Country_Code, 504 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Mozambique' as COUNTRY, 'MZ' as Alpha_2_Country_Code, 'MOZ' as Alpha_3_Country_Code, 508 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Myanmar' as COUNTRY, 'MM' as Alpha_2_Country_Code, 'MMR' as Alpha_3_Country_Code, 104 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Namibia' as COUNTRY, 'NA' as Alpha_2_Country_Code, 'NAM' as Alpha_3_Country_Code, 516 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Nauru' as COUNTRY, 'NR' as Alpha_2_Country_Code, 'NRU' as Alpha_3_Country_Code, 520 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Nepal' as COUNTRY, 'NP' as Alpha_2_Country_Code, 'NPL' as Alpha_3_Country_Code, 524 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Netherlands (the)' as COUNTRY, 'NL' as Alpha_2_Country_Code, 'NLD' as Alpha_3_Country_Code, 528 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'New Caledonia' as COUNTRY, 'NC' as Alpha_2_Country_Code, 'NCL' as Alpha_3_Country_Code, 540 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'New Zealand' as COUNTRY, 'NZ' as Alpha_2_Country_Code, 'NZL' as Alpha_3_Country_Code, 554 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Nicaragua' as COUNTRY, 'NI' as Alpha_2_Country_Code, 'NIC' as Alpha_3_Country_Code, 558 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Niger (the)' as COUNTRY, 'NE' as Alpha_2_Country_Code, 'NER' as Alpha_3_Country_Code, 562 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Nigeria' as COUNTRY, 'NG' as Alpha_2_Country_Code, 'NGA' as Alpha_3_Country_Code, 566 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Niue' as COUNTRY, 'NU' as Alpha_2_Country_Code, 'NIU' as Alpha_3_Country_Code, 570 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Norfolk Island' as COUNTRY, 'NF' as Alpha_2_Country_Code, 'NFK' as Alpha_3_Country_Code, 574 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Northern Mariana Islands (the)' as COUNTRY, 'MP' as Alpha_2_Country_Code, 'MNP' as Alpha_3_Country_Code, 580 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Norway' as COUNTRY, 'NO' as Alpha_2_Country_Code, 'NOR' as Alpha_3_Country_Code, 578 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Oman' as COUNTRY, 'OM' as Alpha_2_Country_Code, 'OMN' as Alpha_3_Country_Code, 512 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Pakistan' as COUNTRY, 'PK' as Alpha_2_Country_Code, 'PAK' as Alpha_3_Country_Code, 586 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Palau' as COUNTRY, 'PW' as Alpha_2_Country_Code, 'PLW' as Alpha_3_Country_Code, 585 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Palestine, State of' as COUNTRY, 'PS' as Alpha_2_Country_Code, 'PSE' as Alpha_3_Country_Code, 275 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Panama' as COUNTRY, 'PA' as Alpha_2_Country_Code, 'PAN' as Alpha_3_Country_Code, 591 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Papua New Guinea' as COUNTRY, 'PG' as Alpha_2_Country_Code, 'PNG' as Alpha_3_Country_Code, 598 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Paraguay' as COUNTRY, 'PY' as Alpha_2_Country_Code, 'PRY' as Alpha_3_Country_Code, 600 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Peru' as COUNTRY, 'PE' as Alpha_2_Country_Code, 'PER' as Alpha_3_Country_Code, 604 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Philippines (the)' as COUNTRY, 'PH' as Alpha_2_Country_Code, 'PHL' as Alpha_3_Country_Code, 608 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Pitcairn' as COUNTRY, 'PN' as Alpha_2_Country_Code, 'PCN' as Alpha_3_Country_Code, 612 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Poland' as COUNTRY, 'PL' as Alpha_2_Country_Code, 'POL' as Alpha_3_Country_Code, 616 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Portugal' as COUNTRY, 'PT' as Alpha_2_Country_Code, 'PRT' as Alpha_3_Country_Code, 620 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Puerto Rico' as COUNTRY, 'PR' as Alpha_2_Country_Code, 'PRI' as Alpha_3_Country_Code, 630 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Qatar' as COUNTRY, 'QA' as Alpha_2_Country_Code, 'QAT' as Alpha_3_Country_Code, 634 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Republic of North Macedonia' as COUNTRY, 'MK' as Alpha_2_Country_Code, 'MKD' as Alpha_3_Country_Code, 807 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Romania' as COUNTRY, 'RO' as Alpha_2_Country_Code, 'ROU' as Alpha_3_Country_Code, 642 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Russian Federation (the)' as COUNTRY, 'RU' as Alpha_2_Country_Code, 'RUS' as Alpha_3_Country_Code, 643 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Rwanda' as COUNTRY, 'RW' as Alpha_2_Country_Code, 'RWA' as Alpha_3_Country_Code, 646 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Réunion' as COUNTRY, 'RE' as Alpha_2_Country_Code, 'REU' as Alpha_3_Country_Code, 638 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saint Barthélemy' as COUNTRY, 'BL' as Alpha_2_Country_Code, 'BLM' as Alpha_3_Country_Code, 652 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saint Helena, Ascension and Tristan da Cunha' as COUNTRY, 'SH' as Alpha_2_Country_Code, 'SHN' as Alpha_3_Country_Code, 654 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saint Kitts and Nevis' as COUNTRY, 'KN' as Alpha_2_Country_Code, 'KNA' as Alpha_3_Country_Code, 659 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saint Lucia' as COUNTRY, 'LC' as Alpha_2_Country_Code, 'LCA' as Alpha_3_Country_Code, 662 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saint Martin (French part)' as COUNTRY, 'MF' as Alpha_2_Country_Code, 'MAF' as Alpha_3_Country_Code, 663 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saint Pierre and Miquelon' as COUNTRY, 'PM' as Alpha_2_Country_Code, 'SPM' as Alpha_3_Country_Code, 666 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saint Vincent and the Grenadines' as COUNTRY, 'VC' as Alpha_2_Country_Code, 'VCT' as Alpha_3_Country_Code, 670 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Samoa' as COUNTRY, 'WS' as Alpha_2_Country_Code, 'WSM' as Alpha_3_Country_Code, 882 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'San Marino' as COUNTRY, 'SM' as Alpha_2_Country_Code, 'SMR' as Alpha_3_Country_Code, 674 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Sao Tome and Principe' as COUNTRY, 'ST' as Alpha_2_Country_Code, 'STP' as Alpha_3_Country_Code, 678 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Saudi Arabia' as COUNTRY, 'SA' as Alpha_2_Country_Code, 'SAU' as Alpha_3_Country_Code, 682 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Senegal' as COUNTRY, 'SN' as Alpha_2_Country_Code, 'SEN' as Alpha_3_Country_Code, 686 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Serbia' as COUNTRY, 'RS' as Alpha_2_Country_Code, 'SRB' as Alpha_3_Country_Code, 688 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Seychelles' as COUNTRY, 'SC' as Alpha_2_Country_Code, 'SYC' as Alpha_3_Country_Code, 690 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Sierra Leone' as COUNTRY, 'SL' as Alpha_2_Country_Code, 'SLE' as Alpha_3_Country_Code, 694 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Singapore' as COUNTRY, 'SG' as Alpha_2_Country_Code, 'SGP' as Alpha_3_Country_Code, 702 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Sint Maarten (Dutch part)' as COUNTRY, 'SX' as Alpha_2_Country_Code, 'SXM' as Alpha_3_Country_Code, 534 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Slovakia' as COUNTRY, 'SK' as Alpha_2_Country_Code, 'SVK' as Alpha_3_Country_Code, 703 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Slovenia' as COUNTRY, 'SI' as Alpha_2_Country_Code, 'SVN' as Alpha_3_Country_Code, 705 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Solomon Islands' as COUNTRY, 'SB' as Alpha_2_Country_Code, 'SLB' as Alpha_3_Country_Code, 90 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Somalia' as COUNTRY, 'SO' as Alpha_2_Country_Code, 'SOM' as Alpha_3_Country_Code, 706 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'South Africa' as COUNTRY, 'ZA' as Alpha_2_Country_Code, 'ZAF' as Alpha_3_Country_Code, 710 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'South Georgia and the South Sandwich Islands' as COUNTRY, 'GS' as Alpha_2_Country_Code, 'SGS' as Alpha_3_Country_Code, 239 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'South Sudan' as COUNTRY, 'SS' as Alpha_2_Country_Code, 'SSD' as Alpha_3_Country_Code, 728 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Spain' as COUNTRY, 'ES' as Alpha_2_Country_Code, 'ESP' as Alpha_3_Country_Code, 724 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Sri Lanka' as COUNTRY, 'LK' as Alpha_2_Country_Code, 'LKA' as Alpha_3_Country_Code, 144 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Sudan (the)' as COUNTRY, 'SD' as Alpha_2_Country_Code, 'SDN' as Alpha_3_Country_Code, 729 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Suriname' as COUNTRY, 'SR' as Alpha_2_Country_Code, 'SUR' as Alpha_3_Country_Code, 740 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Svalbard and Jan Mayen' as COUNTRY, 'SJ' as Alpha_2_Country_Code, 'SJM' as Alpha_3_Country_Code, 744 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Sweden' as COUNTRY, 'SE' as Alpha_2_Country_Code, 'SWE' as Alpha_3_Country_Code, 752 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Switzerland' as COUNTRY, 'CH' as Alpha_2_Country_Code, 'CHE' as Alpha_3_Country_Code, 756 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Syrian Arab Republic' as COUNTRY, 'SY' as Alpha_2_Country_Code, 'SYR' as Alpha_3_Country_Code, 760 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Taiwan (Province of China)' as COUNTRY, 'TW' as Alpha_2_Country_Code, 'TWN' as Alpha_3_Country_Code, 158 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Tajikistan' as COUNTRY, 'TJ' as Alpha_2_Country_Code, 'TJK' as Alpha_3_Country_Code, 762 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Tanzania, United Republic of' as COUNTRY, 'TZ' as Alpha_2_Country_Code, 'TZA' as Alpha_3_Country_Code, 834 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Thailand' as COUNTRY, 'TH' as Alpha_2_Country_Code, 'THA' as Alpha_3_Country_Code, 764 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Timor-Leste' as COUNTRY, 'TL' as Alpha_2_Country_Code, 'TLS' as Alpha_3_Country_Code, 626 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Togo' as COUNTRY, 'TG' as Alpha_2_Country_Code, 'TGO' as Alpha_3_Country_Code, 768 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Tokelau' as COUNTRY, 'TK' as Alpha_2_Country_Code, 'TKL' as Alpha_3_Country_Code, 772 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Tonga' as COUNTRY, 'TO' as Alpha_2_Country_Code, 'TON' as Alpha_3_Country_Code, 776 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Trinidad and Tobago' as COUNTRY, 'TT' as Alpha_2_Country_Code, 'TTO' as Alpha_3_Country_Code, 780 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Tunisia' as COUNTRY, 'TN' as Alpha_2_Country_Code, 'TUN' as Alpha_3_Country_Code, 788 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Turkey' as COUNTRY, 'TR' as Alpha_2_Country_Code, 'TUR' as Alpha_3_Country_Code, 792 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Turkmenistan' as COUNTRY, 'TM' as Alpha_2_Country_Code, 'TKM' as Alpha_3_Country_Code, 795 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Turks and Caicos Islands (the)' as COUNTRY, 'TC' as Alpha_2_Country_Code, 'TCA' as Alpha_3_Country_Code, 796 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Tuvalu' as COUNTRY, 'TV' as Alpha_2_Country_Code, 'TUV' as Alpha_3_Country_Code, 798 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Uganda' as COUNTRY, 'UG' as Alpha_2_Country_Code, 'UGA' as Alpha_3_Country_Code, 800 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Ukraine' as COUNTRY, 'UA' as Alpha_2_Country_Code, 'UKR' as Alpha_3_Country_Code, 804 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'United Arab Emirates (the)' as COUNTRY, 'AE' as Alpha_2_Country_Code, 'ARE' as Alpha_3_Country_Code, 784 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'United Kingdom of Great Britain and Northern Ireland (the)' as COUNTRY, 'GB' as Alpha_2_Country_Code, 'GBR' as Alpha_3_Country_Code, 826 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'United States Minor Outlying Islands (the)' as COUNTRY, 'UM' as Alpha_2_Country_Code, 'UMI' as Alpha_3_Country_Code, 581 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'United States of America (the)' as COUNTRY, 'US' as Alpha_2_Country_Code, 'USA' as Alpha_3_Country_Code, 840 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Uruguay' as COUNTRY, 'UY' as Alpha_2_Country_Code, 'URY' as Alpha_3_Country_Code, 858 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Uzbekistan' as COUNTRY, 'UZ' as Alpha_2_Country_Code, 'UZB' as Alpha_3_Country_Code, 860 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Vanuatu' as COUNTRY, 'VU' as Alpha_2_Country_Code, 'VUT' as Alpha_3_Country_Code, 548 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Venezuela (Bolivarian Republic of)' as COUNTRY, 'VE' as Alpha_2_Country_Code, 'VEN' as Alpha_3_Country_Code, 862 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Viet Nam' as COUNTRY, 'VN' as Alpha_2_Country_Code, 'VNM' as Alpha_3_Country_Code, 704 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Virgin Islands (British)' as COUNTRY, 'VG' as Alpha_2_Country_Code, 'VGB' as Alpha_3_Country_Code, 92 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Virgin Islands (U.S.)' as COUNTRY, 'VI' as Alpha_2_Country_Code, 'VIR' as Alpha_3_Country_Code, 850 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Wallis and Futuna' as COUNTRY, 'WF' as Alpha_2_Country_Code, 'WLF' as Alpha_3_Country_Code, 876 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Western Sahara' as COUNTRY, 'EH' as Alpha_2_Country_Code, 'ESH' as Alpha_3_Country_Code, 732 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Yemen' as COUNTRY, 'YE' as Alpha_2_Country_Code, 'YEM' as Alpha_3_Country_Code, 887 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Zambia' as COUNTRY, 'ZM' as Alpha_2_Country_Code, 'ZMB' as Alpha_3_Country_Code, 894 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Zimbabwe' as COUNTRY, 'ZW' as Alpha_2_Country_Code, 'ZWE' as Alpha_3_Country_Code, 716 as Numeric_Country_Code FROM DUAL UNION
    SELECT 'Åland Islands' as COUNTRY, 'AX' as Alpha_2_Country_Code, 'ALA' as Alpha_3_Country_Code, 248 as Numeric_Country_Code FROM DUAL
    ;  
BEGIN
    FOR JJ IN C1 LOOP
      FOR II IN 1..500000 LOOP
          INSERT INTO saimk.trashbigdata VALUES
          (II, 'TEXT'||MOD(II,10), JJ.COUNTRY, JJ.Alpha_2_Country_Code, JJ.Alpha_3_Country_Code, JJ.Numeric_Country_Code,
          MOD(II,5)+1, MOD(II,10)+1, MOD(II,100)+1, MOD(II,1000)+1, MOD(II,10000)+1, NULL
          )
          ;
          
          IF MOD(II,100000) = 0 THEN
            COMMIT;
          END IF;  
     END LOOP;
     COMMIT;
   END LOOP;
   COMMIT;
END;   