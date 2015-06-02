-- AI Peace
UPDATE Defines
SET Value = '15'
WHERE Name = 'REQUEST_PEACE_TURN_THRESHOLD' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_SETTLER_TWEAKS' AND Value= 1 );

-- Settler Stuff

UPDATE Defines
SET Value = '35'
WHERE Name = 'BUILD_ON_RIVER_PERCENT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_SETTLER_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '35'
WHERE Name = 'SETTLER_BUILD_ON_COAST_PERCENT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_SETTLER_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '-10'
WHERE Name = 'BUILD_ON_RESOURCE_PERCENT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_SETTLER_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '3'
WHERE Name = 'SETTLER_STRATEGIC_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_SETTLER_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '5'
WHERE Name = 'AI_CITYSTRATEGY_WANT_TILE_IMPROVERS_MINIMUM_SIZE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE AICityStrategies
SET WeightThreshold = '1'
WHERE Type = 'AICITYSTRATEGY_WANT_TILE_IMPROVERS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '6'
WHERE Name = 'SETTLER_DISTANCE_DROPOFF_MODIFIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_SETTLER_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '8'
WHERE Name = 'SETTLER_EVALUATION_DISTANCE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_SETTLER_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '20000'
WHERE Name = 'AI_STRATEGY_MINIMUM_SETTLE_FERTILITY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '70'
WHERE Name = 'AI_STRATEGY_AREA_IS_FULL_PERCENT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '2'
WHERE Name = 'AI_DIPLO_PLOT_RANGE_FROM_CITY_HOME_FRONT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '14'
WHERE Name = 'CITY_RING_1_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '10'
WHERE Name = 'CITY_RING_2_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '6'
WHERE Name = 'CITY_RING_3_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '10'
WHERE Name = 'SETTLER_FOOD_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '8'
WHERE Name = 'SETTLER_PRODUCTION_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '6'
WHERE Name = 'SETTLER_GOLD_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '3'
WHERE Name = 'SETTLER_SCIENCE_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '3'
WHERE Name = 'SETTLER_FAITH_MULTIPLIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE AIEconomicStrategy_Player_Flavors
SET Flavor = '100'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_REALLY_EXPAND_TO_OTHER_CONTINENTS' AND FlavorType = 'FLAVOR_EXPANSION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_Player_Flavors
SET Flavor = '100'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_EXPAND_TO_OTHER_CONTINENTS' AND FlavorType = 'FLAVOR_EXPANSION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '15'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_GS_CULTURE' AND FlavorType = 'FLAVOR_EXPANSION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

-- Combat Stuff
UPDATE Defines
SET Value = '2500'
WHERE Name = 'AI_CITYSTRATEGY_OPERATION_UNIT_BASE_WEIGHT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '4'
WHERE Name = 'AI_MILITARY_BARBARIANS_FOR_MINOR_THREAT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '300'
WHERE Type = 'TACTICAL_ESCORT_EMBARKED_UNIT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '40'
WHERE Type = 'TACTICAL_ATTACK_LOW_PRIORITY_CIVILIAN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '60'
WHERE Type = 'TACTICAL_ATTACK_MEDIUM_PRIORITY_CIVILIAN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '90'
WHERE Type = 'TACTICAL_ATTACK_HIGH_PRIORITY_CIVILIAN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '100'
WHERE Type = 'TACTICAL_PILLAGE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '200'
WHERE Type = 'TACTICAL_PILLAGE_CITADEL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '50'
WHERE Type = 'TACTICAL_PILLAGE_CITADEL_NEXT_TURN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '25'
WHERE Type = 'TACTICAL_PILLAGE_NEXT_TURN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '100'
WHERE Type = 'TACTICAL_PILLAGE_RESOURCE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET Priority = '40'
WHERE Type = 'TACTICAL_PILLAGE_RESOURCE_NEXT_TURN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET OperationsCanRecruit = '1'
WHERE Type = 'TACTICAL_POSTURE_HEDGEHOG' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET OperationsCanRecruit = '1'
WHERE Type = 'TACTICAL_MOVE_OPERATIONS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET OperationsCanRecruit = '1'
WHERE Type = 'TACTICAL_OFFENSIVE_POSTURE_MOVES' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- Policy Decision Stuff

UPDATE Policy_Flavors
SET Flavor = '15'
WHERE PolicyType = 'POLICY_PIETY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

UPDATE Policy_Flavors
SET Flavor = '15'
WHERE PolicyType = 'POLICY_LIBERTY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

UPDATE Policy_Flavors
SET Flavor = '15'
WHERE PolicyType = 'POLICY_TRADITION' AND FlavorType = 'FLAVOR_CULTURE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

