/// Global education data constants for the questionnaire
library;

/// Grading systems available worldwide
enum GradingSystem {
  american('American GPA (0.0-4.0)', '4.0'),
  american100('American Percentage (0-100)', '100'),
  ib('IB (International Baccalaureate)', '45'),
  aLevel('A-Level (UK)', 'A*'),
  french('French (0-20)', '20'),
  german('German (1.0-6.0)', '1.0'),
  indian('Indian CBSE (0-100)', '100'),
  canadian('Canadian (0-100)', '100'),
  australian('Australian ATAR (0-99.95)', '99.95'),
  other('Other', 'N/A');

  final String displayName;
  final String maxScore;
  const GradingSystem(this.displayName, this.maxScore);
}

/// World countries with their regions/states/provinces
class Country {
  final String code;
  final String name;
  final List<String> regions;

  const Country(this.code, this.name, this.regions);
}

/// All world countries in alphabetical order with regions for major countries
const List<Country> worldCountries = [
  Country('AF', 'Afghanistan', []),
  Country('AL', 'Albania', []),
  Country('DZ', 'Algeria', []),
  Country('AD', 'Andorra', []),
  Country('AO', 'Angola', []),
  Country('AG', 'Antigua and Barbuda', []),
  Country('AR', 'Argentina', argentinianProvinces),
  Country('AM', 'Armenia', []),
  Country('AU', 'Australia', australianStates),
  Country('AT', 'Austria', austrianStates),
  Country('AZ', 'Azerbaijan', []),
  Country('BS', 'Bahamas', []),
  Country('BH', 'Bahrain', []),
  Country('BD', 'Bangladesh', []),
  Country('BB', 'Barbados', []),
  Country('BY', 'Belarus', []),
  Country('BE', 'Belgium', belgianRegions),
  Country('BZ', 'Belize', []),
  Country('BJ', 'Benin', []),
  Country('BT', 'Bhutan', []),
  Country('BO', 'Bolivia', []),
  Country('BA', 'Bosnia and Herzegovina', []),
  Country('BW', 'Botswana', []),
  Country('BR', 'Brazil', brazilianStates),
  Country('BN', 'Brunei', []),
  Country('BG', 'Bulgaria', []),
  Country('BF', 'Burkina Faso', []),
  Country('BI', 'Burundi', []),
  Country('KH', 'Cambodia', []),
  Country('CM', 'Cameroon', []),
  Country('CA', 'Canada', canadianProvinces),
  Country('CV', 'Cape Verde', []),
  Country('CF', 'Central African Republic', []),
  Country('TD', 'Chad', []),
  Country('CL', 'Chile', chileanRegions),
  Country('CN', 'China', chineseProvinces),
  Country('CO', 'Colombia', colombianDepartments),
  Country('KM', 'Comoros', []),
  Country('CG', 'Congo', []),
  Country('CR', 'Costa Rica', []),
  Country('HR', 'Croatia', []),
  Country('CU', 'Cuba', []),
  Country('CY', 'Cyprus', []),
  Country('CZ', 'Czech Republic', czechRegions),
  Country('CD', 'Democratic Republic of the Congo', []),
  Country('DK', 'Denmark', danishRegions),
  Country('DJ', 'Djibouti', []),
  Country('DM', 'Dominica', []),
  Country('DO', 'Dominican Republic', []),
  Country('EC', 'Ecuador', []),
  Country('EG', 'Egypt', egyptianGovernorates),
  Country('SV', 'El Salvador', []),
  Country('GQ', 'Equatorial Guinea', []),
  Country('ER', 'Eritrea', []),
  Country('EE', 'Estonia', []),
  Country('ET', 'Ethiopia', []),
  Country('FJ', 'Fiji', []),
  Country('FI', 'Finland', finnishRegions),
  Country('FR', 'France', frenchRegions),
  Country('GA', 'Gabon', []),
  Country('GM', 'Gambia', []),
  Country('GE', 'Georgia', []),
  Country('DE', 'Germany', germanStates),
  Country('GH', 'Ghana', []),
  Country('GR', 'Greece', []),
  Country('GD', 'Grenada', []),
  Country('GT', 'Guatemala', []),
  Country('GN', 'Guinea', []),
  Country('GW', 'Guinea-Bissau', []),
  Country('GY', 'Guyana', []),
  Country('HT', 'Haiti', []),
  Country('HN', 'Honduras', []),
  Country('HU', 'Hungary', []),
  Country('IS', 'Iceland', []),
  Country('IN', 'India', indianStates),
  Country('ID', 'Indonesia', indonesianProvinces),
  Country('IR', 'Iran', []),
  Country('IQ', 'Iraq', []),
  Country('IE', 'Ireland', irishProvinces),
  Country('IL', 'Israel', israeliDistricts),
  Country('IT', 'Italy', italianRegions),
  Country('CI', 'Ivory Coast', []),
  Country('JM', 'Jamaica', []),
  Country('JP', 'Japan', japanesePrefectures),
  Country('JO', 'Jordan', []),
  Country('KZ', 'Kazakhstan', []),
  Country('KE', 'Kenya', kenyanCounties),
  Country('KI', 'Kiribati', []),
  Country('KW', 'Kuwait', []),
  Country('KG', 'Kyrgyzstan', []),
  Country('LA', 'Laos', []),
  Country('LV', 'Latvia', []),
  Country('LB', 'Lebanon', []),
  Country('LS', 'Lesotho', []),
  Country('LR', 'Liberia', []),
  Country('LY', 'Libya', []),
  Country('LI', 'Liechtenstein', []),
  Country('LT', 'Lithuania', []),
  Country('LU', 'Luxembourg', []),
  Country('MK', 'Macedonia', []),
  Country('MG', 'Madagascar', []),
  Country('MW', 'Malawi', []),
  Country('MY', 'Malaysia', malaysianStates),
  Country('MV', 'Maldives', []),
  Country('ML', 'Mali', []),
  Country('MT', 'Malta', []),
  Country('MH', 'Marshall Islands', []),
  Country('MR', 'Mauritania', []),
  Country('MU', 'Mauritius', []),
  Country('MX', 'Mexico', mexicanStates),
  Country('FM', 'Micronesia', []),
  Country('MD', 'Moldova', []),
  Country('MC', 'Monaco', []),
  Country('MN', 'Mongolia', []),
  Country('ME', 'Montenegro', []),
  Country('MA', 'Morocco', moroccanRegions),
  Country('MZ', 'Mozambique', []),
  Country('MM', 'Myanmar', []),
  Country('NA', 'Namibia', []),
  Country('NR', 'Nauru', []),
  Country('NP', 'Nepal', []),
  Country('NL', 'Netherlands', dutchProvinces),
  Country('NZ', 'New Zealand', nzRegions),
  Country('NI', 'Nicaragua', []),
  Country('NE', 'Niger', []),
  Country('NG', 'Nigeria', nigerianStates),
  Country('KP', 'North Korea', []),
  Country('NO', 'Norway', norwegianRegions),
  Country('OM', 'Oman', []),
  Country('PK', 'Pakistan', []),
  Country('PW', 'Palau', []),
  Country('PA', 'Panama', []),
  Country('PG', 'Papua New Guinea', []),
  Country('PY', 'Paraguay', []),
  Country('PE', 'Peru', peruvianRegions),
  Country('PH', 'Philippines', philippineRegions),
  Country('PL', 'Poland', polishVoivodeships),
  Country('PT', 'Portugal', portugueseRegions),
  Country('QA', 'Qatar', []),
  Country('RO', 'Romania', []),
  Country('RU', 'Russia', []),
  Country('RW', 'Rwanda', []),
  Country('KN', 'Saint Kitts and Nevis', []),
  Country('LC', 'Saint Lucia', []),
  Country('VC', 'Saint Vincent and the Grenadines', []),
  Country('WS', 'Samoa', []),
  Country('SM', 'San Marino', []),
  Country('ST', 'Sao Tome and Principe', []),
  Country('SA', 'Saudi Arabia', saudiRegions),
  Country('SN', 'Senegal', []),
  Country('RS', 'Serbia', []),
  Country('SC', 'Seychelles', []),
  Country('SL', 'Sierra Leone', []),
  Country('SG', 'Singapore', singaporeRegions),
  Country('SK', 'Slovakia', []),
  Country('SI', 'Slovenia', []),
  Country('SB', 'Solomon Islands', []),
  Country('SO', 'Somalia', []),
  Country('ZA', 'South Africa', southAfricanProvinces),
  Country('KR', 'South Korea', koreanProvinces),
  Country('SS', 'South Sudan', []),
  Country('ES', 'Spain', spanishRegions),
  Country('LK', 'Sri Lanka', []),
  Country('SD', 'Sudan', []),
  Country('SR', 'Suriname', []),
  Country('SZ', 'Swaziland', []),
  Country('SE', 'Sweden', swedishRegions),
  Country('CH', 'Switzerland', swissCantons),
  Country('SY', 'Syria', []),
  Country('TW', 'Taiwan', []),
  Country('TJ', 'Tajikistan', []),
  Country('TZ', 'Tanzania', []),
  Country('TH', 'Thailand', thaiProvinces),
  Country('TL', 'Timor-Leste', []),
  Country('TG', 'Togo', []),
  Country('TO', 'Tonga', []),
  Country('TT', 'Trinidad and Tobago', []),
  Country('TN', 'Tunisia', []),
  Country('TR', 'Turkey', turkishProvinces),
  Country('TM', 'Turkmenistan', []),
  Country('TV', 'Tuvalu', []),
  Country('UG', 'Uganda', []),
  Country('UA', 'Ukraine', []),
  Country('AE', 'United Arab Emirates', uaeEmirates),
  Country('GB', 'United Kingdom', ukRegions),
  Country('US', 'United States', usStates),
  Country('UY', 'Uruguay', []),
  Country('UZ', 'Uzbekistan', []),
  Country('VU', 'Vanuatu', []),
  Country('VA', 'Vatican City', []),
  Country('VE', 'Venezuela', venezuelanStates),
  Country('VN', 'Vietnam', vietnameseProvinces),
  Country('YE', 'Yemen', []),
  Country('ZM', 'Zambia', []),
  Country('ZW', 'Zimbabwe', []),
];