UPDATE Policy_Flavors
SET Flavor = '15'
WHERE PolicyType = 'POLICY_TRADITION' AND FlavorType = 'FLAVOR_GROWTH' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

UPDATE Policy_Flavors
SET Flavor = '10'
WHERE PolicyType = 'POLICY_TRADITION' AND FlavorType = 'FLAVOR_WONDER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '95'
WHERE Name = 'POLICY_WEIGHT_PERCENT_DROP_NEW_BRANCH' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '40'
WHERE Name = 'IDEOLOGY_SCORE_PER_FREE_TENET' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '15'
WHERE Name = 'IDEOLOGY_SCORE_HAPPINESS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- AI Strategy
-- 8
UPDATE Defines
SET Value = '4'
WHERE Name = 'APPROACH_NEUTRAL_DEFAULT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 5
UPDATE Defines
SET Value = '8'
WHERE Name = 'APPROACH_WAR_CONQUEST_GRAND_STRATEGY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 3
UPDATE Defines
SET Value = '5'
WHERE Name = 'APPROACH_WAR_CURRENTLY_WAR' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- 2
UPDATE Defines
SET Value = '3'
WHERE Name = 'APPROACH_WAR_CURRENTLY_DECEPTIVE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- 0
UPDATE Defines
SET Value = '2'
WHERE Name = 'APPROACH_DECEPTIVE_MILITARY_THREAT_MINOR' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- 0
UPDATE Defines
SET Value = '2'
WHERE Name = 'APPROACH_DECEPTIVE_MILITARY_THREAT_CRITICAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- 2
UPDATE Defines
SET Value = '4'
WHERE Name = 'APPROACH_HOSTILE_MILITARY_THREAT_NONE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- -12
UPDATE Defines
SET Value = '-10'
WHERE Name = 'APPROACH_WAR_PLANNING_WAR_WITH_ANOTHER_PLAYER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- -12
UPDATE Defines
SET Value = '-10'
WHERE Name = 'APPROACH_DECEPTIVE_PLANNING_WAR_WITH_ANOTHER_PLAYER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- 150
UPDATE Defines
SET Value = '175'
WHERE Name = 'APPROACH_WAR_PROJECTION_GOOD_PERCENT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- 180
UPDATE Defines
SET Value = '200'
WHERE Name = 'APPROACH_WAR_PROJECTION_VERY_GOOD_PERCENT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- 15
UPDATE Defines
SET Value = '5'
WHERE Name = 'APPROACH_RANDOM_PERCENT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_POLICY_TWEAKS' AND Value= 1 );

-- Military Strategy Flavors
DELETE FROM Unit_Flavors
WHERE UnitType = 'UNIT_ANTI_AIRCRAFT_GUN' AND FlavorType = 'FLAVOR_DEFENSE';

DELETE FROM AIMilitaryStrategy_Player_Flavors
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_AT_WAR';

DELETE FROM AIMilitaryStrategy_Player_Flavors
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WINNING_WARS';

DELETE FROM AIMilitaryStrategy_Player_Flavors
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_LOSING_WARS';

DELETE FROM AIMilitaryStrategy_City_Flavors
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_AT_WAR';

DELETE FROM AIMilitaryStrategy_City_Flavors
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WINNING_WARS';

DELETE FROM AIMilitaryStrategy_City_Flavors
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_LOSING_WARS';

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '40'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WAR_MOBILIZATION' AND FlavorType = 'FLAVOR_OFFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '20'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WAR_MOBILIZATION' AND FlavorType = 'FLAVOR_DEFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '20'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WAR_MOBILIZATION' AND FlavorType = 'FLAVOR_RANGED' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '5'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WAR_MOBILIZATION' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '5'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WAR_MOBILIZATION' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

INSERT INTO AIMilitaryStrategy_Player_Flavors (
AIMilitaryStrategyType, FlavorType, Flavor)
SELECT 'MILITARYAISTRATEGY_WAR_MOBILIZATION', 'FLAVOR_NAVAL_RECON' , '5'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '-25'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_WAR_MOBILIZATION' AND FlavorType = 'FLAVOR_EXPANSION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '15'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_NEED_ANTIAIR' AND FlavorType = 'FLAVOR_ANTIAIR' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '25'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_NEED_AIR_CARRIER' AND FlavorType = 'FLAVOR_AIR_CARRIER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '50'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_NEED_AIR' AND FlavorType = 'FLAVOR_AIR' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '15'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE' AND FlavorType = 'FLAVOR_OFFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '25'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE' AND FlavorType = 'FLAVOR_DEFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

INSERT INTO AIMilitaryStrategy_Player_Flavors (
AIMilitaryStrategyType, FlavorType, Flavor)
SELECT 'MILITARYAISTRATEGY_EMPIRE_DEFENSE', 'FLAVOR_MOBILE' , '10'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '5'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '35'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL' AND FlavorType = 'FLAVOR_OFFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_Player_Flavors
SET Flavor = '50'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL' AND FlavorType = 'FLAVOR_DEFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

INSERT INTO AIMilitaryStrategy_Player_Flavors (
AIMilitaryStrategyType, FlavorType, Flavor)
SELECT 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL', 'FLAVOR_MOBILE' , '15'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

INSERT INTO AIMilitaryStrategy_Player_Flavors (
AIMilitaryStrategyType, FlavorType, Flavor)
SELECT 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL', 'FLAVOR_AIR' , '30'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

-- City Strategy Flavors

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '10'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE' AND FlavorType = 'FLAVOR_OFFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '25'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE' AND FlavorType = 'FLAVOR_DEFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '5'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

INSERT INTO AIMilitaryStrategy_City_Flavors (
AIMilitaryStrategyType, FlavorType, Flavor)
SELECT 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL', 'FLAVOR_MOBILE' , '10'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

INSERT INTO AIMilitaryStrategy_City_Flavors (
AIMilitaryStrategyType, FlavorType, Flavor)
SELECT 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL', 'FLAVOR_AIR' , '25'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '10'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '25'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL' AND FlavorType = 'FLAVOR_OFFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '35'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL' AND FlavorType = 'FLAVOR_DEFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

INSERT INTO AIMilitaryStrategy_City_Flavors (
AIMilitaryStrategyType, FlavorType, Flavor)
SELECT 'MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL', 'FLAVOR_MOBILE' , '20'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='MILITARYAISTRATEGY_EMPIRE_DEFENSE_CRITICAL' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '15'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_NEED_NAVAL_UNITS' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIMilitaryStrategy_City_Flavors
SET Flavor = '25'
WHERE AIMilitaryStrategyType = 'MILITARYAISTRATEGY_NEED_NAVAL_UNITS_CRITICAL' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

-- Economic Strategies
UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-50'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND FlavorType = 'FLAVOR_OFFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-10'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND FlavorType = 'FLAVOR_DEFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-10'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND FlavorType = 'FLAVOR_NAVAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-50'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND FlavorType = 'FLAVOR_NAVAL_RECON' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-50'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND FlavorType = 'FLAVOR_RANGED' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-50'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND FlavorType = 'FLAVOR_MOBILE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-50'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND FlavorType = 'FLAVOR_RECON' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-25'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_LOSING_MONEY' AND FlavorType = 'FLAVOR_OFFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategy_City_Flavors
SET Flavor = '-10'
WHERE AIEconomicStrategyType = 'ECONOMICAISTRATEGY_LOSING_MONEY' AND FlavorType = 'FLAVOR_DEFENSE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategies
SET MinimumNumTurnsExecuted = '10'
WHERE Type = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE AIEconomicStrategies
SET CheckTriggerTurnCount = '10'
WHERE Type = 'ECONOMICAISTRATEGY_TOO_MANY_UNITS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

-- Other

--7
UPDATE Defines
SET Value = '8'
WHERE Name = 'AI_CITIZEN_VALUE_SCIENCE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '3'
WHERE Name = 'RELIGION_MAX_MISSIONARIES' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '8'
WHERE Name = 'RELIGION_MISSIONARY_RANGE_IN_TURNS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE Defines
SET Value = '75'
WHERE Name = 'AI_OPERATIONAL_PERCENT_HEALTH_FOR_OPERATION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET OperationsCanRecruit = '1'
WHERE Type = 'TACTICAL_GARRISON_ALREADY_THERE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

UPDATE TacticalMoves
SET OperationsCanRecruit = '1'
WHERE Type = 'TACTICAL_GUARD_IMPROVEMENT_ALREADY_THERE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_CITYSTRATEGY_TWEAKS' AND Value= 1 );

-- Diplomacy and War Likelihood