// US States
const List<String> usStates = [
  'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
  'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
  'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
  'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
  'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
  'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
  'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon',
  'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
  'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
  'West Virginia', 'Wisconsin', 'Wyoming', 'Washington D.C.',
];

// Canadian Provinces
const List<String> canadianProvinces = [
  'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick',
  'Newfoundland and Labrador', 'Northwest Territories', 'Nova Scotia',
  'Nunavut', 'Ontario', 'Prince Edward Island', 'Quebec', 'Saskatchewan',
  'Yukon',
];

// UK Regions
const List<String> ukRegions = [
  'England', 'Scotland', 'Wales', 'Northern Ireland',
  'Greater London', 'South East', 'North West', 'East of England',
  'West Midlands', 'South West', 'Yorkshire', 'East Midlands',
  'North East',
];

// French Regions
const List<String> frenchRegions = [
  'Île-de-France', 'Provence-Alpes-Côte d\'Azur', 'Auvergne-Rhône-Alpes',
  'Nouvelle-Aquitaine', 'Occitanie', 'Hauts-de-France', 'Brittany',
  'Normandy', 'Pays de la Loire', 'Centre-Val de Loire', 'Grand Est',
  'Bourgogne-Franche-Comté', 'Corsica',
];

// German States
const List<String> germanStates = [
  'Baden-Württemberg', 'Bavaria', 'Berlin', 'Brandenburg', 'Bremen',
  'Hamburg', 'Hesse', 'Lower Saxony', 'Mecklenburg-Vorpommern',
  'North Rhine-Westphalia', 'Rhineland-Palatinate', 'Saarland',
  'Saxony', 'Saxony-Anhalt', 'Schleswig-Holstein', 'Thuringia',
];

// Australian States
const List<String> australianStates = [
  'New South Wales', 'Victoria', 'Queensland', 'Western Australia',
  'South Australia', 'Tasmania', 'Australian Capital Territory',
  'Northern Territory',
];

// Indian States (major ones)
const List<String> indianStates = [
  'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
  'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
  'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
  'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan',
  'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh',
  'Uttarakhand', 'West Bengal', 'Delhi', 'Jammu and Kashmir', 'Ladakh',
];

// Chinese Provinces (major ones)
const List<String> chineseProvinces = [
  'Beijing', 'Shanghai', 'Guangdong', 'Zhejiang', 'Jiangsu', 'Shandong',
  'Sichuan', 'Henan', 'Hubei', 'Hebei', 'Hunan', 'Anhui', 'Fujian',
  'Shaanxi', 'Liaoning', 'Jilin', 'Heilongjiang', 'Yunnan', 'Guangxi',
  'Jiangxi', 'Guizhou', 'Shanxi', 'Tianjin', 'Chongqing', 'Gansu',
  'Inner Mongolia', 'Ningxia', 'Qinghai', 'Xinjiang', 'Tibet',
  'Hong Kong', 'Macau',
];

// Japanese Prefectures (major ones)
const List<String> japanesePrefectures = [
  'Tokyo', 'Osaka', 'Kyoto', 'Hokkaido', 'Fukuoka', 'Kanagawa',
  'Aichi', 'Saitama', 'Chiba', 'Hyōgo', 'Hiroshima', 'Shizuoka',
];

// Simplified regions for other countries
const List<String> mexicanStates = ['Mexico City', 'Jalisco', 'Nuevo León', 'Puebla', 'Guanajuato', 'Other'];
const List<String> spanishRegions = ['Madrid', 'Catalonia', 'Andalusia', 'Valencia', 'Basque Country', 'Other'];
const List<String> italianRegions = ['Lazio (Rome)', 'Lombardy (Milan)', 'Tuscany', 'Veneto', 'Emilia-Romagna', 'Other'];
const List<String> dutchProvinces = ['North Holland', 'South Holland', 'Utrecht', 'North Brabant', 'Other'];
const List<String> belgianRegions = ['Brussels', 'Flanders', 'Wallonia'];
const List<String> swissCantons = ['Zürich', 'Geneva', 'Bern', 'Vaud', 'Basel', 'Other'];
const List<String> austrianStates = ['Vienna', 'Lower Austria', 'Upper Austria', 'Styria', 'Tyrol', 'Other'];
const List<String> swedishRegions = ['Stockholm', 'Västra Götaland', 'Skåne', 'Other'];
const List<String> norwegianRegions = ['Oslo', 'Viken', 'Vestland', 'Trøndelag', 'Other'];
const List<String> danishRegions = ['Capital Region', 'Zealand', 'Southern Denmark', 'Central Denmark', 'North Denmark'];
const List<String> finnishRegions = ['Uusimaa', 'Pirkanmaa', 'Southwest Finland', 'Other'];
const List<String> irishProvinces = ['Leinster', 'Munster', 'Connacht', 'Ulster'];
const List<String> portugueseRegions = ['Lisbon', 'Porto', 'Braga', 'Coimbra', 'Other'];
const List<String> polishVoivodeships = ['Mazovia (Warsaw)', 'Lesser Poland (Kraków)', 'Greater Poland', 'Silesia', 'Other'];
const List<String> czechRegions = ['Prague', 'Central Bohemia', 'South Moravia', 'Moravian-Silesian', 'Other'];
const List<String> koreanProvinces = ['Seoul', 'Busan', 'Incheon', 'Daegu', 'Gyeonggi', 'Other'];
const List<String> singaporeRegions = ['Central', 'East', 'North', 'North-East', 'West'];
const List<String> malaysianStates = ['Kuala Lumpur', 'Selangor', 'Johor', 'Penang', 'Perak', 'Other'];
const List<String> thaiProvinces = ['Bangkok', 'Chiang Mai', 'Phuket', 'Chonburi', 'Other'];
const List<String> vietnameseProvinces = ['Hanoi', 'Ho Chi Minh City', 'Da Nang', 'Hai Phong', 'Other'];
const List<String> indonesianProvinces = ['Jakarta', 'West Java', 'East Java', 'Bali', 'Other'];
const List<String> philippineRegions = ['Metro Manila', 'Calabarzon', 'Central Luzon', 'Cebu', 'Davao', 'Other'];
const List<String> uaeEmirates = ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman', 'Ras Al Khaimah', 'Fujairah', 'Umm Al Quwain'];
const List<String> saudiRegions = ['Riyadh', 'Makkah', 'Eastern Province', 'Madinah', 'Other'];
const List<String> israeliDistricts = ['Jerusalem', 'Tel Aviv', 'Haifa', 'Central', 'Southern', 'Northern'];
const List<String> turkishProvinces = ['Istanbul', 'Ankara', 'Izmir', 'Bursa', 'Antalya', 'Other'];
const List<String> nzRegions = ['Auckland', 'Wellington', 'Canterbury', 'Waikato', 'Bay of Plenty', 'Other'];
const List<String> brazilianStates = ['São Paulo', 'Rio de Janeiro', 'Minas Gerais', 'Bahia', 'Paraná', 'Other'];
const List<String> argentinianProvinces = ['Buenos Aires', 'Córdoba', 'Santa Fe', 'Mendoza', 'Other'];
const List<String> chileanRegions = ['Santiago Metropolitan', 'Valparaíso', 'Biobío', 'Maule', 'Other'];
const List<String> colombianDepartments = ['Bogotá', 'Antioquia', 'Valle del Cauca', 'Atlántico', 'Other'];
const List<String> peruvianRegions = ['Lima', 'Arequipa', 'Cusco', 'La Libertad', 'Other'];
const List<String> venezuelanStates = ['Capital District', 'Miranda', 'Zulia', 'Carabobo', 'Other'];
const List<String> southAfricanProvinces = ['Gauteng', 'Western Cape', 'KwaZulu-Natal', 'Eastern Cape', 'Other'];
const List<String> egyptianGovernorates = ['Cairo', 'Alexandria', 'Giza', 'Qalyubia', 'Other'];
const List<String> nigerianStates = ['Lagos', 'Kano', 'Rivers', 'Oyo', 'Kaduna', 'Other'];
const List<String> kenyanCounties = ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Other'];
const List<String> moroccanRegions = ['Casablanca-Settat', 'Rabat-Salé-Kénitra', 'Fès-Meknès', 'Marrakesh-Safi', 'Other'];

/// Standardized test types
const List<String> standardizedTests = [
  'SAT',
  'ACT',
  'A-Levels',
  'IB Diploma',
  'Baccalauréat (French Bac)',
  'Abitur (German)',
  'Gaokao (Chinese)',
  'CBSE/ICSE (Indian)',
  'ATAR (Australian)',
  'Matric (South African)',
  'Other',
  'None',
];

/// Field of study options
const List<String> fieldsOfStudy = [
  'Business & Management',
  'Computer Science & IT',
  'Engineering',
  'Medicine & Health Sciences',
  'Law',
  'Arts & Humanities',
  'Social Sciences',
  'Natural Sciences',
  'Mathematics & Statistics',
  'Education',
  'Architecture',
  'Design & Creative Arts',
  'Media & Communications',
  'Environmental Studies',
  'Agriculture',
  'Hospitality & Tourism',
  'Undecided',
];

/// Common university majors (comprehensive list for dropdown selection)
const List<String> commonMajors = [
  // Business & Management
  'Accounting',
  'Business Administration',
  'Finance',
  'Marketing',
  'Economics',
  'International Business',
  'Management',
  'Human Resources Management',
  'Entrepreneurship',
  'Supply Chain Management',
  'Real Estate',

  // Computer Science & IT
  'Computer Science',
  'Software Engineering',
  'Information Technology',
  'Data Science',
  'Cybersecurity',
  'Artificial Intelligence',
  'Computer Engineering',
  'Information Systems',
  'Web Development',
  'Game Development',

  // Engineering
  'Mechanical Engineering',
  'Electrical Engineering',
  'Civil Engineering',
  'Chemical Engineering',
  'Aerospace Engineering',
  'Biomedical Engineering',
  'Industrial Engineering',
  'Environmental Engineering',
  'Materials Science Engineering',
  'Petroleum Engineering',
  'Nuclear Engineering',
  'Agricultural Engineering',

  // Medicine & Health Sciences
  'Medicine',
  'Nursing',
  'Pharmacy',
  'Dentistry',
  'Public Health',
  'Physical Therapy',
  'Occupational Therapy',
  'Nutrition',
  'Veterinary Medicine',
  'Medical Laboratory Science',
  'Radiography',
  'Speech-Language Pathology',

  // Natural Sciences
  'Biology',
  'Chemistry',
  'Physics',
  'Biochemistry',
  'Biotechnology',
  'Microbiology',
  'Genetics',
  'Neuroscience',
  'Molecular Biology',
  'Environmental Science',
  'Marine Biology',
  'Astronomy',

  // Mathematics & Statistics
  'Mathematics',
  'Statistics',
  'Applied Mathematics',
  'Actuarial Science',
  'Computational Mathematics',

  // Social Sciences
  'Psychology',
  'Sociology',
  'Political Science',
  'International Relations',
  'Anthropology',
  'Geography',
  'Social Work',
  'Criminal Justice',
  'Urban Planning',

  // Arts & Humanities
  'English Literature',
  'History',
  'Philosophy',
  'Languages',
  'Linguistics',
  'Religious Studies',
  'Classics',
  'Art History',
  'Music',
  'Theater Arts',
  'Creative Writing',

  // Law
  'Law',
  'Legal Studies',
  'Paralegal Studies',

  // Education
  'Elementary Education',
  'Secondary Education',
  'Special Education',
  'Educational Psychology',
  'Educational Leadership',
  'Curriculum and Instruction',

  // Architecture & Design
  'Architecture',
  'Interior Design',
  'Landscape Architecture',
  'Urban Design',
  'Industrial Design',
  'Graphic Design',
  'Fashion Design',

  // Media & Communications
  'Journalism',
  'Public Relations',
  'Advertising',
  'Film Studies',
  'Broadcasting',
  'Digital Media',
  'Communications',

  // Other Fields
  'Agriculture',
  'Hospitality Management',
  'Tourism Management',
  'Sports Management',
  'Performing Arts',
  'Fine Arts',
  'Photography',
  'Library Science',
  'Undecided',
];

/// University preferences
const List<String> universitySizePreferences = [
  'Small (< 5,000 students)',
  'Medium (5,000 - 15,000 students)',
  'Large (15,000 - 30,000 students)',
  'Very Large (> 30,000 students)',
  'No Preference',
];

const List<String> universityTypePreferences = [
  'Public',
  'Private',
  'No Preference',
];

const List<String> locationTypePreferences = [
  'Urban',
  'Suburban',
  'Rural',
  'No Preference',
];

/// Budget ranges (annual tuition in USD)
const List<String> budgetRanges = [
  'Under \$10,000',
  '\$10,000 - \$20,000',
  '\$20,000 - \$30,000',
  '\$30,000 - \$50,000',
  '\$50,000 - \$70,000',
  'Over \$70,000',
  'No Limit',
];

/// Campus features
const List<String> campusFeatures = [
  'Strong Sports Programs',
  'Active Greek Life',
  'Research Opportunities',
  'Study Abroad Programs',
  'Internship Programs',
  'Diverse Student Body',
  'Strong Alumni Network',
  'Modern Facilities',
  'On-Campus Housing',
  'Active Student Organizations',
];