-- 1.0
UPDATE Defines
SET Value = '1.15'
WHERE Name = 'AI_DANGER_MAJOR_APPROACH_WAR' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 0.2
UPDATE Defines
SET Value = '0.3'
WHERE Name = 'AI_DANGER_MAJOR_APPROACH_HOSTILE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 0.1
UPDATE Defines
SET Value = '0.2'
WHERE Name = 'AI_DANGER_MAJOR_APPROACH_DECEPTIVE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 0.5
UPDATE Defines
SET Value = '0.65'
WHERE Name = 'AI_DANGER_MAJOR_APPROACH_GUARDED' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 0.9
UPDATE Defines
SET Value = '1.12'
WHERE Name = 'AI_DANGER_MAJOR_APPROACH_AFRAID' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 0.1
UPDATE Defines
SET Value = '0.15'
WHERE Name = 'AI_DANGER_MAJOR_APPROACH_NEUTRAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 30
UPDATE Defines
SET Value = '45'
WHERE Name = 'OPINION_WEIGHT_LAND_FIERCE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 20
UPDATE Defines
SET Value = '35'
WHERE Name = 'OPINION_WEIGHT_LAND_STRONG' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 10
UPDATE Defines
SET Value = '20'
WHERE Name = 'OPINION_WEIGHT_LAND_WEAK' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- -6
UPDATE Defines
SET Value = '-8'
WHERE Name = 'OPINION_WEIGHT_LAND_NONE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 30
UPDATE Defines
SET Value = '45'
WHERE Name = 'OPINION_WEIGHT_VICTORY_FIERCE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 20 
UPDATE Defines
SET Value = '30'
WHERE Name = 'OPINION_WEIGHT_VICTORY_STRONG' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- -5 
UPDATE Defines
SET Value = '-7'
WHERE Name = 'OPINION_WEIGHT_ADOPTING_HIS_RELIGION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- -3
UPDATE Defines
SET Value = '-7'
WHERE Name = 'OPINION_WEIGHT_ADOPTING_MY_RELIGION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 5
UPDATE Defines
SET Value = '-10'
WHERE Name = 'OPINION_WEIGHT_SAME_LATE_POLICIES' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 5
UPDATE Defines
SET Value = '10'
WHERE Name = 'OPINION_WEIGHT_DIFFERENT_LATE_POLICIES' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 15
UPDATE Defines
SET Value = '20'
WHERE Name = 'OPINION_WEIGHT_DOF_WITH_ENEMY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 50
UPDATE Defines
SET Value = '40'
WHERE Name = 'OPINION_WEIGHT_WAR_FRIEND_EACH' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 60
UPDATE Defines
SET Value = '65'
WHERE Name = 'OPINION_WEIGHT_WAR_ME_FRIENDS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );

-- 14
UPDATE Defines
SET Value = '20'
WHERE Name = 'VICTORY_DISPUTE_GRAND_STRATEGY_MATCH_POSITIVE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );
		
-- 10
UPDATE Defines
SET Value = '15'
WHERE Name = 'VICTORY_DISPUTE_GRAND_STRATEGY_MATCH_LIKELY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );
		
-- 6
UPDATE Defines
SET Value = '4'
WHERE Name = 'VICTORY_DISPUTE_GRAND_STRATEGY_MATCH_UNSURE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE_MILITARY_TWEAKS' AND Value= 1 );


-- 3 
-- Makes trade partnersips and trade deals last a bit longer

UPDATE Defines
SET Value = '2'
WHERE Name = 'DEAL_VALUE_PER_TURN_DECAY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

-- -30 
-- Makes trade partnersips and trade deals last a bit longer

UPDATE Defines
SET Value = '-40'
WHERE Name = 'OPINION_WEIGHT_TRADE_MAX' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

-- Sentry Points
UPDATE Defines
SET Value = '100'
WHERE Name = 'AI_HOMELAND_MOVE_PRIORITY_SENTRY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '1'
WHERE Name = 'AI_HOMELAND_MOVE_PRIORITY_PATROL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

-- Worker Stuff
UPDATE Defines
SET Value = '500'
WHERE Name = 'BUILDER_TASKING_BASELINE_REPAIR' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '250'
WHERE Name = 'BUILDER_TASKING_BASELINE_BUILD_ROUTES' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '150'
WHERE Name = 'BUILDER_TASKING_BASELINE_BUILD_RESOURCE_IMPROVEMENTS' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '1'
WHERE Name = 'AI_HOMELAND_MOVE_PRIORITY_PATROL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE Defines
SET Value = '0'
WHERE Name = 'STRATEGIC_RESOURCE_EXHAUSTED_PENALTY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

-- City Specialization Stuff

UPDATE CitySpecialization_TargetYields
SET Yield = '175'
WHERE YieldType = 'YIELD_GOLD' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE CitySpecialization_TargetYields
SET Yield = '250'
WHERE YieldType = 'YIELD_SCIENCE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE CitySpecialization_TargetYields
SET Yield = '250'
WHERE YieldType = 'YIELD_FOOD' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );

UPDATE CitySpecialization_TargetYields
SET Yield = '175'
WHERE YieldType = 'YIELD_PRODUCTION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );
